import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/core/utils/constant_variable.dart';
import 'package:estimation_dynamics/features/splash_screen/data/repository/token_repository.dart';
import 'package:flutter/foundation.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  var tokenRepo = TokenRepository();

  TokenBloc(this.tokenRepo) : super(TokenInitial()) {
    on<FetchTokenData>(_fetchTokenData);
  }

  FutureOr<void> _fetchTokenData(FetchTokenData event,Emitter<TokenState> emit) async{
    emit(TokenLoading());

    FormData body = FormData.fromMap({
      'grant_type': ConstantVariable.grantType,//'client_credentials',
      'client_id': ConstantVariable.clientId,//'e7db77ef-e2a5-4aea-9257-3db5bcfb76d5',
      'client_secret': ConstantVariable.clientSecret,//'Js~8Q~9Sx39gnjrOCan.SIp4LdpKij1cY2-gicpu',
      'resource': ConstantVariable.resource,//'api://f2482f98-b71f-4bb0-bca4-bcc397899116',
    });

    await tokenRepo.fetchTokenData(body).then((value) {
      if(kDebugMode){
        print("==ACCESS_TOKEN==${value['access_token']}");
      }
      emit(TokenLoaded(value['access_token']));
    },).onError((error, stackTrace) {
      emit(TokenError(error.toString()));
      if(kDebugMode){
        print("==TOKEN_ERROR==${error.toString()}");
      }
    },);
  }
}
