class ResetPasswordRequest {
  String code;
  int userId;
  String password;

  ResetPasswordRequest({this.code, this.userId, this.password});

  ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    userId = json['user_id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['password'] = this.password;
    return data;
  }
}
