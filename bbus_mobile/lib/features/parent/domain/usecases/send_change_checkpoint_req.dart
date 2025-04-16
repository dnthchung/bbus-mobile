import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';

class SendChangeCheckpointReq
    implements UseCase<void, SendChangeCheckpointReqParams> {
  final RequestRepository _requestRepository;
  SendChangeCheckpointReq(this._requestRepository);
  @override
  Future<Either<Failure, void>> call(
      SendChangeCheckpointReqParams params) async {
    return await _requestRepository.createChangeCheckpointReq(params);
  }
}

class SendChangeCheckpointReqParams {
  String? requestTypeId;
  String? checkpointId;
  String? reason;
  SendChangeCheckpointReqParams(
      this.checkpointId, this.requestTypeId, this.reason);
  SendChangeCheckpointReqParams.fromJson(Map<String, dynamic> json) {
    requestTypeId = json['requestTypeId'];
    checkpointId = json['checkpointId'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestTypeId'] = this.requestTypeId;
    data['checkpointId'] = this.checkpointId;
    data['reason'] = this.reason;
    return data;
  }
}
