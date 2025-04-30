import 'dart:async';
import 'dart:math';

import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/common/websocket/websocket_service.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

abstract class LocationSocketDatasource {
  Future<void> startListening(Function(LocationEntity location), String busId);
  Future<void> stopListening();
}

class LocationSocketDatasourceImpl implements LocationSocketDatasource {
  final WebSocketService _webSocketService;
  LocationSocketDatasourceImpl(this._webSocketService);
  @override
  Future<void> startListening(
      Function(LocationEntity location) onLocationReceived,
      String busId) async {
    print('start');
    _webSocketService.connect('${ApiConstants.socketAddress}/$busId');

    _webSocketService.messageStream.listen((message) {
      logger.i(message);
      if (message.isEmpty) {
        logger.w('Received empty message from WebSocket');
        return;
      }
      final latLngRegex = RegExp(r'lat=([0-9\.\-]+), lng=([0-9\.\-]+)');
      final match = latLngRegex.firstMatch(message);
      var loc = LocationEntity(21.0047205, 105.8014499);
      if (match != null) {
        double? lat = double.tryParse(match.group(1)!);
        double? lng = double.tryParse(match.group(2)!);

        if (lat != null && lng != null) {
          loc = LocationEntity(lat, lng);
          onLocationReceived(loc);
        } else {
          logger.w('Invalid lat/lng parsed.');
        }
      } else {
        logger.w('Message does not match expected format.');
      }
      onLocationReceived(loc);
    });
  }

  @override
  Future<void> stopListening() async {
    await _webSocketService.close();
  }
}
