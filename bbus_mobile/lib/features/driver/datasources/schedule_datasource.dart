import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/constants/error_message.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:intl/intl.dart';

abstract class ScheduleDatasource {
  Future<List<BusScheduleEntity>> getBusSchedule();
  Future<dynamic> completeSchedule(String busScheduleId, String note);
}

class ScheduleDatasourceImpl implements ScheduleDatasource {
  final DioClient _dioClient;
  ScheduleDatasourceImpl(this._dioClient);
  @override
  Future<List<BusScheduleEntity>> getBusSchedule() async {
    try {
      final date = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final res = await _dioClient
          // .get('${ApiConstants.getBusSchedule}?date=$formattedDate');
          .get('${ApiConstants.getBusSchedule}?date=2025-04-18');
      logger.d(res['data']);
      final List<dynamic> data = res['data'];
      if (data.isEmpty) {
        return throw EmptyException();
      }
      return data.map((bs) => BusScheduleEntity.fromJson(bs)).toList();
    } catch (e) {
      logger.e(e.toString());
      if (e.toString() == noElement) {
        throw EmptyException();
      }
      if (e is EmptyException) {
        throw EmptyException();
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<dynamic> completeSchedule(String busScheduleId, String note) async {
    try {
      final res = await _dioClient.post(ApiConstants.completeSchedule,
          data: {'busScheduleId': busScheduleId, 'note': note});
      return res;
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw EmptyException();
      }
      throw ServerException(e.toString());
    }
  }
}
