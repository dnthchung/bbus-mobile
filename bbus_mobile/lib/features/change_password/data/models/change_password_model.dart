class ChangePasswordModel {
  String? id;
  String? currentPassword;
  String? password;
  String? confirmPassword;

  ChangePasswordModel(
      {this.id, this.currentPassword, this.password, this.confirmPassword});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentPassword = json['currentPassword'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currentPassword'] = this.currentPassword;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }
}
