part of 'search_customer_bloc.dart';

@immutable
sealed class SearchCustomerEvent extends Equatable {}

final class FetchCustomerEvent extends SearchCustomerEvent {
  final String? customerName;
  final String? refNumber;

  FetchCustomerEvent({this.customerName, this.refNumber});

  @override
  List<Object?> get props => [customerName, refNumber];
}

final class ResetSearchCustomerStateEvent extends SearchCustomerEvent {
  @override
  List<Object?> get props => [];
}

final class SelectCustomerDataEvent extends SearchCustomerEvent {
  final Customer customer;

  SelectCustomerDataEvent({required this.customer});

  @override
  List<Object?> get props => [customer];
}
