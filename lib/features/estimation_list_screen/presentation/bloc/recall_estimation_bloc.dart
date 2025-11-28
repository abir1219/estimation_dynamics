import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/features/product_list_dialog/data/model/estimation_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../../../core/utils/constant_variable.dart';
import '../../../product_list_dialog/data/model/estimation_response_model_01.dart';
import '../../data/recall_repository.dart';

part 'recall_estimation_event.dart';

part 'recall_estimation_state.dart';

class RecallEstimationBloc
    extends Bloc<RecallEstimationEvent, RecallEstimationState> {
  final RecallRepository _recallRepository;

  RecallEstimationBloc(this._recallRepository)
      : super(RecallEstimationInitial()) {
    on<RecallEstimationDataEvent>(_recallEstimation);
  }

  FutureOr<void> _recallEstimation(RecallEstimationDataEvent event,
      Emitter<RecallEstimationState> emit) async {
    emit(RecallEstimationLoading());
    String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"REPRINTFORESTIMATEAPP\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
    "ObjStrVal": "{\\"RefNumber\\":\\"${event.refNo}\\",\\"RefType\\":11}"
  }
  ''';

    Map<String, dynamic> header = {
      'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': ConstantVariable.operatingUnitNumber,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final value =
          await _recallRepository.recallEstimation(jsonString, header);
      final estimationResponseModel = EstimationResponseModel_01.fromJson(value);
      debugPrint("Recall_Estimation_VALUE-->$value");

      emit(RecallEstimationLoaded(
          estimationResponseModel: estimationResponseModel,refNo:event.refNo));
    } catch (error) {
      debugPrint("Recall_Estimation-->$error");
      // emit(const ProductState(status: ProductStatus.initial));
      emit(RecallEstimationError(errMsg: error.toString()));
      // Optionally, you can add an error field in ProductState and emit here
    }
  }
}
