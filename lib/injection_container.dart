import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/network/network_info/base/base_network_info.dart';
import 'package:ciu_announcement/core/network/network_info/network_info_impl.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:ciu_announcement/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ciu_announcement/features/auth/domain/repositories/auth_repository.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/login_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/register_usecase.dart';import 'package:ciu_announcement/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //============ CORE ============//

  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<BaseNetworkInfo>(() => NetworkInfoImpl());

  //============ AUTH FEATURE ============//
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // UserCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );
}
