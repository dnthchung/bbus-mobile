import 'package:bbus_mobile/common/entities/request.dart';
import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_absent_request.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_change_checkpoint_req.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_new_checkpoint_req.dart';
import 'package:dartz/dartz.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<RequestTypeEntity>>> getListRequestType();
  Future<Either<Failure, List<RequestEntity>>> getRequestList();
  Future<Either<Failure, dynamic>> createAbsentRequest(
      SendAbsentRequestParams params);
  Future<Either<Failure, dynamic>> createChangeCheckpointReq(
      SendChangeCheckpointReqParams params);
  Future<Either<Failure, dynamic>> createNewCheckpointReq(
      SendNewCheckpointReqParams params);
}
