import 'dart:convert';

import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/utils/jwt_converter.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

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
      final refreshToke = await _secureLocalStorage.load(key: 'refreshToken');
      logger.i(refreshToke);
      // if (!isTokenExpired(token)) {
      //   logger.e('Token is expired: $token');
      //   throw TokenExpireException();
      // }
      return user;
    } catch (e) {
      logger.e(e.toString());
      throw CacheException(e.toString());
    }
  }
}
