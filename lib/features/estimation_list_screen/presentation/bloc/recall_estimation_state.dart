part of 'recall_estimation_bloc.dart';

sealed class RecallEstimationState extends Equatable {
  const RecallEstimationState();
}

final class RecallEstimationInitial extends RecallEstimationState {
  @override
  List<Object> get props => [];
}

final class RecallEstimationLoading extends RecallEstimationState {
  @override
  List<Object?> get props => [];
}

final class RecallEstimationLoaded extends RecallEstimationState {
  final EstimationResponseModel_01 estimationResponseModel;
  final String? refNo;

  const RecallEstimationLoaded({required this.estimationResponseModel,required this.refNo});

  @override
  List<Object?> get props => [estimationResponseModel,refNo];
}

final class RecallEstimationError extends RecallEstimationState {
  final String errMsg;

  const RecallEstimationError({required this.errMsg});

  @override
  List<Object?> get props => [errMsg];
}
