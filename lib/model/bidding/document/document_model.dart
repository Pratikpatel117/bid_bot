class DocumentDataRequest {
  String employeeId;
  String projectId;
  String verticalId;
  String tabId;

  DocumentDataRequest(
      {this.employeeId, this.projectId, this.verticalId, this.tabId});

  DocumentDataRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    projectId = json['projectId'];
    verticalId = json['verticalId'];
    tabId = json['tabId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['projectId'] = this.projectId;
    data['verticalId'] = this.verticalId;
    data['tabId'] = this.tabId;
    return data;
  }
}

class DocumentDataResponce {
  bool status;
  String message;
  List<DocumentData> data;

  DocumentDataResponce({this.status, this.message, this.data});

  DocumentDataResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DocumentData>[];
      json['data'].forEach((v) {
        data.add(new DocumentData.fromJson(v));
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

class DocumentData {
  String docId;
  String fileName;
  String fileExt;
  String fileSize;
  String createdDate;
  String createdBy;

  DocumentData(
      {this.docId,
      this.fileName,
      this.fileExt,
      this.fileSize,
      this.createdDate,
      this.createdBy});

  DocumentData.fromJson(Map<String, dynamic> json) {
    docId = json['docId'].toString();
    fileName = json['fileName'].toString();
    fileExt = json['fileExt'].toString();
    fileSize = json['fileSize'].toString();
    createdDate = json['createdDate'].toString();
    createdBy = json['createdBy'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docId'] = this.docId;
    data['fileName'] = this.fileName;
    data['fileExt'] = this.fileExt;
    data['fileSize'] = this.fileSize;
    data['createdDate'] = this.createdDate;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
