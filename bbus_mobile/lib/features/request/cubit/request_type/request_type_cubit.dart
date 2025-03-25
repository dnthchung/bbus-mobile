import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/features/request/domain/usecases/get_all_request_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'request_type_state.dart';

class RequestTypeCubit extends Cubit<RequestTypeState> {
  final GetAllRequestType _getAllRequestType;
  RequestTypeCubit(this._getAllRequestType) : super(RequestTypeInitial([]));
}
