import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/map/domain/repository/checkpoint_repository.dart';
import 'package:dartz/dartz.dart';

class GetCheckpointList implements UseCase<List<CheckpointEntity>, NoParams> {
  final CheckpointRepository _checkpointRepository;
  GetCheckpointList(this._checkpointRepository);
  @override
  Future<Either<Failure, List<CheckpointEntity>>> call(NoParams params) async {
    return await _checkpointRepository.getCheckpointList();
  }
}
