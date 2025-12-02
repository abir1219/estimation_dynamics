part of 'recall_estimation_bloc.dart';

sealed class RecallEstimationEvent extends Equatable {
  const RecallEstimationEvent();
}

final class RecallEstimationDataEvent extends RecallEstimationEvent {
  final String refNo;
  const RecallEstimationDataEvent({required this.refNo});

  @override
  List<Object> get props => [refNo];
}

final class ChangeStatusEvent extends RecallEstimationEvent{
  @override
  List<Object?> get props => [];

}

