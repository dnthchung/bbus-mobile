class ResetPasswordModel {
  String? sessionId;
  String? password;
  String? confirmPassword;

  ResetPasswordModel({
    this.sessionId,
    this.password,
    this.confirmPassword,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordModel(
        sessionId: json["sessionId"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "sessionId": sessionId,
      "password": password,
      "confirmPassword": confirmPassword,
    };
  }
}
