class FilterRequest {
  String subscriptionId;
  String verticalId;
  String employeeId;
  String bidDate;
  String phaseId;
  String industryId;
  String typeId;
  String leadId;

  FilterRequest(
      {this.subscriptionId,
      this.verticalId,
      this.employeeId,
      this.bidDate,
      this.phaseId,
      this.industryId,
      this.typeId,
      this.leadId});

  FilterRequest.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    employeeId = json['employeeId'];
    bidDate = json['bidDate'];
    phaseId = json['phaseId'];
    industryId = json['industryId'];
    typeId = json['typeId'];
    leadId = json['leadId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['employeeId'] = this.employeeId;
    data['bidDate'] = this.bidDate;
    data['phaseId'] = this.phaseId;
    data['industryId'] = this.industryId;
    data['typeId'] = this.typeId;
    data['leadId'] = this.leadId;
    return data;
  }
}
