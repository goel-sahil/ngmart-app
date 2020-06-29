class SignUpRequest {
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  AddressData address;

  SignUpRequest(
      {this.firstName,
        this.lastName,
        this.email,
        this.password,
        this.phoneNumber,
        this.address});

  SignUpRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phone_number'];
    address =
    json['address'] != null ? new AddressData.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone_number'] = this.phoneNumber;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class AddressData {
  String address;
  String city;
  String state;
  String country;
  String pinCode;

  AddressData({this.address, this.city, this.state, this.country, this.pinCode});

  AddressData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pinCode = json['pin_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pin_code'] = this.pinCode;
    return data;
  }
}
