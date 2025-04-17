import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/parent/domain/repository/bus_repository.dart';
import 'package:dartz/dartz.dart';

class GetBusDetail implements UseCase<BusEntity, String> {
  final BusRepository _busRepository;
  GetBusDetail(this._busRepository);
  @override
  Future<Either<Failure, BusEntity>> call(String params) async {
    logger.i(params);
    return await _busRepository.getBusDetail(params);
  }
}
