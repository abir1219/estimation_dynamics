part of 'recall_estimation_bloc.dart';

sealed class RecallEstimationEvent extends Equatable {
  const RecallEstimationEvent();
}

final class RecallEstimation extends RecallEstimationEvent {
  final String refId;
  const RecallEstimation({required this.refId});

  @override
  List<Object> get props => [refId];
}

