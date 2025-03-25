import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<RequestTypeEntity>>> getListRequestType();
}
