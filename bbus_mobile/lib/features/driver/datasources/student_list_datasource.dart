import 'dart:io';

import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:dio/dio.dart';

abstract class StudentListDatasource {
  Future<List<StudentEntity>> getStudentList(String busId, String direction);
  Future<dynamic> markAttendance(String busId, String studentId, File image);
}

class StudentListDatasourceImpl implements StudentListDatasource {
  final DioClient _dioClient;
  StudentListDatasourceImpl(this._dioClient);
  @override
  Future<List<StudentEntity>> getStudentList(
      String busId, String direction) async {
    try {
      final res = await _dioClient.get(
          '${ApiConstants.getAttandance}?busId=$busId&busDirection=$direction&date=2025-04-11');
      final List<dynamic> data = res['data'];
      return data.map((student) => StudentEntity.fromJson(student)).toList();
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<dynamic> markAttendance(
      String busId, String studentId, File image) async {
    try {
      final formData = FormData.fromMap({
        'studentId': studentId,
        'busId': busId,
        'image': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      });
      final res = await _dioClient.post('url', data: formData);
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
