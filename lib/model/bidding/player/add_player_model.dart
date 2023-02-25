class AddPlayerRequest {
  String id;
  String employeeId;
  String customerId;
  String projectId;
  String cv;
  String contactId;
  String businessTypeId;
  String isBidder;
  String playerStatusId;
  String businessTypeDisciplineId;

  AddPlayerRequest(
      {this.id,
      this.employeeId,
      this.customerId,
      this.projectId,
      this.cv,
      this.contactId,
      this.businessTypeId,
      this.isBidder,
      this.playerStatusId,
      this.businessTypeDisciplineId});

  AddPlayerRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    employeeId = json['employeeId'].toString();
    customerId = json['customerId'].toString();
    projectId = json['projectId'].toString();
    cv = json['cv'].toString();
    contactId = json['contactId'].toString();
    businessTypeId = json['businessTypeId'].toString();
    isBidder = json['isBidder'].toString();
    playerStatusId = json['playerStatusId'].toString();
    businessTypeDisciplineId = json['businessTypeDisciplineId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['customerId'] = this.customerId;
    data['projectId'] = this.projectId;
    data['cv'] = this.cv;
    data['contactId'] = this.contactId;
    data['businessTypeId'] = this.businessTypeId;
    data['isBidder'] = this.isBidder;
    data['playerStatusId'] = this.playerStatusId;
    data['businessTypeDisciplineId'] = this.businessTypeDisciplineId;
    return data;
  }
}

class AddPlayerResponce {
  bool status;
  String message;
  AddPlayerData data;

  AddPlayerResponce({this.status, this.message, this.data});

  AddPlayerResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new AddPlayerData.fromJson(json['data']) : null;
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

class AddPlayerData {
  String playerId;

  AddPlayerData({this.playerId});

  AddPlayerData.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    return data;
  }
}
