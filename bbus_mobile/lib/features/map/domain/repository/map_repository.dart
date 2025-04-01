import 'package:bbus_mobile/common/entities/location.dart';

abstract class MapRepository {
  Future<void> startListening(
      Function(LocationEntity location) onLocationReceived, String busId);
  void stopListening();
}
