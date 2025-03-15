import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:dio/dio.dart';

// ignore: constant_identifier_names
final List<String> publicEndpoints = [
  '/auth/login',
  '/register',
  '/public-data'
];

//* Request methods PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as Bearer token.
class ApiInterceptors extends Interceptor {
  final SecureLocalStorage _secureLocalStorage = sl<SecureLocalStorage>();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (ApiConstants.publicEndpoints
        .any((endpoint) => options.path.contains(endpoint))) {
      return handler.next(options); // Skip authentication
    }
    final token = await _secureLocalStorage.load(key: 'token');
    options.headers['Authorization'] = 'Bearer $token';
    logger.i(options.headers);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(err.response?.statusCode);
    switch (err.response?.statusCode) {
      case 401:
        break;
      case 403:
        break;
      case 400:
        break;
      default:
    }
    super.onError(err, handler);
  }
}
