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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (ApiConstants.publicEndpoints
        .any((endpoint) => err.requestOptions.path.contains(endpoint))) {
      return handler.next(err);
    }
    logger.e(err);
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final refreshToken = await _secureLocalStorage.load(key: 'refresh_token');
      Dio retryDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseApiUrl,
        ),
      );
      var response = await retryDio.post(
        ApiConstants.getRefreshTokenUrl,
        data: {refreshToken},
        options: Options(
          headers: {"Content-Type": 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        await _secureLocalStorage.save(key: 'token', value: 'access_token');
        await _secureLocalStorage.save(
            key: 'refresh_token', value: 'refresh_token');
        handler.resolve(response);
      }
    }
    super.onError(err, handler);
  }
}
