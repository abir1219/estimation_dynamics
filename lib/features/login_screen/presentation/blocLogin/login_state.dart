part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class UserLoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

final class UserLoginLoaded extends LoginState {
  String? appKey;

  UserLoginLoaded(this.appKey);

  @override
  List<Object?> get props => [appKey];
}

final class PasswordVisibilityLogin extends LoginState {
  bool? isVisible;

  PasswordVisibilityLogin({this.isVisible = false});

  @override
  List<Object?> get props => [isVisible];
}


final class LoginError extends LoginState {
  final String? message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
