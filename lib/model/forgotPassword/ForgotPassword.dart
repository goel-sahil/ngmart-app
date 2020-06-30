class ForgotPasswordResponse {
  String message;
  Data data;

  ForgotPasswordResponse({this.message, this.data});

  ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int code;
  int userId;

  Data({this.code, this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['user_id'] = this.userId;
    return data;
  }
}
