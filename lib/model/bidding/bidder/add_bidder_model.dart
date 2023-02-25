class AddBidderRequest {
  String employeeId;
  String customerId;
  String projectId;
  String contactId;

  AddBidderRequest(
      {this.employeeId, this.customerId, this.projectId, this.contactId});

  AddBidderRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    customerId = json['customerId'];
    projectId = json['projectId'];
    contactId = json['contactId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['customerId'] = this.customerId;
    data['projectId'] = this.projectId;
    data['contactId'] = this.contactId;
    return data;
  }
}

class UploadResponse {
  bool status;
  String message;
  String data;

  UploadResponse({this.status, this.message, this.data});

  UploadResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
