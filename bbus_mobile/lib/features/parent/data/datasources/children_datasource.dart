import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';

abstract class ChildrenDatasource {
  Future<List<ChildEntity>> getChildrenList();
}

class ChildrenDatasourceImpl implements ChildrenDatasource {
  final DioClient _dioClient;
  final SecureLocalStorage _secureLocalStorage;
  ChildrenDatasourceImpl(this._dioClient, this._secureLocalStorage);
  @override
  Future<List<ChildEntity>> getChildrenList() async {
    try {
      final parentId = await _secureLocalStorage.load(key: 'entityId');
      final result =
          await _dioClient.get('${ApiConstants.childrenList}/$parentId');
      return result.map((child) => ChildEntity.fromJson(child)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
