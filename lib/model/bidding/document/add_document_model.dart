class AddDocumentRequest {
  String employeeId;
  String projectId;
  String tabId;
  String document;
  String fileName;
  String fileSize;
  String isSend;
  String subscriptionId;
  String verticalId;
  String sphereTypeId;

  AddDocumentRequest(
      {this.employeeId,
      this.projectId,
      this.tabId,
      this.document,
      this.fileName,
      this.fileSize,
      this.isSend,
      this.subscriptionId,
      this.verticalId,
      this.sphereTypeId});

  AddDocumentRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    projectId = json['projectId'];
    tabId = json['tabId'];
    document = json['document'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    isSend = json['isSend'];
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    sphereTypeId = json['sphereTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['projectId'] = this.projectId;
    data['tabId'] = this.tabId;
    data['document'] = this.document;
    data['fileName'] = this.fileName;
    data['fileSize'] = this.fileSize;
    data['isSend'] = this.isSend;
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['sphereTypeId'] = this.sphereTypeId;
    return data;
  }
}
