import 'package:bbus_mobile/common/entities/request.dart';
import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/parent/data/datasources/request_remote_datasource.dart';
import 'package:bbus_mobile/features/parent/domain/repository/request_repository.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_absent_request.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_change_checkpoint_req.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_new_checkpoint_req.dart';
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

  @override
  Future<Either<Failure, dynamic>> createAbsentRequest(
      SendAbsentRequestParams params) async {
    try {
      final res = await _requestRemoteDatasource.createAbsentRequest(params);
      if (res['status'] == 409) {
        return Left(Failure(res['message']));
      }
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<RequestEntity>>> getRequestList() async {
    try {
      final data = await _requestRemoteDatasource.getRequestList();
      return Right(data);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> createChangeCheckpointReq(
      SendChangeCheckpointReqParams params) async {
    try {
      final res =
          await _requestRemoteDatasource.createChangeCheckpointReq(params);
      if (res['status'] == 409) {
        return Left(Failure(res['message']));
      }
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> createNewCheckpointReq(
      SendNewCheckpointReqParams params) async {
    try {
      final res = await _requestRemoteDatasource.createNewCheckpointReq(params);
      if (res['status'] == 409) {
        return Left(Failure(res['message']));
      }
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
