import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/core/utils/constant_variable.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../data/model/login_model.dart';
import '../../data/model/store_model.dart';
import '../../data/repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var loginRepo = LoginRepository();

  LoginBloc(this.loginRepo) : super(LoginInitial()) {
    on<PasswordVisibilityChangeEvent>(_passwordVisibility);
    on<LoginUserEvent>(_login);
  }

  FutureOr<void> _passwordVisibility(
      PasswordVisibilityChangeEvent event, Emitter<LoginState> emit) {
    final currentState = state is PasswordVisibilityLogin
        ? state as PasswordVisibilityLogin
        : PasswordVisibilityLogin(); // Default state

    emit(PasswordVisibilityLogin(isVisible: !currentState.isVisible!));
  }

  FutureOr<void> _login(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(UserLoginLoading());
    //"RequestVal": "{\\"Operation\\":\\"LOGINS\\",\\"StoreId\\":\\"${event.storeId}\\", \\"StoreName\\": \\"${event.storeName}\\", \\"TerminalId\\": \\"${event.terminalId}\\"}",
    String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"LOGINS\\",\\"StoreId\\":\\"${event.storeId}\\", \\"StoreName\\": \\"${event.storeName}\\", \\"TerminalId\\": \\"${event.terminalId}\\"}",
    "ObjStrVal": ""
}
  ''';

    Map<String, dynamic> body = json.decode(jsonString);
    Map<String, dynamic> header = {
      'Authorization':
      'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': ConstantVariable.operatingUnitNumber,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    debugPrint("BODY-->$jsonString and Convert-->$body");

    await loginRepo
        .fetchApiCall(body, header)
        .then(
          (value) {
        var loginModel = LoginModel.fromJson(value);
        emit(UserLoginLoaded(loginModel.dataResult!.payload));
      },
    )
        .onError(
          (error, stackTrace) {
        emit(LoginError(error.toString()));
      },
    );
  }

}
