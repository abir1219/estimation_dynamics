part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class PasswordVisibilityChangeEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

final class LoginUserEvent extends LoginEvent{
  // final String? employeeId;
  final String? storeId;
  final String? storeName;
  final String? terminalId;
  // final String? password;

  const LoginUserEvent({this.storeId, this.storeName, this.terminalId});

  @override
  List<Object?> get props => [storeName,storeId,terminalId];
}

