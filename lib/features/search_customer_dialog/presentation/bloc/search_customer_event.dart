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

final class AddCustomerEvent extends SearchCustomerEvent {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNo;
  final String? panCard;

  AddCustomerEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.panCard,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phoneNo, panCard];
}
