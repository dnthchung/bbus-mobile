import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

abstract class RequestRemoteDatasource {
  Future<List<RequestTypeEntity>> getListRequestType();
}

class RequestRemoteDatasourceImpl implements RequestRemoteDatasource {
  final DioClient _dioClient;
  RequestRemoteDatasourceImpl(this._dioClient);
  @override
  Future<List<RequestTypeEntity>> getListRequestType() async {
    try {
      final response = await _dioClient.get(ApiConstants.reportTypeUrl);
      final requestTypeList = response['data']['requestTypes'];
      return requestTypeList
          .map((requestType) => RequestTypeEntity.fromJson(requestType))
          .toList();
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
