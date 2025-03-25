import 'dart:async';

import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/features/map/domain/repository/map_repository.dart';

class GetLiveLocation {
  final MapRepository _mapRepository;
  GetLiveLocation(this._mapRepository);
  final StreamController<LocationEntity> _locationController =
      StreamController<LocationEntity>();
  Stream<LocationEntity> get locationStream => _locationController.stream;
  Future<void> openLiveTracking(
      Function(LocationEntity location) onLocationReceived) async {
    await _mapRepository.startListening(onLocationReceived);
  }

  void stop() {
    _mapRepository.stopListening();
  }

  void dispose() {
    _locationController.close();
  }
}
