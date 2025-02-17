import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/network/api_interceptors.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio);
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
enum Method { get, post, put, patch, delete }
