import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';

class SendNewCheckpointReq
    implements UseCase<void, SendNewCheckpointReqParams> {
  final RequestRepository _requestRepository;
  SendNewCheckpointReq(this._requestRepository);
  @override
  Future<Either<Failure, void>> call(SendNewCheckpointReqParams params) async {
    return await _requestRepository.createNewCheckpointReq(params);
  }
}

class SendNewCheckpointReqParams {
  String? requestTypeId;
  String? reason;
  SendNewCheckpointReqParams(this.requestTypeId, this.reason);
  SendNewCheckpointReqParams.fromJson(Map<String, dynamic> json) {
    requestTypeId = json['requestTypeId'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestTypeId'] = this.requestTypeId;
    data['reason'] = this.reason;
    return data;
  }
}
