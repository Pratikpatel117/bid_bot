class ServiceRequest {
  String projectId;
  String subscriptionId;
  String verticalId;
  String loginEmployeeId;

  ServiceRequest(
      {this.projectId,
      this.subscriptionId,
      this.verticalId,
      this.loginEmployeeId});

  ServiceRequest.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    loginEmployeeId = json['loginEmployeeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['loginEmployeeId'] = this.loginEmployeeId;
    return data;
  }
}

class ServiceRequestResponse {
  bool status;
  String message;
  List<ServiceRequestData> data;

  ServiceRequestResponse({this.status, this.message, this.data});

  ServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ServiceRequestData>[];
      json['data'].forEach((v) {
        data.add(new ServiceRequestData.fromJson(v));
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

class ServiceRequestData {
  String id;
  String subTypeId;
  String createdById;
  String createdBy;
  String createdDate;
  String subType;
  String phaseId;
  String phase;
  List<Equipments> equipments;

  ServiceRequestData(
      {this.id,
      this.subTypeId,
      this.createdById,
      this.createdBy,
      this.createdDate,
      this.subType,
      this.phaseId,
      this.phase,
      this.equipments});

  ServiceRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    subTypeId = json['subTypeId'].toString();
    createdById = json['createdById'].toString();
    createdBy = json['createdBy'].toString();
    createdDate = json['createdDate'].toString();
    subType = json['subType'].toString();
    phaseId = json['phaseId'].toString();
    phase = json['phase'].toString();
    if (json['equipments'] != null) {
      equipments = <Equipments>[];
      json['equipments'].forEach((v) {
        equipments.add(new Equipments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subTypeId'] = this.subTypeId;
    data['createdById'] = this.createdById;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['subType'] = this.subType;
    data['phaseId'] = this.phaseId;
    data['phase'] = this.phase;
    if (this.equipments != null) {
      data['equipments'] = this.equipments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Equipments {
  String equipmentId;
  String manufacturerId;
  String productId;
  String manufacturer;
  String product;
  String tag;
  String isStartUpRequired;
  String warranty;
  String terms;
  String serialNumber;

  Equipments(
      {this.equipmentId,
      this.manufacturerId,
      this.productId,
      this.manufacturer,
      this.product,
      this.tag,
      this.isStartUpRequired,
      this.warranty,
      this.terms,
      this.serialNumber});

  Equipments.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipmentId'].toString();
    manufacturerId = json['manufacturerId'].toString();
    productId = json['productId'].toString();
    manufacturer = json['manufacturer'].toString();
    product = json['product'].toString();
    tag = json['tag'].toString();
    isStartUpRequired = json['isStartUpRequired'].toString();
    warranty = json['warranty'].toString();
    terms = json['terms'].toString();
    serialNumber = json['serialNumber'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentId'] = this.equipmentId;
    data['manufacturerId'] = this.manufacturerId;
    data['productId'] = this.productId;
    data['manufacturer'] = this.manufacturer;
    data['product'] = this.product;
    data['tag'] = this.tag;
    data['isStartUpRequired'] = this.isStartUpRequired;
    data['warranty'] = this.warranty;
    data['terms'] = this.terms;
    data['serialNumber'] = this.serialNumber;
    return data;
  }
}
