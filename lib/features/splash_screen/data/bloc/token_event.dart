part of 'token_bloc.dart';

sealed class TokenEvent extends Equatable {
  const TokenEvent();
}

final class FetchTokenData extends TokenEvent{
  @override
  List<Object?> get props => [];

}
