part of 'search_customer_bloc.dart';

@immutable
sealed class SearchCustomerState extends Equatable {}

final class SearchCustomerInitial extends SearchCustomerState {
  @override
  List<Object?> get props => [];
}

final class SearchCustomerLoading extends SearchCustomerState {
  @override
  List<Object?> get props => [];
}

final class SearchCustomerLoaded extends SearchCustomerState {
  final CustomerModel customerModel;

  SearchCustomerLoaded({required this.customerModel});

  @override
  List<Object?> get props => [customerModel];
}

final class SearchCustomerError extends SearchCustomerState {
  final String errMsg;

  SearchCustomerError(this.errMsg);

  @override
  List<Object?> get props => [errMsg];
}

final class SelectCustomerDataState extends SearchCustomerState {
  final Customer? customer;
  final CustomerData? customerData;

  SelectCustomerDataState({required this.customer,this.customerData});

  @override
  List<Object?> get props => [customer,customerData];
}
