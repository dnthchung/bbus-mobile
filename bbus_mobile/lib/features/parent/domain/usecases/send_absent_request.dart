import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';

class SendAbsentRequest implements UseCase<void, SendAbsentRequestParams> {
  final RequestRepository _requestRepository;
  SendAbsentRequest(this._requestRepository);
  @override
  Future<Either<Failure, void>> call(SendAbsentRequestParams params) {
    return _requestRepository.createAbsentRequest(params);
  }
}

class SendAbsentRequestParams {
  String? studentId;
  String? requestTypeId;
  String? reason;
  String? fromDate;
  String? toDate;
  SendAbsentRequestParams(this.studentId, this.requestTypeId, this.reason,
      this.fromDate, this.toDate);
  SendAbsentRequestParams.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    requestTypeId = json['requestTypeId'];
    reason = json['reason'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['requestTypeId'] = this.requestTypeId;
    data['reason'] = this.reason;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }
}
