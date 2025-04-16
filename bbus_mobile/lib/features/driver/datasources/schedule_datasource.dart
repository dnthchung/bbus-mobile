import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/constants/error_message.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:intl/intl.dart';

abstract class ScheduleDatasource {
  Future<BusScheduleEntity> getBusSchedule();
}

class ScheduleDatasourceImpl implements ScheduleDatasource {
  final DioClient _dioClient;
  ScheduleDatasourceImpl(this._dioClient);
  @override
  Future<BusScheduleEntity> getBusSchedule() async {
    try {
      final date = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final res = await _dioClient
          // .get('${ApiConstants.getBusSchedule}?date=$formattedDate');
          .get('${ApiConstants.getBusSchedule}?date=2025-04-11');
      final List<dynamic> data = res['data'];
      return BusScheduleEntity.fromJson(data.first);
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw EmptyException();
      }
      throw ServerException(e.toString());
    }
  }
}
