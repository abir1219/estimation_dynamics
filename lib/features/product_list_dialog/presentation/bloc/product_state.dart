/*
part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
}

final class ProductInitial extends ProductState {
  @override
  List<Object> get props => [];
}

final class ScanItemStateLoading extends ProductState{
  @override
  List<Object?> get props => [];
}

final class ScanItemStateLoaded extends ProductState{
  final ProductPayload productPayload;

  const ScanItemStateLoaded({required this.productPayload});

  @override
  List<Object?> get props => [productPayload];
}

final class SubmittedItemsState extends ProductState{
  final List<ProductPayload> productList;
  final double totalAmount;

  const SubmittedItemsState({required this.productList,required this.totalAmount});

  @override
  List<Object?> get props => [productList,totalAmount];

}*/
part of 'product_bloc.dart';

enum ProductStatus {
  initial,
  scanLoading,
  scanLoaded,
  submittedItems,
  submitDone,
  submitError
}

class ProductState extends Equatable {
  final ProductStatus status;
  final ProductPayload? scannedItem;
  final List<ProductPayload>? productList;
  final List<ProductPayload>? selectedProductList;
  final EstimationResponseModel? estimationResponseModel;
  final double totalAmount;

  const ProductState({
    this.status = ProductStatus.initial,
    this.scannedItem,
    this.estimationResponseModel,
    this.productList = const[],
    this.selectedProductList = const[],
    this.totalAmount = 0.0,
  });

  ProductState copyWith({
    ProductStatus? status,
    ProductPayload? scannedItem,
    List<ProductPayload>? productList,
    EstimationResponseModel? estimationResponseModel,
    List<ProductPayload>? selectedProductList,
    double? totalAmount,
  }) {
    return ProductState(
      status: status ?? this.status,
      scannedItem: scannedItem ?? this.scannedItem,
      productList: productList ?? this.productList,
      estimationResponseModel: estimationResponseModel ?? this.estimationResponseModel,
      selectedProductList: selectedProductList ?? this.selectedProductList,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    scannedItem,
    estimationResponseModel,
    productList,
    totalAmount,
  ];
}