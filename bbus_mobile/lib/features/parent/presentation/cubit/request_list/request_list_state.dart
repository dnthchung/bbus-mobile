part of 'request_list_cubit.dart';

@immutable
sealed class RequestListState {}

final class RequestListInitial extends RequestListState {}

final class RequestListLoading extends RequestListState {}

final class RequestListLoaded extends RequestListState {
  final List<RequestEntity> allRequests;
  final List<RequestEntity> filteredRequests;
  final String? selectedStatus;
  RequestListLoaded(
      this.allRequests, this.filteredRequests, this.selectedStatus);
}

final class RequestListFailure extends RequestListState {
  final String message;
  RequestListFailure(this.message);
}
