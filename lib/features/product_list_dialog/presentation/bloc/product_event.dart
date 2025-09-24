part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

final class ScanItemEvent extends ProductEvent {
  final String? itemNo;
  final String? refNo;
  final Customer? customer;
  final SalesmanPayload? salesman;

  const ScanItemEvent(
      {required this.itemNo,
      required this.refNo,
      required this.customer,
      required this.salesman});

  @override
  List<Object?> get props => [itemNo, refNo, customer, salesman];
}

final class SelectProductEvent extends ProductEvent {
  final ProductPayload? product;

  const SelectProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

final class ResetProductStateEvent extends ProductEvent {
  @override
  List<Object?> get props => [];
}

final class DeleteProductStateEvent extends ProductEvent {
  final int? index;

  const DeleteProductStateEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

final class SubmitProductEvent extends ProductEvent {
  final List<ProductPayload>? selectedProductList;
  final String? refNo;
  final Customer? customer;
  final SalesmanPayload? salesman;

  const SubmitProductEvent(
      {required this.selectedProductList,
      required this.refNo,
      required this.customer,
      required this.salesman});

  @override
  List<Object?> get props => [selectedProductList, refNo, customer, salesman];
}
