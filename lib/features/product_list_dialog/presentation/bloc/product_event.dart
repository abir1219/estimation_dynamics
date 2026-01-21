part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

final class ScanItemEvent extends ProductEvent {
  final String? itemNo;
  final String? refNo;
  final dynamic customer;
  final SalesmanPayload? salesman;
  final bool fromPdf;

  const ScanItemEvent(
      {this.fromPdf = false,
      required this.itemNo,
      required this.refNo,
      required this.customer,
      required this.salesman});

  @override
  List<Object?> get props => [itemNo, refNo, customer, salesman, fromPdf];
}

final class EditEstimateProductEvent extends ProductEvent {
  final String customerId;
  final String customerName;
  final String salesman;
  final List<ListItem> listItem;

  const EditEstimateProductEvent(
      {required this.customerId,
      required this.customerName,
      required this.listItem,
      required this.salesman});

  @override
  List<Object?> get props => [customerId, customerName, salesman, listItem];
}

final class DeleteEstimationEvent extends ProductEvent {
  final String referenceNo;

  const DeleteEstimationEvent({required this.referenceNo});

  @override
  List<Object?> get props => [referenceNo];
}

final class UnlockItemEvent extends ProductEvent {
  final bool? isScanned;
  final String? itemNo;
  final String? refNo;
  final double? lineNo;
  final dynamic customer;
  final SalesmanPayload? salesman;

  const UnlockItemEvent(
      {required this.itemNo,
      required this.refNo,
      required this.isScanned,
      required this.lineNo,
      required this.customer,
      required this.salesman});

  @override
  List<Object?> get props =>
      [itemNo, refNo, isScanned, lineNo, customer, salesman];
}

final class ApiStatusChangeEvent extends ProductEvent {
  @override
  List<Object?> get props => [];
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
