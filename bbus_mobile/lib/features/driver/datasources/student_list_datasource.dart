import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

abstract class StudentListDatasource {
  Future<List<StudentEntity>> getStudentList();
}

class StudentListDatasourceImpl implements StudentListDatasource {
  final DioClient _dioClient;
  StudentListDatasourceImpl(this._dioClient);
  @override
  Future<List<StudentEntity>> getStudentList() async {
    try {
      final res = await _dioClient.get('url');
      final List<dynamic> data = res['data'];
      return data.map((student) => StudentEntity.fromJson(student)).toList();
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
