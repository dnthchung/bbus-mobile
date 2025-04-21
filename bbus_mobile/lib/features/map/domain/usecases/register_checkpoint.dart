import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/map/domain/repository/checkpoint_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterCheckpoint implements UseCase<dynamic, RegisterCheckpointParams> {
  final CheckpointRepository _checkpointRepository;
  RegisterCheckpoint(this._checkpointRepository);
  @override
  Future<Either<Failure, dynamic>> call(RegisterCheckpointParams params) async {
    return await _checkpointRepository.registerCheckpoint(
        params.studentId, params.checkpointId);
  }
}

class RegisterCheckpointParams {
  final String studentId;
  final String checkpointId;
  RegisterCheckpointParams(this.studentId, this.checkpointId);
}
