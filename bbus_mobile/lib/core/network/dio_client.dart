import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/network/api_exception.dart';
import 'package:bbus_mobile/core/network/api_interceptors.dart';
import 'package:bbus_mobile/core/network/logger_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  DioClient()
      : _dio = Dio(
          BaseOptions(
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              // baseUrl: ApiConstants.baseApiUrl,
              responseType: ResponseType.json,
              sendTimeout: const Duration(seconds: 3),
              receiveTimeout: const Duration(seconds: 3)),
        )..interceptors.addAll([LoggerInterceptor(), ApiInterceptors()]);
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
      return _returnResponse(res);
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
      return _returnResponse(res);
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
      return _returnResponse(res);
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
      return _returnResponse(res);
    } catch (e) {
      rethrow;
    }
  }
}

dynamic _returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
      return response.data;
    case 201:
      return response.data;
    case 400:
      throw BadRequestException(response.data["message"].toString());
    case 401:
      throw UnauthorizedException(response.data["message"].toString());
    case 403:
      throw ForbiddenException(response.data["message"].toString());
    case 404:
      throw NotFoundException(response.data["message"].toString());
    case 422:
      throw UnprocessableContentException(response.data["message"].toString());
    case 500:
      throw InternalServerException(response.data["message"].toString());
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

enum Method { get, post, put, patch, delete }
