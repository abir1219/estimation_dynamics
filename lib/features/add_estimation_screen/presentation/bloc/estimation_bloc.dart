import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/features/salesman_dialog/data/model/employee_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../../../core/utils/environment_variable.dart';
import '../../../search_customer_dialog/data/customer_model.dart';
import '../../data/repository/estimation_repository.dart';

part 'estimation_event.dart';

part 'estimation_state.dart';

class EstimationBloc extends Bloc<EstimationEvent, EstimationState> {
  final EstimationRepository _estimationRepository;

  EstimationBloc(this._estimationRepository) : super(EstimationDataState()) {
    on<GenerateEstimationNoEvent>(_generateEstimationNumber);
    on<SetSelectedCustomerEvent>(_onSetSelectedCustomer); // 👈 register handler
    on<ResetEstimationEvent>(_onResetEstimation); // 👈 register handler
    on<FetchSalesmanEvent>(_onFetchSalesman); // 👈 register handler
    on<SearchEmployeeEvent>(_searchEmployee);
    on<SelectSalesmanEvent>(_onSetSelectSalesman);
    on<ResetSalesmanStateEvent>(_resetSalesmanState);
  }

  FutureOr<void> _resetSalesmanState(
      ResetSalesmanStateEvent event, Emitter<EstimationState> emit) async {
    emit(const EstimationDataState()); // reset all
  }


  FutureOr<void> _onFetchSalesman(
      FetchSalesmanEvent event,
      Emitter<EstimationState> emit,
      ) async {
    // Emit loading state
    if (state is EstimationDataState) {
      emit((state as EstimationDataState).copyWith(isLoading: true, error: null));
    }

    try {
      String jsonString = '''
    {
      "RequestVal": "{\\"Operation\\":\\"GETSALESREPRESENTATIVE\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
      "ObjStrVal": ""
    }
    ''';

      Map<String, dynamic> header = {
        'Authorization':
        'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
        'oun': EnvironmentVariable.OperatingUnitNumber,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final value = await _estimationRepository.fetchSalesmanList(jsonString, header);
      final salesmanModel = SalesmanModel.fromJson(jsonDecode(value['DataResult']));
      final fullList = salesmanModel.payload?.payload ?? [];

      // Update state with salesmanModel and full list
      if (state is EstimationDataState) {
        final currentState = state as EstimationDataState; // cast once
        emit(currentState.copyWith(
          isLoading: false,
          error: null,
          // fullSalesmanList: fullList, // use currentState
          filteredSalesmanList: fullList, // use currentState
        ));
      }
    } catch (error) {
      if (state is EstimationDataState) {
        emit((state as EstimationDataState).copyWith(
          isLoading: false,
          error: error.toString(),
        ));
      }
    }
  }

  /*FutureOr<void> _searchEmployee(
    SearchEmployeeEvent event,
    Emitter<EstimationState> emit,
  ) {
    if (state is FetchSalesmanStateLoaded) {
      final currentState = state as FetchSalesmanStateLoaded;

      final query = event.search.trim().toLowerCase();

      final filteredList = query.isEmpty
          ? currentState.salesmanModel.payload?.payload ?? []
          : currentState.salesmanModel.payload?.payload
                  ?.where((s) => s.text!.toLowerCase().contains(query))
                  .toList() ??
              [];

      emit(FetchSalesmanStateLoaded(
        salesmanModel: currentState.salesmanModel,
        filteredSalesmanList: filteredList,
      ));

      debugPrint("Filtered Salesman: ${filteredList.length}");
    }
  }*/
  /*FutureOr<void> _searchEmployee(
      SearchEmployeeEvent event,
      Emitter<EstimationDataState> emit,
      ) {
    // Ensure current state has salesmanModel
    if (state.salesmanModel != null) {
      final query = event.search.trim().toLowerCase();

      final fullList = state.salesmanModel?.payload?.payload ?? [];

      final filteredList = query.isEmpty
          ? fullList
          : fullList.where((s) => s.text!.toLowerCase().contains(query)).toList();

      // Update the state with filtered list
      emit(state.copyWith(filteredSalesmanList: filteredList));

      debugPrint("Filtered Salesman: ${filteredList.length}");
    }
  }*/

  FutureOr<void> _searchEmployee(
      SearchEmployeeEvent event,
      Emitter<EstimationState> emit,
      ) {
    if (state is EstimationDataState) {
      final currentState = state as EstimationDataState;
      final fullList = currentState.salesmanModel?.payload?.payload ?? [];

      final query = event.search.trim().toLowerCase();
      debugPrint("Filtered Salesman: $query");
      final filteredList = query.isEmpty
          ? fullList
          : fullList.where((s) => s.text!.toLowerCase().contains(query)).toList();

      emit(currentState.copyWith(
        filteredSalesmanList: filteredList,
      ));

      debugPrint("Filtered Salesman Length: ${filteredList.length}");
    }
  }


  FutureOr<void> _onSetSelectedCustomer(
      SetSelectedCustomerEvent event, Emitter<EstimationState> emit) {
    final current = state as EstimationDataState;
    emit(current.copyWith(customer: event.customer));
  }

  FutureOr<void> _onSetSelectSalesman(
      SelectSalesmanEvent event, Emitter<EstimationState> emit) {
    final current = state as EstimationDataState;
    emit(current.copyWith(salesman: event.salesman));
  }

  FutureOr<void> _onResetEstimation(
      ResetEstimationEvent event, Emitter<EstimationState> emit) {
    emit(const EstimationDataState(customer: null, salesman: null, refNumber: null));
  }

  FutureOr<void> _generateEstimationNumber(
      GenerateEstimationNoEvent event, Emitter<EstimationState> emit) async {
    final current = state as EstimationDataState;
    emit(current.copyWith(isLoading: true));

    try {
      final value = await _estimationRepository.generateEstimateNo(
        '''
        {
          "RequestVal": "{\\"Operation\\":\\"ESTIMATENOFORAPP\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
          "ObjStrVal": ""
        }
        ''',
        {
          'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
          'oun': EnvironmentVariable.OperatingUnitNumber,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final dataResult = jsonDecode(value["DataResult"]);
      emit(current.copyWith(
        refNumber: dataResult["Payload"]["Payload"].replaceAll('_', '-'),
        isLoading: false,
      ));
    } catch (error) {
      emit(current.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
