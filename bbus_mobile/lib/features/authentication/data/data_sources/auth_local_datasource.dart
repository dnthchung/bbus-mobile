import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';

sealed class AuthLocalDatasource {
  Future<bool> checkLoggedInStatus();
}

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final SecureLocalStorage _secureLocalStorage;
  AuthLocalDatasourceImpl(this._secureLocalStorage);
  @override
  Future<bool> checkLoggedInStatus() async {
    try {
      final token = await _secureLocalStorage.load(key: 'token');
      if (token.isNotEmpty) return true;
      throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }
}
