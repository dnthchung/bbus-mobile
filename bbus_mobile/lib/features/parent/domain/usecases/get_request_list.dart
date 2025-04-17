import 'package:bbus_mobile/common/entities/request.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/parent/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';

class GetRequestList implements UseCase<List<RequestEntity>, NoParams> {
  final RequestRepository _requestRepository;
  GetRequestList(this._requestRepository);
  @override
  Future<Either<Failure, List<RequestEntity>>> call(NoParams params) async {
    return await _requestRepository.getRequestList();
  }
}
