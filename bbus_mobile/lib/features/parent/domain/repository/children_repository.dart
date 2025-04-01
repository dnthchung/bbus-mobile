import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ChildrenRepository {
  Future<Either<Failure, List<ChildEntity>>> getChildrenList();
}
