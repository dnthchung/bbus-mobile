import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/map/domain/repository/checkpoint_repository.dart';
import 'package:dartz/dartz.dart';

class GetMapRoute implements UseCase<List<CheckpointEntity>, String> {
  final CheckpointRepository _checkpointRepository;
  GetMapRoute(this._checkpointRepository);
  @override
  Future<Either<Failure, List<CheckpointEntity>>> call(String params) async {
    return await _checkpointRepository.getCheckpointByRoute(params);
  }
}
