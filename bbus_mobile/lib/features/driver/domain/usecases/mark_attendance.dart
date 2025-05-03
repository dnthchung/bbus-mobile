import 'dart:io';

import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/driver/domain/repository/student_list_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAttendance implements UseCase<void, MarkAttendanceParams> {
  final StudentListRepository _studentListRepository;
  MarkAttendance(this._studentListRepository);
  @override
  Future<Either<Failure, void>> call(MarkAttendanceParams params) async {
    print('object');
    return await _studentListRepository.markAttendance(
        attendanceId: params.attendanceId,
        checkin: params.checkin,
        checkout: params.checkout);
  }
}

class MarkAttendanceParams {
  final String attendanceId;
  DateTime? checkin;
  DateTime? checkout;
  MarkAttendanceParams(this.attendanceId, this.checkin, this.checkout);
  Map<String, dynamic> toJson() => {
        "attendanceId": attendanceId,
        "checkin": checkin != null ? '${checkin?.toIso8601String()}+07:00' : '',
        "checkout":
            checkout != null ? '${checkout?.toIso8601String()}+07:00' : '',
      };
}
