import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recall_estimation_event.dart';
part 'recall_estimation_state.dart';

class RecallEstimationBloc extends Bloc<RecallEstimationEvent, RecallEstimationState> {
  RecallEstimationBloc() : super(RecallEstimationInitial()) {
    on<RecallEstimationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
