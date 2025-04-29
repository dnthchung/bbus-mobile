class ApiConstants {
  //API
  static const String baseApiUrl = "http://10.0.2.2:8080";
  // static const String baseApiUrl = "http://172.20.10.2:8080";
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
  static const String updateAvatar = '/user/upd-avatar';
  static const String updateChild = '/student/upd';
  static const String getCheckpointByRoute = '/checkpoint/by-route';
  static const String changePasswordApiUrl = '/user/change-pwd';
  static const String getRefreshTokenUrl = '/auth/refresh-token';
  static const String checkpointUrl = '/checkpoint/have-route';
  static const String reportTypeUrl = '/request-type/list';
  static const String requestListUrl = '/request/my-requests';
  static const String addRequestUrl = '/request/add';
  static const String socketAddress = 'ws://10.0.2.2:8080/ws';
  static const String childrenListUrl = '/parent/list-student';
  static const String registerCheckpointUrl =
      '/parent/register-checkpoint-for-all-children';
  static const String getBusSchedule = '/driver/get-schedule';
  static const String getAttandance = '/attendance/get-attendance';
  static const String markAttendance = '/attendance/manual-attendance';
  static const String completeSchedule = '/bus-schedule/complete';

  static const List<String> publicEndpoints = [
    loginApiUrl,
    forgotPassword,
    otpVerification,
    resetPassword,
  ];
  static const String emptyData = 'Bad state: No element';
}
