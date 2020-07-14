class ChangePasswordRequest {
  String oldPassword;
  String password;

  ChangePasswordRequest({this.oldPassword, this.password});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    oldPassword = json['old_password'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_password'] = this.oldPassword;
    data['password'] = this.password;
    return data;
  }
}
