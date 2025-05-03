import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:intl/intl.dart';

abstract class ChildrenDatasource {
  Future<List<ChildEntity>> getChildrenList();
  Future<dynamic> updateChild(ChildEntity child);
  Future<List<StudentEntity>> getChildAttendance(String childId);
  Future<dynamic> getRegistrationTime();
}

class ChildrenDatasourceImpl implements ChildrenDatasource {
  final DioClient _dioClient;
  final SecureLocalStorage _secureLocalStorage;
  ChildrenDatasourceImpl(this._dioClient, this._secureLocalStorage);
  @override
  Future<List<ChildEntity>> getChildrenList() async {
    try {
      // final parentId = await _secureLocalStorage.load(key: 'entityId');
      final result = await _dioClient.get(ApiConstants.childrenListUrl);
      final List<dynamic> data = result['data'];
      return data.map((child) => ChildEntity.fromJson(child)).toList();
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<dynamic> updateChild(ChildEntity child) async {
    try {
      final result = await _dioClient
          .put(ApiConstants.updateChild, data: <String, dynamic>{
        'id': child.id,
        'name': child.name,
        'dob': child.dob,
        'address': child.address,
        'gender': child.gender
      });
      return result;
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StudentEntity>> getChildAttendance(String childId) async {
    try {
      final date = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final res = await _dioClient
          // .get('${ApiConstants.getChildAttandance}?date=$formattedDate');
          .get(
              '${ApiConstants.getChildAttandance}/$childId?date=$formattedDate');
      if (res['status'] == 404) {
        return throw EmptyException();
      }
      logger.d(res['data']);
      final List<dynamic> data = res['data'];
      if (data.isEmpty) {
        return throw EmptyException();
      }
      return data.map((bs) => StudentEntity.fromJson(bs)).toList();
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future getRegistrationTime() async {
    try {
      final res = await _dioClient.get(
          '${ApiConstants.getEventOpenTime}/${ApiConstants.eventName['register']}');
      return res;
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(e.toString());
    }
  }
}
