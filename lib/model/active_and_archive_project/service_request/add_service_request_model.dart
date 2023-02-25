class LineItemsEquipment {
  bool status;
  String message;
  List<LineItemsEquipmentData> data;

  LineItemsEquipment({this.status, this.message, this.data});

  LineItemsEquipment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LineItemsEquipmentData>[];
      json['data'].forEach((v) {
        data.add(new LineItemsEquipmentData.fromJson(v));
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

class LineItemsEquipmentData {
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
  bool isDone = false;

  LineItemsEquipmentData(
      {this.equipmentId,
      this.manufacturerId,
      this.productId,
      this.manufacturer,
      this.product,
      this.tag,
      this.isStartUpRequired,
      this.warranty,
      this.terms,
      this.serialNumber,
      this.isDone});

  LineItemsEquipmentData.fromJson(Map<String, dynamic> json) {
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
    isDone = false;
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

  void toggleDone() {
    isDone = !isDone;
  }

  void setSerialNo(serialNo) {
    serialNumber = serialNo;
  }
}

class Submitservicerequest {
  String loginEmployeeId;
  String projectId;
  String subscriptionId;
  String verticalId;
  String customerId;
  String contactId;
  String subTypeId;
  String description;
  String name;
  String phone;
  String email;
  List<Equipments> equipments;

  Submitservicerequest(
      {this.loginEmployeeId,
      this.projectId,
      this.subscriptionId,
      this.verticalId,
      this.customerId,
      this.contactId,
      this.subTypeId,
      this.description,
      this.name,
      this.phone,
      this.email,
      this.equipments});

  Submitservicerequest.fromJson(Map<String, dynamic> json) {
    loginEmployeeId = json['loginEmployeeId'].toString();
    projectId = json['projectId'].toString();
    subscriptionId = json['subscriptionId'].toString();
    verticalId = json['verticalId'].toString();
    customerId = json['customerId'].toString();
    contactId = json['contactId'].toString();
    subTypeId = json['subTypeId'].toString();
    description = json['description'].toString();
    name = json['name'].toString();
    phone = json['phone'].toString();
    email = json['email'].toString();
    if (json['equipments'] != null) {
      equipments = <Equipments>[];
      json['equipments'].forEach((v) {
        equipments.add(new Equipments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loginEmployeeId'] = this.loginEmployeeId;
    data['projectId'] = this.projectId;
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['customerId'] = this.customerId;
    data['contactId'] = this.contactId;
    data['subTypeId'] = this.subTypeId;
    data['description'] = this.description;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    if (this.equipments != null) {
      data['equipments'] = this.equipments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Equipments {
  String equipmentId;
  String serialNumber;

  Equipments({this.equipmentId, this.serialNumber});

  Equipments.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipmentId'];
    serialNumber = json['serialNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentId'] = this.equipmentId;
    data['serialNumber'] = this.serialNumber;
    return data;
  }
}
