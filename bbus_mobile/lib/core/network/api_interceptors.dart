import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

// ignore: constant_identifier_names
final List<String> publicEndpoints = [
  '/auth/login',
  '/register',
  '/public-data'
];
const String API_KEY =
    'cdc9a8ca8aa17b6bed3aa3611a835105bbb4632514d7ca8cf55dbbc5966a7cae';

//* Request methods PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as Bearer token.
class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ApiConstants.publicEndpoints
        .any((endpoint) => options.path.contains(endpoint))) {
      return handler.next(options); // Skip authentication
    }
    options.headers['Authorization'] = 'Bearer $API_KEY';
    handler.next(options);
  }
}
