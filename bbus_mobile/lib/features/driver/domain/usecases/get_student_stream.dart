import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/driver/domain/repository/student_list_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudentStream
    implements UseCase<Stream<List<StudentEntity>>, StudentStreamParams> {
  final StudentListRepository _studentListRepository;
  GetStudentStream(this._studentListRepository);
  @override
  Future<Either<Failure, Stream<List<StudentEntity>>>> call(
      StudentStreamParams params) async {
    try {
      // await _studentListRepository.fetchInitialList(params);
      await _studentListRepository.start(params.busId, params.direction);
      final stream = _studentListRepository.getStudentListStream();
      return Right(stream);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class StudentStreamParams {
  final String busId;
  final int direction;
  StudentStreamParams(this.busId, this.direction);
}
