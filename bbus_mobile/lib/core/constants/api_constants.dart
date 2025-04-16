class ApiConstants {
  //API
  static const String baseApiUrl = "http://10.0.2.2:8080";
  // static const String baseApiUrl = "http://192.168.28.122:8080";
  static const String apiKey = '8581463081de418880661cf14ad3d77a';

  //Endpoints
  static const String loginApiUrl = '/auth/login';
  static const String forgotPassword = 'auth/forgot-password/request';
  static const String otpVerification = 'auth/forgot-password/verify';
  static const String resetPassword = 'forgot-password/reset';
  static const String userApiUrl = '/user';
  static const String changePasswordApiUrl = '/user/change-pwd';
  static const String getRefreshTokenUrl = '/auth/refresh-token';
  static const String checkpointUrl = '/checkpoint/list';
  static const String reportTypeUrl = '/request-type/list';
  static const String requestListUrl = '/request/list';
  static const String addRequestUrl = '/request/add';
  static const String socketAddress = 'ws://10.0.2.2:8080/ws';
  static const String childrenListUrl = '/parent/list-student';
  static const String registerCheckpointUrl = '/parent/register-checkpoint';
  static const String getBusSchedule = '/driver/get-schedule';
  static const String getAttandance = '/attendance/get-attendance';

  static const List<String> publicEndpoints = [
    '/auth/login',
  ];
  static const String emptyData = 'Bad state: No element';
}
