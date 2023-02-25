class AddMeAsBidderRequest {
  String subscriptionId;
  String verticalId;
  String link;
  String appId;

  AddMeAsBidderRequest(
      {this.subscriptionId, this.verticalId, this.link, this.appId});

  AddMeAsBidderRequest.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'].toString();
    verticalId = json['verticalId'].toString();
    link = json['link'].toString();
    appId = json['appId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionId'] = this.subscriptionId.toString();
    data['verticalId'] = this.verticalId.toString();
    data['link'] = this.link.toString();
    data['appId'] = this.appId.toString();
    return data;
  }
}

class AddMeAsBidderResponse {
  bool status;
  String message;
  AddMeBidderData data;

  AddMeAsBidderResponse({this.status, this.message, this.data});

  AddMeAsBidderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new AddMeBidderData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class AddMeBidderData {
  String link;
  EmployeeData employeeData;

  AddMeBidderData({this.link, this.employeeData});

  AddMeBidderData.fromJson(Map<String, dynamic> json) {
    link = json['link'].toString();
    employeeData = json['employeeData'] != null
        ? new EmployeeData.fromJson(json['employeeData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    if (this.employeeData != null) {
      data['employeeData'] = this.employeeData.toJson();
    }
    return data;
  }
}

class EmployeeData {
  int employeeId;
  String name;
  int sphereId;
  String sphere;
  int sphereTypeId;
  String sphereType;
  String email;
  String contactId;
  int customerId;
  String customerName;
  int isFidoEnable;
  int mfa;
  String userToken;
  String token;

  EmployeeData(
      {this.employeeId,
      this.name,
      this.sphereId,
      this.sphere,
      this.sphereTypeId,
      this.sphereType,
      this.email,
      this.contactId,
      this.customerId,
      this.customerName,
      this.isFidoEnable,
      this.mfa,
      this.userToken,
      this.token});

  EmployeeData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    name = json['name'].toString();
    sphereId = json['sphereId'];
    sphere = json['sphere'].toString();
    sphereTypeId = json['sphereTypeId'];
    sphereType = json['sphereType'].toString();
    email = json['email'].toString();
    contactId = json['contactId'].toString();
    customerId = json['customerId'];
    customerName = json['customerName'].toString();
    isFidoEnable = json['isFidoEnable'];
    mfa = json['mfa'];
    userToken = json['userToken'].toString();
    token = json['token'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['name'] = this.name;
    data['sphereId'] = this.sphereId;
    data['sphere'] = this.sphere;
    data['sphereTypeId'] = this.sphereTypeId;
    data['sphereType'] = this.sphereType;
    data['email'] = this.email;
    data['contactId'] = this.contactId;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['isFidoEnable'] = this.isFidoEnable;
    data['mfa'] = this.mfa;
    data['userToken'] = this.userToken;
    data['token'] = this.token;
    return data;
  }
}

class RemoveBids {
  bool status;
  String message;

  RemoveBids({this.status, this.message});

  RemoveBids.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
