
part of 'estimation_bloc.dart';

sealed class EstimationState extends Equatable {
  const EstimationState();
}

final class EstimationInitial extends EstimationState {
  @override
  List<Object> get props => [];
}
final class EstimationDataState extends EstimationState {
  final Customer? customer;
  final SalesmanPayload? salesman;
  final String? refNumber;
  final SalesmanModel? salesmanModel; // add
  final List<SalesmanPayload> filteredSalesmanList; // add
  // final List<SalesmanPayload> fullSalesmanList; // add
  final bool isLoading;
  final String? error;

  const EstimationDataState({
    this.customer,
    this.salesman,
    this.refNumber,
    this.salesmanModel,
    this.filteredSalesmanList = const [],
    // this.fullSalesmanList = const [],
    this.isLoading = false,
    this.error,
  });

  EstimationDataState copyWith({
    Customer? customer,
    SalesmanPayload? salesman,
    String? refNumber,
    SalesmanModel? salesmanModel,
    List<SalesmanPayload>? filteredSalesmanList,
    // List<SalesmanPayload>? fullSalesmanList,
    bool? isLoading,
    String? error,
  }) {
    return EstimationDataState(
      customer: customer ?? this.customer,
      salesman: salesman ?? this.salesman,
      refNumber: refNumber ?? this.refNumber,
      salesmanModel: salesmanModel ?? this.salesmanModel,
      filteredSalesmanList: filteredSalesmanList ?? this.filteredSalesmanList,
      // fullSalesmanList: fullSalesmanList ?? this.fullSalesmanList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    customer,
    salesman,
    refNumber,
    salesmanModel,
    filteredSalesmanList,
    // fullSalesmanList,
    isLoading,
    error
  ];
}
