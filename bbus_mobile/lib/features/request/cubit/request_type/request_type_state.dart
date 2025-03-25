part of 'request_type_cubit.dart';

@immutable
sealed class RequestTypeState extends Equatable {
  final List<RequestTypeEntity> types;
  const RequestTypeState(this.types);
}

final class RequestTypeInitial extends RequestTypeState {
  RequestTypeInitial(super.types);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class RequestTypeLoading extends RequestTypeState {
  RequestTypeLoading(super.types);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class RequestTypeLoaded extends RequestTypeState {
  RequestTypeLoaded(super.types);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class RequestTypeFailure extends RequestTypeState {
  RequestTypeFailure(super.types);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
