import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/request/data/datasources/request_remote_datasource.dart';
import 'package:bbus_mobile/features/request/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDatasource _requestRemoteDatasource;
  RequestRepositoryImpl(this._requestRemoteDatasource);
  @override
  Future<Either<Failure, List<RequestTypeEntity>>> getListRequestType() async {
    try {
      final requestTypeList =
          await _requestRemoteDatasource.getListRequestType();
      return Right(requestTypeList);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
