import 'dart:convert';

import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/utils/jwt_converter.dart';

sealed class AuthLocalDatasource {
  Future<Map<String, dynamic>> checkLoggedInStatus();
}

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final SecureLocalStorage _secureLocalStorage;
  AuthLocalDatasourceImpl(this._secureLocalStorage);
  @override
  Future<Map<String, dynamic>> checkLoggedInStatus() async {
    try {
      final user = jsonDecode(await _secureLocalStorage.load(key: 'user'));
      final token = await _secureLocalStorage.load(key: 'token');
      return user;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
