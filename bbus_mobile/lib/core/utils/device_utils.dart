import 'dart:io';

import 'package:app_set_id/app_set_id.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceDetails {
  final String deviceName;
  final String deviceVersion;
  final String deviceId; // Unique identifier

  DeviceDetails({
    required this.deviceName,
    required this.deviceVersion,
    required this.deviceId,
  });
}

Future<DeviceDetails> getDeviceDetails() async {
  String? deviceName;
  String? deviceVersion;
  String? identifier;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  final appSetId = await AppSetId().getIdentifier();
  logger.i(appSetId);
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      return DeviceDetails(
        deviceName: build.model,
        deviceVersion: build.version.release,
        deviceId: appSetId ?? build.id, // Use appSetId, fallback to build ID
      );
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      return DeviceDetails(
        deviceName: data.name,
        deviceVersion: data.systemVersion,
        deviceId: data.identifierForVendor ?? "unknown",
      );
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
  return DeviceDetails(
      deviceName: "unknown", deviceVersion: "unknown", deviceId: "unknown");
}
