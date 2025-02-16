import 'package:bbus_mobile/core/network/auth_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  DioClient()
      : _dio = Dio(BaseOptions(
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            responseType: ResponseType.json,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)))
          ..interceptors.addAll([LogInterceptor(), AuthInterceptor()]);
  // GET METHOD
  Future<dynamic> get(
    String url, {
    data,
    Map<String, dynamic>? queryPrams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.get(url,
          data: data,
          queryParameters: queryPrams,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  // POST METHOD
  Future<dynamic> post(
    String url, {
    data,
    Map<String, dynamic>? queryPrams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.post(url,
          data: data,
          queryParameters: queryPrams,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
  Future<dynamic> put(
    String url, {
    data,
    Map<String, dynamic>? queryPrams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.put(url,
          data: data,
          queryParameters: queryPrams,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryPrams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dio.delete(url,
          data: data,
          queryParameters: queryPrams,
          options: options,
          cancelToken: cancelToken);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
