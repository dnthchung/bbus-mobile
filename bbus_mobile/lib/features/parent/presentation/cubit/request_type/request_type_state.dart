part of 'request_type_cubit.dart';

@immutable
sealed class RequestTypeState {}

final class RequestTypeInitial extends RequestTypeState {}

final class RequestTypeLoading extends RequestTypeState {}

final class RequestTypeLoaded extends RequestTypeState {
  final List<RequestTypeEntity> data;
  RequestTypeLoaded(this.data);
}

final class RequestTypeFailure extends RequestTypeState {
  final String message;
  RequestTypeFailure(this.message);
}
