import 'dart:convert';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  final String baseURL = '';
  Future<UserModel> login(
      {required String username, required String password}) async {
    final response = await http.post(Uri.parse(baseURL),
        body: jsonEncode({username: username, password: password}),
        headers: {'Content-Type': 'application/json'});
    return UserModel.fromJson(jsonDecode(response.body));
  }
}
