part of 'estimation_bloc.dart';

sealed class EstimationEvent extends Equatable {
  const EstimationEvent();
}

final class GenerateEstimationNoEvent extends EstimationEvent{
  @override
  List<Object?> get props => [];
}

final class SelectSalesmanEvent extends EstimationEvent {
  final SalesmanPayload salesman;

  const SelectSalesmanEvent(this.salesman);

  @override
  List<Object?> get props => [salesman];
}

final class ResetSalesmanStateEvent extends EstimationEvent {
  @override
  List<Object?> get props => [];
}

class SearchEmployeeEvent extends EstimationEvent {
  final String search;

  const SearchEmployeeEvent({required this.search});

  @override
  List<Object?> get props => [search];
}

final class SetSelectedCustomerEvent extends EstimationEvent {
  final Customer? customer;
  final CustomerData? customerData;
  const SetSelectedCustomerEvent({required this.customer,this.customerData});

  @override
  List<Object?> get props => [customer,customerData];
}

final class ResetEstimationEvent extends EstimationEvent {
  const ResetEstimationEvent();

  @override
  List<Object?> get props => [];
}

final class FetchSalesmanEvent extends EstimationEvent {
  const FetchSalesmanEvent();

  @override
  List<Object?> get props => [];
}

