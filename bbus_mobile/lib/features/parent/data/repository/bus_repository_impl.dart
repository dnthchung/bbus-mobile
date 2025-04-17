import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/parent/data/datasources/bus_datasource.dart';
import 'package:bbus_mobile/features/parent/domain/repository/bus_repository.dart';
import 'package:dartz/dartz.dart';

class BusRepositoryImpl implements BusRepository {
  final BusDatasource _busDatasource;
  BusRepositoryImpl(this._busDatasource);
  @override
  Future<Either<Failure, BusEntity>> getBusDetail(String busId) async {
    try {
      final res = await _busDatasource.getBusDetail(busId);
      return Right(res);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    } catch (e) {
      throw Left(Failure(e.toString()));
    }
  }
}
