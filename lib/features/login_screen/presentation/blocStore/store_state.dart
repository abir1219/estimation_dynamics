part of 'store_bloc.dart';

sealed class StoreState extends Equatable {
  bool? isVisible;
  StoreState(this.isVisible);
}

final class StoreInitial extends StoreState {
  StoreInitial(super.isVisible);

  @override
  List<Object> get props => [];
}

final class StoreLoading extends StoreState{
  StoreLoading(super.isVisible);

  @override
  List<Object?> get props => [];
}

final class StoreLoaded extends StoreState {
  final List<StoreListPayload>? storeList;

  StoreLoaded(List<StoreListPayload>? storeList, {bool? isVisible})
      : storeList = storeList,
        super(isVisible);

  @override
  List<Object?> get props => [storeList, isVisible];
}

final class StoreError extends StoreState{
  final String? message;

  StoreError(this.message) : super(false);
  @override
  List<Object?> get props => [message];
}
