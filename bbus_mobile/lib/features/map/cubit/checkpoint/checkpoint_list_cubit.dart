import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/map/domain/usecases/get_checkpoint_list.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'checkpoint_list_state.dart';

class CheckpointListCubit extends Cubit<CheckpointListState> {
  final GetCheckpointList _checkpointList;
  CheckpointListCubit(this._checkpointList) : super(CheckpointListInitial());
  Future<void> getAll() async {
    emit(CheckpointListLoading());
    final res = await _checkpointList.call(NoParams());
    res.fold((l) => emit(CheckpointListFailure(l.message)),
        (r) => emit(CheckpointListSuccess(r)));
  }
}
