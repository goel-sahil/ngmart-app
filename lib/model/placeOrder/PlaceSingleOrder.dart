class PlaceSingleOrder {
  int addressId;
  int productId;
  num quantity;

  PlaceSingleOrder({this.addressId, this.productId, this.quantity});

  PlaceSingleOrder.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }
}
