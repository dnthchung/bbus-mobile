import 'dart:io';

import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/mark_attendance.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

abstract class StudentListDatasource {
  Future<List<StudentEntity>> getStudentList(String busId, String direction);
  Future<dynamic> markAttendance(
      String attendanceId, DateTime? checkin, DateTime? checkout);
}

class StudentListDatasourceImpl implements StudentListDatasource {
  final DioClient _dioClient;
  StudentListDatasourceImpl(this._dioClient);
  @override
  Future<List<StudentEntity>> getStudentList(
      String busId, String direction) async {
    try {
      final date = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final res = await _dioClient.get(
          // '${ApiConstants.getAttandance}?busId=$busId&busDirection=$direction&date=$formattedDate');
          '${ApiConstants.getAttandance}?busId=$busId&busDirection=$direction&date=2025-04-18');
      final List<dynamic> data = res['data'];
      return data.map((student) => StudentEntity.fromJson(student)).toList();
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<dynamic> markAttendance(
      String attendanceId, DateTime? checkin, DateTime? checkout) async {
    try {
      final res = await _dioClient.patch(ApiConstants.markAttendance,
          data: MarkAttendanceParams(attendanceId, checkin, checkout).toJson());
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
