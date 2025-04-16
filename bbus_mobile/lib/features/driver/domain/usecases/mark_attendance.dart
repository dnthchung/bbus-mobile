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
    return await _studentListRepository.markAttendance(
        studentId: params.studentId, busId: params.busId, image: params.image);
  }
}

class MarkAttendanceParams {
  final String studentId;
  final String busId;
  final File image;
  MarkAttendanceParams(this.studentId, this.busId, this.image);
}
