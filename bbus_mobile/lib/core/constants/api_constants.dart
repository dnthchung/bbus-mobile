class ApiConstants {
  //API
  // Run cmd: ipconfig -> copy ipv4 address to baseApiUrl and socketAddress
  // static const String baseApiUrl = "http://10.0.2.2:8080";
  static const String baseApiUrl = "http://192.168.1.7:8080";
  // static const String baseApiUrl = "http://192.168.180.206:8080";
  static const String apiKey = '8581463081de418880661cf14ad3d77a';

  //Endpoints
  static const String loginApiUrl = '/auth/login';
  static const String updatDeviceToken = '/user/update-device-id';
  static const String forgotPassword = '/auth/forgot-password/request';
  static const String otpVerification = '/auth/forgot-password/verify';
  static const String resetPassword = '/auth/forgot-password/reset';
  static const String userApiUrl = '/user';
  static const String busApiUrl = '/bus';
  static const String updateProfile = '/user/upd';
  static const String updateAvatar = '/user/upd-avatar-user-logged-in';
  static const String updateChild = '/student/upd';
  static const String getCheckpointByRoute = '/checkpoint/by-route';
  static const String changePasswordApiUrl = '/user/change-pwd';
  static const String getRefreshTokenUrl = '/auth/refresh-token';
  static const String checkpointUrl = '/checkpoint/have-route';
  static const String reportTypeUrl = '/request-type/list';
  static const String requestListUrl = '/request/my-requests';
  static const String cancelRequest = '/request/reply';
  static const String addRequestUrl = '/request/add';
  // static const String socketAddress = 'ws://10.0.2.2:8080/ws';
  static const String socketAddress = 'ws://192.168.1.7:8080/ws';
  static const String childrenListUrl = '/parent/list-student';
  static const String registerCheckpointForSingleUrl =
      '/parent/checkpoint/register/one';
  static const String registerCheckpointUrl = '/parent/checkpoint/register/all';
  static const String getBusSchedule = '/get-schedule';
  static const String getAttandance = '/attendance/get-attendance';
  static const String getChildAttandance = '/attendance/parent';
  static const String markAttendance = '/attendance/manual-attendance';
  static const String completeSchedule = '/bus-schedule/complete';
  static const String getSCheduleByMonth = '/get-schedule-by-month';
  static const String getEventOpenTime = '/event';

  static const Map<String, String> eventName = {
    'register': 'Set up time registration',
  };
  static const List<String> publicEndpoints = [
    loginApiUrl,
    forgotPassword,
    otpVerification,
    resetPassword,
  ];
  static const String emptyData = 'Bad state: No element';
}
