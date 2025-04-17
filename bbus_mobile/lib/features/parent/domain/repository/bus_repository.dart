import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class BusRepository {
  Future<Either<Failure, BusEntity>> getBusDetail(String busId);
}
