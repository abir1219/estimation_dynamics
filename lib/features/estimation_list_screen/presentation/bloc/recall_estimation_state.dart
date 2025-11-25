part of 'recall_estimation_bloc.dart';

sealed class RecallEstimationState extends Equatable {
  const RecallEstimationState();
}

final class RecallEstimationInitial extends RecallEstimationState {
  @override
  List<Object> get props => [];
}
