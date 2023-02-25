class TabRequestSubmittals {
  String subscriptionId;
  String verticalId;
  String sphereTypeId;

  TabRequestSubmittals(
      {this.subscriptionId, this.verticalId, this.sphereTypeId});

  TabRequestSubmittals.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    sphereTypeId = json['sphereTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['sphereTypeId'] = this.sphereTypeId;
    return data;
  }
}

class UploadSubmittalsRequest {
  String submittalStatusId;
  String employeeId;
  String submittalId;
  String equipmentId;
  String document;
  String fileSize;
  String fileName;
  String city;
  String zip;
  String countryId;
  String stateId;
  String address;
  String markShipment;
  String contactId;
  String wantedShipDate;
  String companyId;
  String firstName;
  String lastName;
  String email;
  String phone;
  UploadSubmittalsRequest({
    this.submittalStatusId,
    this.employeeId,
    this.submittalId,
    this.equipmentId,
    this.document,
    this.fileSize,
    this.fileName,
    this.city,
    this.zip,
    this.countryId,
    this.stateId,
    this.address,
    this.markShipment,
    this.contactId,
    this.wantedShipDate,
    this.companyId,
    this.email,
    this.phone,
    this.lastName,
    this.firstName,
  });

  UploadSubmittalsRequest.fromJson(Map<String, dynamic> json) {
    submittalStatusId = json['submittalStatusId'].toString();
    employeeId = json['employeeId'].toString();
    submittalId = json['submittalId'].toString();
    equipmentId = json['equipmentId'].toString();
    document = json['document'].toString();
    fileSize = json['fileSize'].toString();
    fileName = json['fileName'].toString();
    city = json['city'].toString();
    zip = json['zip'].toString();
    countryId = json['countryId'].toString();
    stateId = json['stateId'].toString();
    address = json['address'].toString();
    markShipment = json['markShipment'].toString();
    contactId = json['contactId'].toString();
    wantedShipDate = json['wantedShipDate'].toString();
    companyId = json['companyId'].toString();
    firstName = json["firstName"].toString();
    lastName = json['lastName'].toString();
    email = json["email"].toString();
    phone = json["phone"].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submittalStatusId'] = this.submittalStatusId;
    data['employeeId'] = this.employeeId;
    data['submittalId'] = this.submittalId;
    data['equipmentId'] = this.equipmentId;
    data['document'] = this.document;
    data['fileSize'] = this.fileSize;
    data['fileName'] = this.fileName;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['countryId'] = this.countryId;
    data['stateId'] = this.stateId;
    data['address'] = this.address;
    data['markShipment'] = this.markShipment;
    data['contactId'] = this.contactId;
    data['wantedShipDate'] = this.wantedShipDate;
    data['companyId'] = this.companyId;
    data["firstName"] = this.firstName;
    data["lastName"] = this.lastName;
    data["email"] = this.email;
    data["phone"] = this.phone;
    return data;
  }
}

class SubmittalsDetails {
  bool status;
  String message;
  SubmittalDetailsData data;

  SubmittalsDetails({this.status, this.message, this.data});

  SubmittalsDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new SubmittalDetailsData.fromJson(json['data'])
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

class SubmittalDetailsData {
  String submittalId;
  String submittalStatusId;
  String co;
  String countryId;
  String stateId;
  String city;
  String address;
  String zip;
  String wantedDate;
  String customerId;
  String contactId;
  String contactName;
  String phone;
  String email;
  String markShipment;
  String submittalUrl;

  SubmittalDetailsData(
      {this.submittalId,
      this.submittalStatusId,
      this.co,
      this.countryId,
      this.stateId,
      this.city,
      this.address,
      this.zip,
      this.wantedDate,
      this.customerId,
      this.contactId,
      this.contactName,
      this.phone,
      this.email,
      this.markShipment,
      this.submittalUrl});

  SubmittalDetailsData.fromJson(Map<String, dynamic> json) {
    submittalId = json['submittalId'].toString();
    submittalStatusId = json['submittalStatusId'].toString();
    co = json['co'].toString();
    countryId = json['countryId'].toString();
    stateId = json['stateId'].toString();
    city = json['city'].toString();
    address = json['address'].toString();
    zip = json['zip'].toString();
    wantedDate = json['wantedDate'].toString();
    customerId = json['customerId'].toString();
    contactId = json['contactId'].toString();
    contactName = json['contactName'].toString();
    phone = json['phone'].toString();
    email = json['email'].toString();
    markShipment = json['markShipment'].toString();
    submittalUrl = json['submittalUrl'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submittalId'] = this.submittalId;
    data['submittalStatusId'] = this.submittalStatusId;
    data['co'] = this.co;
    data['countryId'] = this.countryId;
    data['stateId'] = this.stateId;
    data['city'] = this.city;
    data['address'] = this.address;
    data['zip'] = this.zip;
    data['wantedDate'] = this.wantedDate;
    data['customerId'] = this.customerId;
    data['contactId'] = this.contactId;
    data['contactName'] = this.contactName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['markShipment'] = this.markShipment;
    data['submittalUrl'] = this.submittalUrl;
    return data;
  }
}
