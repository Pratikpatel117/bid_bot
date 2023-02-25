class ManageBidRequests {
  bool status;
  String message;
  List<ManageBidData> data;

  ManageBidRequests({this.status, this.message, this.data});

  ManageBidRequests.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ManageBidData>[];
      json['data'].forEach((v) {
        data.add(new ManageBidData.fromJson(v));
      });
    }
  }
}

class ManageBidData {
  String projectName;
  String estimatedBidDate;
  String description;
  int isConfidentialPrivateProject;
  int isEquipmentReplacement;
  int isPartsPriceRequest;
  int leadId;
  String leadName;
  int supportId;
  String supportName;
  int id;
  int createdById;
  String createdBy;
  String createdDate;
  List<dynamic> attachmentUrls;

  ManageBidData(
      {this.projectName,
      this.estimatedBidDate,
      this.description,
      this.isConfidentialPrivateProject,
      this.isEquipmentReplacement,
      this.isPartsPriceRequest,
      this.leadId,
      this.leadName,
      this.supportId,
      this.supportName,
      this.id,
      this.createdById,
      this.createdBy,
      this.createdDate,
      this.attachmentUrls});

  ManageBidData.fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    estimatedBidDate = json['estimatedBidDate'];
    description = json['description'];
    isConfidentialPrivateProject = json['isConfidentialPrivateProject'];
    isEquipmentReplacement = json['isEquipmentReplacement'];
    isPartsPriceRequest = json['isPartsPriceRequest'];
    leadId = json['leadId'];
    leadName = json['leadName'];
    supportId = json['supportId'];
    supportName = json['supportName'];
    id = json['id'];
    createdById = json['createdById'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    attachmentUrls = json['attachmentUrls'];
    if (json["attachmentUrls"] != null) {
      attachmentUrls = <dynamic>[];
      json['attachmentUrls'].forEach((v) {
        attachmentUrls.add(v);
      });
      // json["attachmentUrls"].forEach(e){}
      // attachmentUrls = List.from(attachmentUrls);
// debugPrint("attachmentUrls testing=== $attachmentUrls");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectName'] = this.projectName;
    data['estimatedBidDate'] = this.estimatedBidDate;
    data['description'] = this.description;
    data['isConfidentialPrivateProject'] = this.isConfidentialPrivateProject;
    data['isEquipmentReplacement'] = this.isEquipmentReplacement;
    data['isPartsPriceRequest'] = this.isPartsPriceRequest;
    data['leadId'] = this.leadId;
    data['leadName'] = this.leadName;
    data['supportId'] = this.supportId;
    data['supportName'] = this.supportName;
    data['id'] = this.id;
    data['createdById'] = this.createdById;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['attachmentUrls'] = this.attachmentUrls;
    return data;
  }
}
