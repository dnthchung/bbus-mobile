import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/map/data/datasources/checkpoint_datasource.dart';
import 'package:bbus_mobile/features/map/domain/repository/checkpoint_repository.dart';
import 'package:dartz/dartz.dart';

class CheckpointRespositoryImpl implements CheckpointRepository {
  final CheckpointDatasource _checkpointDatasource;
  CheckpointRespositoryImpl(this._checkpointDatasource);
  @override
  Future<Either<Failure, List<CheckpointEntity>>> getCheckpointList() async {
    try {
      final res = await _checkpointDatasource.getCheckpointList();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> registerCheckpoint(
      String studentId, String checkpointId) async {
    try {
      final res = await _checkpointDatasource.registerCheckpoint(
          studentId, checkpointId);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CheckpointEntity>>> getCheckpointByRoute(
      String routeId) async {
    try {
      final res = await _checkpointDatasource.getCheckpointByRoute(routeId);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
