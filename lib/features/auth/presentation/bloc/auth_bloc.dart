import 'package:ciu_announcement/core/bloc/base/base_bloc.dart';
import 'package:ciu_announcement/core/usecases/no_params.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/login_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/register_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/params/login_params.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/params/register_params.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/base/auth_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/login_requested_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/logout_reqeusted_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/register_requested_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/get_current_user_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/check_auth_status_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/base/auth_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_initial_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_loading_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_authenticated_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_unauthenticated_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_error_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _isLoggedInUseCase = isLoggedInUseCase,
       super(const AuthInitialState()) {
    on<LoginRequestedEvent>(_onLoginRequested);
    on<RegisterRequestedEvent>(_onRegisterRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(AuthAuthenticatedState(user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(AuthAuthenticatedState(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) => emit(const AuthUnauthenticatedState()),
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(AuthAuthenticatedState(user)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _isLoggedInUseCase(const NoParams());

    result.fold((failure) => emit(const AuthUnauthenticatedState()), (
      isLoggedIn,
    ) {
      if (isLoggedIn) {
        add(const GetCurrentUserEvent());
      } else {
        emit(const AuthUnauthenticatedState());
      }
    });
  }
}
