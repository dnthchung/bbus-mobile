import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/get_all_request_type.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_type_state.dart';

class RequestTypeCubit extends Cubit<RequestTypeState> {
  final GetAllRequestType _getAllRequestType;
  RequestTypeCubit(this._getAllRequestType) : super(RequestTypeInitial());
  Future<void> getRequestTypeList() async {
    final res = await _getAllRequestType.call(NoParams());
    res.fold((l) => emit(RequestTypeFailure(l.message)),
        (r) => emit(RequestTypeLoaded(r)));
  }
}
