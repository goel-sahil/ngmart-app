class PlaceOrderRequest {
  int addressId;

  PlaceOrderRequest({this.addressId});

  PlaceOrderRequest.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    return data;
  }
}
