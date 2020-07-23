class DeviceTokenResponse {
  String deviceToken;

  DeviceTokenResponse({this.deviceToken});

  DeviceTokenResponse.fromJson(Map<String, dynamic> json) {
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_token'] = this.deviceToken;
    return data;
  }
}
