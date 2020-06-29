class OtpRequest {
  int userId;
  String code;

  OtpRequest({this.userId, this.code});

  OtpRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['code'] = this.code;
    return data;
  }
}
