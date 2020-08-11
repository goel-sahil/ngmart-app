class MarkNotificationResponse {
  String message;
  Data data;

  MarkNotificationResponse({this.message, this.data});

  MarkNotificationResponse.fromJson(Map<String, dynamic> json) {
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
  int totalCartItems;

  Data({this.totalCartItems});

  Data.fromJson(Map<String, dynamic> json) {
    totalCartItems = json['total_notifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_notifications'] = this.totalCartItems;
    return data;
  }
}
