part of 'children_list_cubit.dart';

@immutable
sealed class ChildrenListState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ChildrenListInitial extends ChildrenListState {}

final class ChildrenListLoading extends ChildrenListState {}

final class ChildrenListSuccess extends ChildrenListState {
  final List<ChildEntity> data;
  ChildrenListSuccess(this.data);
  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

final class ChildrenListFailure extends ChildrenListState {
  final String message;
  ChildrenListFailure(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
