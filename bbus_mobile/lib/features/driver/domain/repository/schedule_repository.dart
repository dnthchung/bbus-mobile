import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/driver/datasources/schedule_datasource.dart';
import 'package:dartz/dartz.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<BusScheduleEntity>>> getBusSchedule();
  Future<Either<Failure, void>> completeBusSchedule(
      String busScheduleId, String note);
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDatasource _scheduleDatasource;
  ScheduleRepositoryImpl(this._scheduleDatasource);

  @override
  Future<Either<Failure, List<BusScheduleEntity>>> getBusSchedule() async {
    try {
      final res = await _scheduleDatasource.getBusSchedule();
      return right(res);
    } on EmptyException {
      return left(EmptyFailure());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeBusSchedule(
      String busScheduleId, String note) async {
    try {
      final res =
          await _scheduleDatasource.completeSchedule(busScheduleId, note);
      return Right(res);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    } catch (e) {
      throw Left(Failure(e.toString()));
    }
  }
}
