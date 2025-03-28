import 'dart:async';
import 'dart:math';

import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/common/websocket/websocket_service.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

abstract class LocationSocketDatasource {
  Future<void> startListening(Function(LocationEntity location));
  Future<void> stopListening();
}

class LocationSocketDatasourceImpl implements LocationSocketDatasource {
  final WebSocketService _webSocketService;
  LocationSocketDatasourceImpl(this._webSocketService);
  @override
  Future<void> startListening(
      Function(LocationEntity location) onLocationReceived) async {
    print('start');
    _webSocketService.connect(ApiConstants.socketAddress);

    _webSocketService.messageStream.listen((message) {
      logger.i(message);
      // final List<String> splited = message.split(',');
      // var loc = LocationEntity(
      //     double.tryParse(splited[0]) ?? 0, double.tryParse(splited[1]) ?? 0);
      var loc = LocationEntity(35.761648, 51.399856);
      onLocationReceived(loc);
    });
  }

  @override
  Future<void> stopListening() async {
    await _webSocketService.close();
  }
}
