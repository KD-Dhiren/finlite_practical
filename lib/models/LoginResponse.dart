class LoginResponse {
  bool success;
  Data data;
  String message;

  LoginResponse({this.success, this.data, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  UserDetails userDetails;

  Data({this.userDetails});

  Data.fromJson(Map<String, dynamic> json) {
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails.toJson();
    }
    return data;
  }
}

class UserDetails {
  String customerId;
  String customerGroupId;
  String firstname;
  String lastname;
  String email;
  String telephone;
  String apiToken;
  String status;
  String userVerified;

  UserDetails(
      {this.customerId,
      this.customerGroupId,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.apiToken,
      this.status,
      this.userVerified});

  UserDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerGroupId = json['customer_group_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    telephone = json['telephone'];
    apiToken = json['api_token'];
    status = json['status'];
    userVerified = json['user_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_group_id'] = this.customerGroupId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['telephone'] = this.telephone;
    data['api_token'] = this.apiToken;
    data['status'] = this.status;
    data['user_verified'] = this.userVerified;
    return data;
  }
}
