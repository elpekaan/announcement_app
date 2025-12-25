import 'package:ciu_announcement/features/auth/presentation/bloc/states/base/auth_state.dart';

class AuthErrorState extends AuthState{
  final String message;

  AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
  
}