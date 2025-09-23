import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:estimation_dynamics/features/product_list_dialog/data/repository/product_repository.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../../../core/utils/environment_variable.dart';
import '../../../salesman_dialog/data/model/employee_model.dart';
import '../../../search_customer_dialog/data/customer_model.dart';
import '../../data/model/product_model.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(const ProductState()) {
    on<ScanItemEvent>(_scanItem);
    on<SelectProductEvent>(_selectProduct);
    on<ResetProductStateEvent>(_resetProductState);
    on<SubmitProductEvent>(_submitProductState);
  }

  List<ProductPayload> selectedProduct = [];

  FutureOr<void> _resetProductState(
      ResetProductStateEvent event, Emitter<ProductState> emit) async {
    emit(const ProductState(status: ProductStatus.initial, productList: []));
    selectedProduct.clear();
  }

  FutureOr<void> _scanItem(
      ScanItemEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.scanLoading));

    double lineNum = selectedProduct.length.toDouble() + 1;

    String jsonString = '''
  {
    "RequestVal": "{\\"Operation\\":\\"SCANITEM\\",\\"AppKey\\":\\"${SharedPreferencesHelper.getString(AppConstants.APP_KEY)}\\"}",
    "ObjStrVal": "{\\"ItemNum\\":\\"${event.itemNo}\\",\\"LineNum\\":$lineNum,\\"SalesPerson\\":\\"${event.salesman!.text}\\",\\"CustomerId\\":\\"${event.customer!.accountNumber}\\",\\"CustomerName\\":\\"${event.customer!.fullName}\\",\\"RefNumber\\":\\"${event.refNo}\\",\\"RefType\\":11}"
  }
  ''';

    Map<String, dynamic> header = {
      'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': EnvironmentVariable.OperatingUnitNumber,
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
      // Optionally, you can add an error field in ProductState and emit here
    }
  }

  /*FutureOr<void> _selectProduct(
      SelectProductEvent event, Emitter<ProductState> emit) {
    if (event.product != null) {
      // Take existing list from state (or empty if null)
      final updatedList = List<ProductPayload>.from(state.productList ?? []);

      // Add the new product
      updatedList.add(event.product!);

      // Compute total amount
      final totalAmount =
      updatedList.fold(0.0, (sum, product) => sum + product.lineTotal);

      // Emit new state with updated list
      emit(state.copyWith(
        status: ProductStatus.submittedItems,
        productList: updatedList,
        totalAmount: totalAmount,
      ));

      debugPrint("UPDATED_PRODUCT_LIST LENGTH --> ${updatedList.length}");
    }
  }*/

  FutureOr<void> _selectProduct(
      SelectProductEvent event,
      Emitter<ProductState> emit,
      ) {
    //if (event.product == null) return; // valid in void function

    // final updatedList = List<ProductPayload>.from(state.productList ?? []);
    //selectedProduct = List<ProductPayload>.from(state.productList ?? []);
    selectedProduct.add(event.product!);

    final totalAmount =
    selectedProduct.fold(0.0, (sum, product) => sum + product.lineTotal);

    emit(state.copyWith(
      status: ProductStatus.submittedItems,
      productList: selectedProduct,
      totalAmount: totalAmount,
    ));

    debugPrint("UPDATED_PRODUCT_LIST LENGTH --> ${selectedProduct.length}");
  }

  /*FutureOr<void> _selectProduct(
      SelectProductEvent event, Emitter<ProductState> emit) {
    debugPrint("EVENT_PRODUCT-->${event.product}");
    if (event.product != null) {
      // Make sure we are working with the existing list from state
      final updatedList = List<ProductPayload>.from(state.productList ?? []);

      updatedList.add(event.product!); // add new product
      debugPrint("UPDATED_PRODUCT_LIST-->$updatedList");

      double totalAmount =
      updatedList.fold(0.0, (sum, product) => sum + product.lineTotal);

      emit(state.copyWith(
        status: ProductStatus.submittedItems,
        productList: updatedList, // emit updated list
        totalAmount: totalAmount,
      ));
    }
  }*/


  /*FutureOr<void> _selectProduct(
      SelectProductEvent event, Emitter<ProductState> emit) {
    if (event.product != null) {
      selectedProduct.add(event.product!);

      double totalAmount =
          selectedProduct.fold(0.0, (sum, product) => sum + product.lineTotal);

      emit(state.copyWith(
        status: ProductStatus.submittedItems,
        productList: List.from(selectedProduct), // make a copy
        totalAmount: totalAmount,
      ));
    }
  }*/

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

    Map<String, dynamic> header = {
      'Authorization':
          'bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}',
      'oun': EnvironmentVariable.OperatingUnitNumber,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final value = await _productRepository.scanItem(jsonString, header);
      //final productModel = ProductModel.fromJson(value);
      debugPrint("VALUE-->$value");

      emit(state.copyWith(
        status: ProductStatus.submitDone,
        productList: [],
        //scannedItem: productModel.dataResult!.payload,
      ));
    } catch (error) {
      debugPrint("ScanItem_ERROR-->$error");
      // Optionally, you can add an error field in ProductState and emit here
    }
  }
}
