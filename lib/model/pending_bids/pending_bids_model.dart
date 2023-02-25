class ShowMessageGetJob {
  String employeeId;
  String customerId;
  String projectId;

  ShowMessageGetJob({this.employeeId, this.customerId, this.projectId});

  ShowMessageGetJob.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    customerId = json['customerId'];
    projectId = json['projectId'];
    customerId = json['customerId'];
    projectId = json['projectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['customerId'] = this.customerId;
    data['projectId'] = this.projectId;
    return data;
  }
}
