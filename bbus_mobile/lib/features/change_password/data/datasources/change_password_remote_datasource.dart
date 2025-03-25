import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/change_password/data/models/change_password_model.dart';

abstract class ChangePasswordRemoteDatasource {
  Future<dynamic> changePassword(ChangePasswordModel params);
}

class ChangePasswordRemoteDatasourceImpl
    implements ChangePasswordRemoteDatasource {
  final DioClient _dioClient;
  ChangePasswordRemoteDatasourceImpl(this._dioClient);
  @override
  Future<dynamic> changePassword(ChangePasswordModel params) async {
    try {
      final response = await _dioClient.patch(ApiConstants.changePasswordApiUrl,
          data: params.toJson());
      return response;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
