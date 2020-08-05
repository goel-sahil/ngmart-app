import 'dart:ui';

class LoginError {
  String error;
  int id;
  int status;
  VoidCallback onAlertPop;

  LoginError({this.error,this.status,this.onAlertPop,this.id});

  LoginError.fromJson(Map<String, dynamic> json) {
    error = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.error;
    data['id'] = this.id;
    return data;
  }
}