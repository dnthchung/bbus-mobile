import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/driver/domain/repository/schedule_repository.dart';
import 'package:dartz/dartz.dart';

class GetBusSchedule implements UseCase<List<BusScheduleEntity>, NoParams> {
  final ScheduleRepository _scheduleRepository;
  GetBusSchedule(this._scheduleRepository);
  @override
  Future<Either<Failure, List<BusScheduleEntity>>> call(NoParams params) async {
    return await _scheduleRepository.getBusSchedule();
  }
}
