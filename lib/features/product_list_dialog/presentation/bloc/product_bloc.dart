import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/features/product_list_dialog/data/repository/product_repository.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../../../core/utils/constant_variable.dart';
import '../../../salesman_dialog/data/model/employee_model.dart';
import '../../../search_customer_dialog/data/customer_model.dart';
import '../../data/model/estimation_response_model.dart';
import '../../data/model/product_model.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(const ProductState()) {
    on<ScanItemEvent>(_scanItem);
    on<SelectProductEvent>(_selectProduct);
    // on<ResetProductStateEvent>(_resetProductState);
    on<SubmitProductEvent>(_submitProductState);
    on<DeleteProductStateEvent>(_deleteProductState);
  }

  // List<ProductPayload> selectedProduct = [];

  FutureOr<void> _resetProductState(
      ResetProductStateEvent event, Emitter<ProductState> emit) async {
    emit(const ProductState(status: ProductStatus.initial, productList: []));
    //selectedProduct.clear();
  }

  List<ProductPayload> updatedList = [];

  FutureOr<void> _scanItem(
      ScanItemEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.scanLoading));

    // double lineNum = selectedProduct.length.toDouble() + 1;
    // double lineNum = state.productList!.length.toDouble() + 1;
    double lineNum = updatedList.length.toDouble() + 1;

    debugPrint("LINE_NUMBER--->$lineNum");
    debugPrint("LENGTH--->${updatedList.length}");

    String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"SCANITEM\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
    "ObjStrVal": "{\\"ItemNum\\":\\"${event.itemNo}\\",\\"LineNum\\":$lineNum,\\"SalesPerson\\":\\"${event.salesman!.text}\\",\\"CustomerId\\":\\"${event.customer!.accountNumber}\\",\\"CustomerName\\":\\"${event.customer!.fullName}\\",\\"RefNumber\\":\\"${event.refNo}\\",\\"RefType\\":11}"
  }
  ''';

    Map<String, dynamic> header = {
      'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': ConstantVariable.OperatingUnitNumber,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final value = await _productRepository.scanItem(jsonString, header);
      final productModel = ProductModel.fromJson(value);
      debugPrint("VALUE-->$value");

      emit(state.copyWith(
        status: ProductStatus.scanLoaded,
        scannedItem: productModel.dataResult!.payload,
      ));
    } catch (error) {
      debugPrint("ScanItem_ERROR-->$error");
      emit(const ProductState(status: ProductStatus.initial));
      // Optionally, you can add an error field in ProductState and emit here
    }
  }


  FutureOr<void> _selectProduct(
      SelectProductEvent event,
      Emitter<ProductState> emit,
      ) {
    if (event.product == null){
      debugPrint("PRODUCT_STATUS-->${event.product == null}");
    }
    debugPrint("state.productList_01-->${state.selectedProductList}");
    // Copy the current list from state
    //final updatedList = List<ProductPayload>.from(state.productList);
    updatedList = List<ProductPayload>.from(state.selectedProductList ?? []);

    // Add new product
    updatedList.add(event.product!);
    debugPrint("state.productList-->${state.selectedProductList}");
    debugPrint("updatedList-->${updatedList.length}");
    // Recalculate total
    final totalAmount = updatedList.fold(
      0.0,
          (sum, product) => sum + product.lineTotal,
    );

    emit(state.copyWith(
      status: ProductStatus.submittedItems,
      selectedProductList: updatedList,
      totalAmount: totalAmount,
    ));

    // debugPrint("UPDATED_PRODUCT_LIST LENGTH --> ${updatedList.length}");
  }



  FutureOr<void> _submitProductState(
      SubmitProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.scanLoading));

    final listItems = event.selectedProductList!.asMap().entries.map((entry) {
      final product = entry.value;

      return {
        "ItemNum": product.itemBarcode,
        "LineNum": product.linenum,
        "SalesPerson": event.salesman?.text ?? "",
      };
    }).toList();

    /*String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"SAVEAPPTXN\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
    "ObjStrVal": "{\\"CustName\\":\\"${event.customer!.fullName}\\",\\"SalesPerson\\":\\"${event.salesman!.text}\\",\\"CustomerId\\":\\"${event.customer!.accountNumber}\\",\\"CustomerName\\":\\"${event.customer!.fullName}\\",\\"RefNumber\\":\\"${event.refNo}\\",\\"ListItem\\":$listItems"
  }
  ''';*/
    final requestBody = {
      "RequestVal": jsonEncode({
        "Operation": "SAVEAPPTXN",
        "AppKey": SharedPreferencesHelper.getString(AppConstants.APP_KEY),
      }),
      "ObjStrVal": jsonEncode({
        "CustName": event.customer?.fullName ?? "",
        "SalesPerson": event.salesman?.text ?? "",
        "CustomerId": event.customer?.accountNumber ?? "",
        "CustomerName": event.customer?.fullName ?? "",
        "RefNumber": event.refNo ?? "",
        "RefType": 11,
        "ListItem": listItems,
      }),
    };

    final jsonString = jsonEncode(requestBody);

    debugPrint("requestBody-->$requestBody");
    debugPrint("jsonString-->$jsonString");

    Map<String, dynamic> header = {
      'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': ConstantVariable.OperatingUnitNumber,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      await _productRepository.scanItem(jsonString, header).then((value) {
        //final productModel = ProductModel.fromJson(value);
        //debugPrint("VALUE-->${jsonDecode(value)}");
        // var val = jsonDecode(value);
        EstimationResponseModel estimationResponseData = EstimationResponseModel.fromJson(value);
        // final EstimationResponseModel estimationResponseData = EstimationResponseModel.fromJson(jsonDecode(value));

        emit(state.copyWith(
          status: ProductStatus.submitDone,
          estimationResponseModel: estimationResponseData,
          productList: [],
          selectedProductList: [],
          //scannedItem: productModel.dataResult!.payload,
        ));

      },);
    } catch (error) {
      debugPrint("ScanItem_ERROR-->$error");
      // Optionally, you can add an error field in ProductState and emit here
    }
  }

  FutureOr<void> _deleteProductState(DeleteProductStateEvent event, Emitter<ProductState> emit) {
    final updatedList = List<ProductPayload>.from(state.selectedProductList ?? []);
    updatedList.removeAt(event.index!);
    final totalAmount = updatedList.fold(
      0.0,
          (sum, product) => sum + product.lineTotal,
    );

    emit(state.copyWith(
      status: ProductStatus.submittedItems,
      selectedProductList: updatedList,
      totalAmount: totalAmount,
    ));
  }
}
