import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

abstract class CheckpointDatasource {
  Future<List<CheckpointEntity>> getCheckpointList();
  Future<BusEntity> registerCheckpoint(String studentId, String checkpointId);
}

class CheckpointDatasourceImpl implements CheckpointDatasource {
  final DioClient _dioClient;
  CheckpointDatasourceImpl(this._dioClient);
  @override
  Future<List<CheckpointEntity>> getCheckpointList() async {
    try {
      final result = await _dioClient.get(ApiConstants.checkpointUrl);
      final List<dynamic> data = result['data']['checkpoints'];
      return data.map((c) => CheckpointEntity.fromJson(c)).toList();
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BusEntity> registerCheckpoint(
      String studentId, String checkpointId) async {
    try {
      final result = await _dioClient.post(
          '${ApiConstants.registerCheckpointUrl}?studentId=$studentId&checkpointId=$checkpointId');
      return BusEntity.fromJson(result['data']);
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(e.toString());
    }
  }
}
