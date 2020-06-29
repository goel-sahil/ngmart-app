import 'dart:ui';

class APIError {
  String error;
  int status;
  VoidCallback onAlertPop;

  APIError({this.error,this.status,this.onAlertPop});

  APIError.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}