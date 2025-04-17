part of 'checkpoint_list_cubit.dart';

@immutable
sealed class CheckpointListState {}

final class CheckpointListInitial extends CheckpointListState {}

final class CheckpointListLoading extends CheckpointListState {}

final class CheckpointListSuccess extends CheckpointListState {
  final List<CheckpointEntity> data;
  CheckpointListSuccess(this.data);
}

final class CheckpointListFailure extends CheckpointListState {
  final String message;
  CheckpointListFailure(this.message);
}
