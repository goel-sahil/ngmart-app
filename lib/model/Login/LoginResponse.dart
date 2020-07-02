class LoginResponse {
  String message;
  Data data;

  LoginResponse({this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
  User user;
  String token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  int roleId;
  int status;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  List<UserAddresses> userAddresses;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.roleId,
        this.status,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.userAddresses});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    roleId = json['role_id'];
    status = json['status'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['user_addresses'] != null) {
      userAddresses = new List<UserAddresses>();
      json['user_addresses'].forEach((v) {
        userAddresses.add(new UserAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['role_id'] = this.roleId;
    data['status'] = this.status;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.userAddresses != null) {
      data['user_addresses'] =
          this.userAddresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddresses {
  int id;
  String address;
  String city;
  String state;
  String country;
  String pinCode;
  int userId;
  String createdAt;
  String updatedAt;

  UserAddresses(
      {this.id,
        this.address,
        this.city,
        this.state,
        this.country,
        this.pinCode,
        this.userId,
        this.createdAt,
        this.updatedAt});

  UserAddresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pinCode = json['pin_code'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pin_code'] = this.pinCode;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
