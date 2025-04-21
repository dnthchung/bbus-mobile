import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class CheckpointRepository {
  Future<Either<Failure, List<CheckpointEntity>>> getCheckpointList();
  Future<Either<Failure, List<CheckpointEntity>>> getCheckpointByRoute(
      String routeId);
  Future<Either<Failure, dynamic>> registerCheckpoint(
      String studentId, String checkpointId);
}
