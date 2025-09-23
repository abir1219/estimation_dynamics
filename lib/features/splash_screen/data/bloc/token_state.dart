part of 'token_bloc.dart';

sealed class TokenState extends Equatable {
  const TokenState();
}

final class TokenInitial extends TokenState {
  @override
  List<Object> get props => [];
}

final class TokenLoading extends TokenState{
  @override
  List<Object?> get props => [];
}

final class TokenLoaded extends TokenState{
  final String? accessToken;

  const TokenLoaded(this.accessToken);
  @override
  List<Object?> get props => [accessToken];
}

final class TokenError extends TokenState {
  final String message;

  const TokenError(this.message);

  @override
  List<Object?> get props => [message];
}
