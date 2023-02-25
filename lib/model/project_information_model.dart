class ProjectInformation {
  bool status;
  String message;
  ProjectInformationData data;

  ProjectInformation({this.status, this.message, this.data});

  ProjectInformation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProjectInformationData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ProjectInformationData {
  String projectName;
  String projectId;
  String lead;
  String estimatedBy;
  String phase;
  String subPhase;
  String probability;
  String goProbability;
  String createdDate;
  String value;
  String equipmentValue;
  String projectValue;
  String projectSQFootage;
  String margin;
  String description;
  String totalSalePrice;
  String soldToId;
  String soldTo;
  List<EquipmentList> equipmentList;
  List<BidderList> bidderList;
  List<BidderList> playerList;
  List<NoteList> noteList;

  ProjectInformationData(
      {this.projectName,
      this.projectId,
      this.lead,
      this.estimatedBy,
      this.phase,
      this.subPhase,
      this.probability,
      this.goProbability,
      this.createdDate,
      this.value,
      this.equipmentValue,
      this.projectValue,
      this.projectSQFootage,
      this.margin,
      this.description,
      this.totalSalePrice,
      this.soldToId,
      this.soldTo,
      this.equipmentList,
      this.bidderList,
      this.playerList,
      this.noteList});

  ProjectInformationData.fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    projectId = json['projectId'].toString();
    lead = json['lead'].toString();
    phase = json['phase'].toString();
    estimatedBy = json['estimatedBy'].toString();
    subPhase = json['subPhase'].toString();
    probability = json['probability'].toString();
    goProbability = json['goProbability'].toString();
    createdDate = json['createdDate'].toString();
    value = json['value'].toString();
    equipmentValue = json['equipmentValue'].toString();
    projectValue = json['projectValue'].toString();
    projectSQFootage = json['projectSQFootage'].toString();
    margin = json['margin'].toString();
    description = json['description'].toString();
    totalSalePrice = json['totalSalePrice'].toString();
    soldToId = json['soldToId'].toString();
    soldTo = json['soldTo'].toString();
    if (json['equipmentList'] != null) {
      equipmentList = <EquipmentList>[];
      json['equipmentList'].forEach((v) {
        equipmentList.add(new EquipmentList.fromJson(v));
      });
    }
    if (json['bidderList'] != null) {
      bidderList = <BidderList>[];
      json['bidderList'].forEach((v) {
        bidderList.add(new BidderList.fromJson(v));
      });
    }
    if (json['playerList'] != null) {
      playerList = <BidderList>[];
      json['playerList'].forEach((v) {
        playerList.add(new BidderList.fromJson(v));
      });
    }
    if (json['noteList'] != null) {
      noteList = <NoteList>[];
      json['noteList'].forEach((v) {
        noteList.add(new NoteList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectName'] = this.projectName;
    data['projectId'] = this.projectId;
    data['lead'] = this.lead;
    data['estimatedBy'] = this.estimatedBy;
    data['phase'] = this.phase;
    data['subPhase'] = this.subPhase;
    data['probability'] = this.probability;
    data['goProbability'] = this.goProbability;
    data['createdDate'] = this.createdDate;
    data['value'] = this.value;
    data['equipmentValue'] = this.equipmentValue;
    data['projectSQFootage'] = this.projectSQFootage;
    data['margin'] = this.margin;
    data['description'] = this.description;
    data['totalSalePrice'] = this.totalSalePrice;
    data['soldToId'] = this.soldToId;
    data['soldTo'] = this.soldTo;
    if (this.equipmentList != null) {
      data['equipmentList'] =
          this.equipmentList.map((v) => v.toJson()).toList();
    }
    if (this.bidderList != null) {
      data['bidderList'] = this.bidderList.map((v) => v.toJson()).toList();
    }
    if (this.playerList != null) {
      data['playerList'] = this.playerList.map((v) => v.toJson()).toList();
    }
    if (this.noteList != null) {
      data['noteList'] = this.noteList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EquipmentList {
  String manufacture;
  String product;
  String tag;
  String salePrice;

  EquipmentList({this.manufacture, this.product, this.tag, this.salePrice});

  EquipmentList.fromJson(Map<String, dynamic> json) {
    manufacture = json['manufacture'].toString();
    product = json['product'].toString();
    tag = json['tag'].toString();
    salePrice = json['salePrice'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manufacture'] = this.manufacture;
    data['product'] = this.product;
    data['tag'] = this.tag;
    data['salePrice'] = this.salePrice;
    return data;
  }
}

class BidderList {
  String businessType;
  String customerName;
  String contactName;

  BidderList({this.businessType, this.customerName, this.contactName});

  BidderList.fromJson(Map<String, dynamic> json) {
    businessType = json['businessType'].toString();
    customerName = json['customerName'].toString();
    contactName = json['contactName'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessType'] = this.businessType;
    data['customerName'] = this.customerName;
    data['contactName'] = this.contactName;
    return data;
  }
}

class NoteList {
  String noteId;
  String thread;
  String notes;
  String createdDateStr;
  String createdByName;
  String isPrivate;
  String isSemiPrivate;
  String createdById;
  String tabId;
  String tabLabel;

  NoteList(
      {this.noteId,
      this.thread,
      this.notes,
      this.createdDateStr,
      this.createdByName,
      this.isPrivate,
      this.isSemiPrivate,
      this.createdById,
      this.tabId,
      this.tabLabel});

  NoteList.fromJson(Map<String, dynamic> json) {
    noteId = json['noteId'].toString();
    thread = json['thread'].toString();
    notes = json['notes'].toString();
    createdDateStr = json['createdDateStr'].toString();
    createdByName = json['createdByName'].toString();
    isPrivate = json['isPrivate'].toString();
    isSemiPrivate = json['isSemiPrivate'].toString();
    createdById = json['createdById'].toString();
    tabId = json['tabId'].toString();
    tabLabel = json['tabLabel'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteId'] = this.noteId;
    data['thread'] = this.thread;
    data['notes'] = this.notes;
    data['createdDateStr'] = this.createdDateStr;
    data['createdByName'] = this.createdByName;
    data['isPrivate'] = this.isPrivate;
    data['isSemiPrivate'] = this.isSemiPrivate;
    data['createdById'] = this.createdById;
    data['tabId'] = this.tabId;
    data['tabLabel'] = this.tabLabel;
    return data;
  }
}
