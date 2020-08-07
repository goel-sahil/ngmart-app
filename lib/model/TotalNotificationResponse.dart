class TotalNotificationResponse {
  Data data;

  TotalNotificationResponse({this.data});

  TotalNotificationResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int totalNotifications;
  int totalCartItems;

  Data({this.totalNotifications, this.totalCartItems});

  Data.fromJson(Map<String, dynamic> json) {
    totalNotifications = json['total_notifications'];
    totalCartItems = json['total_cart_items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_notifications'] = this.totalNotifications;
    data['total_cart_items'] = this.totalCartItems;
    return data;
  }
}
