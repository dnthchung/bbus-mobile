import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/features/map/data/datasources/location_socket_datasource.dart';
import 'package:bbus_mobile/features/map/domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final LocationSocketDatasource _locationSocketDatasource;
  MapRepositoryImpl(this._locationSocketDatasource);
  @override
  Future<void> startListening(
      Function(LocationEntity location) onLocationReceived) async {
    await _locationSocketDatasource.startListening(onLocationReceived);
  }

  @override
  void stopListening() {
    _locationSocketDatasource.stopListening();
  }
}
