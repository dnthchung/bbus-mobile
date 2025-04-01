import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/repository/children_repository.dart';
import 'package:dartz/dartz.dart';

class Getchildrenlist implements UseCase<List<ChildEntity>, NoParams> {
  final ChildrenRepository _childrenRepository;
  Getchildrenlist(this._childrenRepository);
  @override
  Future<Either<Failure, List<ChildEntity>>> call(NoParams params) async {
    return await _childrenRepository.getChildrenList();
  }
}
