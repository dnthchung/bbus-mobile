import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class MapRepository {
  Future<void> startListening(
      Function(LocationEntity location) onLocationReceived, String busId);
  void stopListening();
}
