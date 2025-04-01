import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/getChildrenList.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'children_list_state.dart';

class ChildrenListCubit extends Cubit<ChildrenListState> {
  final Getchildrenlist _getchildrenlist;
  ChildrenListCubit(this._getchildrenlist) : super(ChildrenListInitial());
  void getAll() async {
    final res = await _getchildrenlist(NoParams());
    res.fold((l) => emit(ChildrenListFailure(l.message)),
        (r) => emit(ChildrenListSuccess(r)));
  }
}
