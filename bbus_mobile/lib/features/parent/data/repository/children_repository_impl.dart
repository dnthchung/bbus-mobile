import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/parent/data/datasources/children_datasource.dart';
import 'package:bbus_mobile/features/parent/domain/repository/children_repository.dart';
import 'package:dartz/dartz.dart';

class ChildrenRepositoryImpl implements ChildrenRepository {
  final ChildrenDatasource _childrenDatasource;
  ChildrenRepositoryImpl(this._childrenDatasource);
  @override
  Future<Either<Failure, List<ChildEntity>>> getChildrenList() async {
    try {
      final childrenList = await _childrenDatasource.getChildrenList();
      return Right(childrenList);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
