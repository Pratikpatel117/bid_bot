class CreateNewProjectRequest {
  String projectName;
  String leadId;
  String phaseId;
  String typeId;
  String industryId;
  String bidDate;
  String projectDescription;
  String employeeId;
  String estimatorId;
  String bidInquiryId;
  String isPrivateProject;

  CreateNewProjectRequest(
      {this.projectName,
      this.leadId,
      this.phaseId,
      this.typeId,
      this.industryId,
      this.bidDate,
      this.projectDescription,
      this.employeeId,
      this.estimatorId,
      this.bidInquiryId,
      this.isPrivateProject});

  CreateNewProjectRequest.fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    leadId = json['leadId'];
    phaseId = json['phaseId'];
    typeId = json['typeId'];
    industryId = json['industryId'];
    bidDate = json['bidDate'];
    projectDescription = json['projectDescription'];
    employeeId = json['employeeId'];
    estimatorId = json['estimatorId'];
    bidInquiryId = json['bidInquiryId'];
    isPrivateProject = json['isPrivateProject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectName'] = this.projectName;
    data['leadId'] = this.leadId;
    data['phaseId'] = this.phaseId;
    data['typeId'] = this.typeId;
    data['industryId'] = this.industryId;
    data['bidDate'] = this.bidDate;
    data['projectDescription'] = this.projectDescription;
    data['employeeId'] = this.employeeId;
    data['estimatorId'] = this.estimatorId;
    data['bidInquiryId'] = this.bidInquiryId;
    data['isPrivateProject'] = this.isPrivateProject;
    return data;
  }
}

class DropDownResponse {
  bool status;
  String message;
  List<DrawerData> data;

  DropDownResponse({this.status, this.message, this.data});

  DropDownResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DrawerData>[];
      json['data'].forEach((v) {
        data.add(new DrawerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DrawerData {
  String key;
  String value;

  DrawerData({this.key, this.value});

  DrawerData.fromJson(Map<String, dynamic> json) {
    key = json['key'].toString();
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }

  void changeValue(DrawerData newValue) {
    this.key = newValue.key;
    this.value = newValue.value;
  }
}
