import 'package:bbus_mobile/common/entities/request_type.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/request/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllRequestType implements UseCase<List<RequestTypeEntity>, NoParams> {
  final RequestRepository _requestRepository;
  GetAllRequestType(this._requestRepository);
  @override
  Future<Either<Failure, List<RequestTypeEntity>>> call(NoParams params) async {
    return await _requestRepository.getListRequestType();
  }
}
