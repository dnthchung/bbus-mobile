import 'package:bbus_mobile/common/entities/request.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/get_request_list.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_list_state.dart';

class RequestListCubit extends Cubit<RequestListState> {
  final GetRequestList _getRequestList;
  List<RequestEntity> _allRequests = [];
  RequestListCubit(this._getRequestList) : super(RequestListInitial());
  Future<void> getRequestList() async {
    emit(RequestListLoading());
    final result = await _getRequestList.call(NoParams());

    result.fold(
      (failure) => emit(RequestListFailure(failure.message)),
      (requests) {
        _allRequests = requests;
        emit(RequestListLoaded(
          _allRequests,
          _allRequests,
          null,
        ));
      },
    );
  }

  void filterByStatus(String? status) {
    final filtered = status == null
        ? _allRequests
        : _allRequests.where((r) => r.status == status).toList();

    emit(RequestListLoaded(
      _allRequests,
      filtered,
      status,
    ));
  }
}
