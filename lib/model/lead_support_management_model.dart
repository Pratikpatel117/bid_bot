class LeadSupportRequest {
  String projectId;
  LeadSupportRequest({this.projectId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "projectId": projectId,
    };
    return map;
  }
}

class LeadSupportManagementResponse {
  bool status;
  String message;
  List<LeadSupportData> data;

  LeadSupportManagementResponse({this.status, this.message, this.data});

  LeadSupportManagementResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <LeadSupportData>[];
      json['data'].forEach((v) {
        data.add(new LeadSupportData.fromJson(v));
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

class LeadSupportData {
  String id;
  String name;
  String email;
  String phone;
  String profileUrl;
  bool isChecked = false;
  LeadSupportData(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.profileUrl,
      this.isChecked});

  LeadSupportData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    email = json['email'].toString();
    phone = json['phone'].toString();
    profileUrl = json['profileUrl'].toString();
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profileUrl'] = this.profileUrl;
    return data;
  }

  void checkDone() {
    isChecked = !isChecked;
  }
}
