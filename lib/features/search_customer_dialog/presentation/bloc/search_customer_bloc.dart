import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/data/customer_model.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/data/customer_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../../../core/utils/environment_variable.dart';
import '../../../add_estimation_screen/presentation/bloc/estimation_bloc.dart';

part 'search_customer_event.dart';

part 'search_customer_state.dart';

class SearchCustomerBloc
    extends Bloc<SearchCustomerEvent, SearchCustomerState> {
  var customerRepository = CustomerRepository();

  final EstimationBloc estimationBloc; // inject the other bloc

  SearchCustomerBloc(this.customerRepository,this.estimationBloc) : super(SearchCustomerInitial()) {
    on<FetchCustomerEvent>(_fetchCustomer);
    on<ResetSearchCustomerStateEvent>(_resetCustomerState);
    on<SelectCustomerDataEvent>(_selectCustomer);
  }

  FutureOr<void> _selectCustomer(
      SelectCustomerDataEvent event, Emitter<SearchCustomerState> emit) async {
    //emit(SelectCustomerDataState(customer: event.customer));
    // 1️⃣ Update this bloc's state
    emit(SelectCustomerDataState(customer: event.customer));

    // 2️⃣ Dispatch an event to EstimationBloc
    estimationBloc.add(SetSelectedCustomerEvent(customer: event.customer));
  }

  FutureOr<void> _resetCustomerState(
      ResetSearchCustomerStateEvent event, Emitter<SearchCustomerState> emit) async {
    emit(SearchCustomerInitial());
  }

  FutureOr<void> _fetchCustomer(
      FetchCustomerEvent event, Emitter<SearchCustomerState> emit) async {
    emit(SearchCustomerLoading());

    debugPrint("REFNUMBER--->${event.refNumber}");
    String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"SEARCHCUSTOMER\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
    "ObjStrVal": "{\\"CustomerId\\":\\"\\",\\"CustomerName\\":\\"\\",\\"RefNumber\\":\\"${event.refNumber}\\",\\"RefType\\":${EnvironmentVariable.REFTYPE},\\"SearchTerm\\":\\"${event.customerName}\\"}"
}
  ''';

    Map<String, dynamic> body = json.decode(jsonString);
    Map<String, dynamic> header = {
      'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': EnvironmentVariable.OperatingUnitNumber,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    debugPrint("BODY-->$jsonString and Convert-->$body");

    await customerRepository.fetchCustomer(body, header).then(
      (value) {
        debugPrint("VALUE--->$value");
        var customerModel = CustomerModel.fromJson(value);
        debugPrint("customerModel--->${customerModel.dataResult!.payload!.payload!.customer!.length}");
        emit(SearchCustomerLoaded(customerModel: customerModel));
      },
    ).onError(
      (error, stackTrace) {
        debugPrint("ERROR--->$error");
        emit(SearchCustomerError(error.toString()));
      },
    );
  }
}
