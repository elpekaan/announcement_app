import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/base/auth_state.dart';

class AuthAuthenticatedState extends AuthState {
  final UserEntity user;

  const AuthAuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}
