class ApiConstants {
  //API
  static const String baseApiUrl = "http://10.0.2.2:8080";
  static const String apiKey = '8581463081de418880661cf14ad3d77a';

  //Endpoints
  static const String loginApiUrl = '/auth/login';
  static const String userApiUrl = '/user';
  static const List<String> publicEndpoints = [
    '/auth/login',
  ];
}
