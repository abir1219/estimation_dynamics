import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/core/utils/constant_variable.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../data/model/store_model.dart';
import '../../data/repository/login_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  var loginRepo = LoginRepository();

  StoreBloc(this.loginRepo) : super(StoreInitial(false)) {
    on<FetchStoreEvent>(_fetchStoreList);
  }

  FutureOr<void> _fetchStoreList(
      FetchStoreEvent event, Emitter<StoreState> emit) async {
    emit(StoreLoading(false));
    String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"GETSTORES\\"}",
    "ObjStrVal": ""
  }
  ''';

    Map<String, dynamic> body = json.decode(jsonString);
    Map<String, dynamic> header = {
      'Authorization':
      'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': ConstantVariable.OperatingUnitNumber,//'1400ST',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    debugPrint("BODY-->$jsonString and Convert-F->$body");

    await loginRepo
        .fetchApiCall(body, header)
        .then(
          (value) {
        StoreModel storeModel = StoreModel.fromJson(value);
        // debugPrint("storeModel===>${storeModel.dataResult!.payload![0].text}");
        // debugPrint("storeModel===>${storeModel.dataResult!.payload![0].value}");
        // emit(StoreLoaded(storeModel.dataResult!.payload!,));
        emit(StoreLoaded(storeModel.dataResult!.payload!, isVisible: true));
      },
    )
        .onError(
          (error, stackTrace) {
        emit(StoreError(error.toString()));
      },
    );
  }
}
