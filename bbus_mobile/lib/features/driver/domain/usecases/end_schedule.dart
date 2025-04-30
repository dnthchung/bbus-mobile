import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/driver/domain/repository/schedule_repository.dart';
import 'package:dartz/dartz.dart';

class EndSchedule implements UseCase<void, EndScheduleParams> {
  final ScheduleRepository _scheduleRepository;
  EndSchedule(this._scheduleRepository);
  @override
  Future<Either<Failure, void>> call(EndScheduleParams params) async {
    return await _scheduleRepository.completeBusSchedule(
        params.busScheduleId, params.note);
  }
}

class EndScheduleParams {
  final String busScheduleId;
  final String note;
  EndScheduleParams(this.busScheduleId, this.note);
  Map<String, dynamic> toJson() => {
        "busScheduleId": busScheduleId,
        "note": note,
      };
}
