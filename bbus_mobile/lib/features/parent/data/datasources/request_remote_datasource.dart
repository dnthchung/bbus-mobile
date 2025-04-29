import 'package:bbus_mobile/common/entities/request.dart';
import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_absent_request.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_change_checkpoint_req.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_new_checkpoint_req.dart';

abstract class RequestRemoteDatasource {
  Future<List<RequestTypeEntity>> getListRequestType();
  Future<List<RequestEntity>> getRequestList();
  Future<dynamic> createAbsentRequest(SendAbsentRequestParams params);
  Future<dynamic> createChangeCheckpointReq(
      SendChangeCheckpointReqParams params);
  Future<dynamic> createNewCheckpointReq(SendNewCheckpointReqParams params);
}

class RequestRemoteDatasourceImpl implements RequestRemoteDatasource {
  final DioClient _dioClient;
  RequestRemoteDatasourceImpl(this._dioClient);
  @override
  Future<List<RequestTypeEntity>> getListRequestType() async {
    try {
      final response = await _dioClient.get(ApiConstants.reportTypeUrl);
      final List<dynamic> requestTypeList = response['data']['requestTypes'];
      return requestTypeList
          .map((requestType) => RequestTypeEntity.fromJson(requestType))
          .toList();
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future createAbsentRequest(SendAbsentRequestParams params) async {
    try {
      final response = await _dioClient.post(ApiConstants.addRequestUrl,
          data: params.toJson());
      return response;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RequestEntity>> getRequestList() async {
    try {
      final response = await _dioClient.get(ApiConstants.requestListUrl);
      final List<dynamic> data = response['data'];
      return data.map((request) => RequestEntity.fromJson(request)).toList();
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future createChangeCheckpointReq(SendChangeCheckpointReqParams params) async {
    try {
      final response = await _dioClient.post(ApiConstants.addRequestUrl,
          data: params.toJson());
      return response;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future createNewCheckpointReq(SendNewCheckpointReqParams params) async {
    try {
      final response = await _dioClient.post(ApiConstants.addRequestUrl,
          data: params.toJson());
      return response;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
