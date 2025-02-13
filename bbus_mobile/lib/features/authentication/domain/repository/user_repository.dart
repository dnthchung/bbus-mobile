import 'package:bbus_mobile/core/resources/data_state.dart';
import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';

abstract class UserRepository {
  Future<DataState<List<UserEntity>>> getUserList();
}