import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

abstract class BusDatasource {
  Future<BusEntity> getBusDetail(String busId);
}

class BusDatasourceImpl implements BusDatasource {
  final DioClient _dioClient;
  BusDatasourceImpl(this._dioClient);
  @override
  Future<BusEntity> getBusDetail(String busId) async {
    try {
      final res = await _dioClient.get('${ApiConstants.busApiUrl}/$busId');
      return BusEntity.fromJson(res['data']);
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
