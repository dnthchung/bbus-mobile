class ApiConstants {
  //API
  static const String baseApiUrl = "http://10.0.2.2:8080";
  static const String apiKey = '8581463081de418880661cf14ad3d77a';

  //Endpoints
  static const String loginApiUrl = '/auth/login';
  static const String userApiUrl = '/user';
  static const String changePasswordApiUrl = '/user/change-pwd';
  static const String getRefreshTokenUrl = '/auth/refresh-token';
  static const String checkpointUrl = '/checkpoint/list';
  static const String reportTypeUrl = '/request-type/list';
  static const String reportUrl = '/request/list';
  static const String socketAddress = 'ws://10.0.2.2:8080/ws';
  static const String childrenList = '/parent/student-list';

  static const List<String> publicEndpoints = [
    '/auth/login',
  ];
}
