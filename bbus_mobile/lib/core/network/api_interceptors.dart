import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:dio/dio.dart';

// ignore: constant_identifier_names
final List<String> publicEndpoints = [
  ApiConstants.loginApiUrl,
  '/public-data',
  ApiConstants.forgotPassword,
  ApiConstants.otpVerification,
  ApiConstants.resetPassword,
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
    logger.e(err);
    if (ApiConstants.publicEndpoints
        .any((endpoint) => err.requestOptions.path.contains(endpoint))) {
      return handler.next(err);
    }
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final refreshToken = await _secureLocalStorage.load(key: 'refreshToken');
      try {
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
        logger.i(response);
        if (response.statusCode == 200) {
          await _secureLocalStorage.save(
              key: 'token', value: response.data['data']['access_token']);
          await _secureLocalStorage.save(
              key: 'refreshToken',
              value: response.data['data']['refresh_token']);
          handler.resolve(response);
        }
      } catch (e) {
        logger.e(e);
        throw Exception();
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data['status'] == 403) {
      logger.i(response.data);
      final refreshToken = await _secureLocalStorage.load(key: 'refreshToken');
      Dio retryDio = Dio(
        BaseOptions(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          baseUrl: ApiConstants.baseApiUrl,
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      var res = await retryDio.post(
        ApiConstants.getRefreshTokenUrl,
        data: {"refreshToken": refreshToken},
        options: Options(
          headers: {"Content-Type": 'application/json'},
        ),
      );
      if (res.statusCode == 200) {
        await _secureLocalStorage.save(
            key: 'token', value: res.data['data']['access_token']);
        await _secureLocalStorage.save(
            key: 'refreshToken', value: res.data['data']['refresh_token']);
        return handler.resolve(res);
      }
    }
    super.onResponse(response, handler);
  }
}
