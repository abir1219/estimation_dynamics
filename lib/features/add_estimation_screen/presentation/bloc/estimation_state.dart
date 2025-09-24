
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
  final SalesmanModel? salesmanModel;
  final List<SalesmanPayload> fullSalesmanList;       // keep original full list
  final List<SalesmanPayload> filteredSalesmanList;   // filtered based on search
  final bool isLoading;
  final String? error;

  const EstimationDataState({
    this.customer,
    this.salesman,
    this.refNumber,
    this.salesmanModel,
    this.fullSalesmanList = const [],
    this.filteredSalesmanList = const [],
    this.isLoading = false,
    this.error,
  });

  EstimationDataState copyWith({
    Customer? customer,
    SalesmanPayload? salesman,
    String? refNumber,
    SalesmanModel? salesmanModel,
    List<SalesmanPayload>? fullSalesmanList,
    List<SalesmanPayload>? filteredSalesmanList,
    bool? isLoading,
    String? error,
  }) {
    return EstimationDataState(
      customer: customer ?? this.customer,
      salesman: salesman ?? this.salesman,
      refNumber: refNumber ?? this.refNumber,
      salesmanModel: salesmanModel ?? this.salesmanModel,
      fullSalesmanList: fullSalesmanList ?? this.fullSalesmanList,
      filteredSalesmanList: filteredSalesmanList ?? this.filteredSalesmanList,
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
    fullSalesmanList,
    filteredSalesmanList,
    isLoading,
    error
  ];
}
