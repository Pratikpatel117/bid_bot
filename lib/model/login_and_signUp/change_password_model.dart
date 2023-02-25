class ChangePasswordRequest {
  String isEmail;
  String oldPassword;
  String newPassword;
  String userId;

  ChangePasswordRequest(
      {this.isEmail, this.oldPassword, this.newPassword, this.userId});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    isEmail = json['isEmail'];
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEmail'] = this.isEmail;
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    data['userId'] = this.userId;
    return data;
  }
}

class ChangePasswordResponse {
  bool status;
  String message;
  var data;

  ChangePasswordResponse({this.status, this.message, this.data});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
}
