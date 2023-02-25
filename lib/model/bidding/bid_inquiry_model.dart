class BidInquiryRequest {
  String subscriptionId;
  String verticalId;
  String customerContactId;
  String projectName;
  String description;
  String estimatedBidDate;
  String isConfidentialPrivateProject;
  String employeeId;
  List<BidInquiryDocument> document;
  String isEquipmentReplacement;
  String isPartsPriceRequest;
  String isPlan;
  String isSpec;

  BidInquiryRequest(
      {this.subscriptionId,
      this.verticalId,
      this.customerContactId,
      this.projectName,
      this.description,
      this.estimatedBidDate,
      this.isConfidentialPrivateProject,
      this.employeeId,
      this.document,
      this.isEquipmentReplacement,
      this.isPartsPriceRequest,
      this.isPlan,
      this.isSpec});

  BidInquiryRequest.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    customerContactId = json['customerContactId'];
    projectName = json['projectName'];
    description = json['description'];
    estimatedBidDate = json['estimatedBidDate'];
    isConfidentialPrivateProject = json['isConfidentialPrivateProject'];
    employeeId = json['employeeId'];
    if (json['document'] != null) {
      document = <BidInquiryDocument>[];
      json['document'].forEach((v) {
        document.add(new BidInquiryDocument.fromJson(v));
      });
    }
    isEquipmentReplacement = json['isEquipmentReplacement'];
    isPartsPriceRequest = json['isPartsPriceRequest'];
    isPlan = json['isPlan'];
    isSpec = json['isSpec'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['customerContactId'] = this.customerContactId;
    data['projectName'] = this.projectName;
    data['description'] = this.description;
    data['estimatedBidDate'] = this.estimatedBidDate;
    data['isConfidentialPrivateProject'] = this.isConfidentialPrivateProject;
    data['employeeId'] = this.employeeId;
    if (this.document != null) {
      data['document'] = this.document.map((v) => v.toJson()).toList();
    }
    data['isEquipmentReplacement'] = this.isEquipmentReplacement;
    data['isPartsPriceRequest'] = this.isPartsPriceRequest;
    data['isPlan'] = this.isPlan;
    data['isSpec'] = this.isSpec;
    return data;
  }
}

class BidInquiryDocument {
  String document;
  String fileName;
  String fileSize;

  BidInquiryDocument({this.document, this.fileName, this.fileSize});

  BidInquiryDocument.fromJson(Map<String, dynamic> json) {
    document = json['document'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document'] = this.document;
    data['fileName'] = this.fileName;
    data['fileSize'] = this.fileSize;
    return data;
  }
}

class BidInquiryResponse {
  bool status;
  String message;
  Null data;

  BidInquiryResponse({this.status, this.message, this.data});

  BidInquiryResponse.fromJson(Map<String, dynamic> json) {
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
