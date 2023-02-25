class EmployeeBidRequest {
  String employeeId;
  String todayDate;

  EmployeeBidRequest({this.employeeId, this.todayDate});

  EmployeeBidRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    todayDate = json['todayDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['todayDate'] = this.todayDate;
    return data;
  }
}

class EmployeeBidResponse {
  bool status;
  String message;
  List<BidData> data;

  EmployeeBidResponse({this.status, this.message, this.data});

  EmployeeBidResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BidData>[];
      json['data'].forEach((v) {
        data.add(new BidData.fromJson(v));
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

class BidData {
  int projectId;
  String projectName;
  int leadId;
  String leadName;
  int phaseId;
  String phase;
  int subPhaseId;
  String subPhase;
  int supportId;
  String supportName;
  String salePrice;
  String margin;

  BidData(
      {this.projectId,
      this.projectName,
      this.leadId,
      this.leadName,
      this.phaseId,
      this.phase,
      this.subPhaseId,
      this.subPhase,
      this.supportId,
      this.supportName,
      this.salePrice,
      this.margin});

  BidData.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    projectName = json['projectName'];
    leadId = json['leadId'];
    leadName = json['leadName'];
    phaseId = json['phaseId'];
    phase = json['phase'];
    subPhaseId = json['subPhaseId'];
    subPhase = json['subPhase'];
    supportId = json['supportId'];
    supportName = json['supportName'];
    salePrice = json['salePrice'].toString();
    margin = json['margin'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['leadId'] = this.leadId;
    data['leadName'] = this.leadName;
    data['phaseId'] = this.phaseId;
    data['phase'] = this.phase;
    data['subPhaseId'] = this.subPhaseId;
    data['subPhase'] = this.subPhase;
    data['supportId'] = this.supportId;
    data['supportName'] = this.supportName;
    data['salePrice'] = this.salePrice;
    data['margin'] = this.margin;
    return data;
  }
}
