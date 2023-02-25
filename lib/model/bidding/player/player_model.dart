class PlayerDataRequest {
  String subscriptionId;
  String verticalId;
  String projectId;
  String employeeId;

  PlayerDataRequest(
      {this.subscriptionId, this.verticalId, this.projectId, this.employeeId});

  PlayerDataRequest.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    projectId = json['projectId'];
    employeeId = json['employeeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['projectId'] = this.projectId;
    data['employeeId'] = this.employeeId;
    return data;
  }
}

class PlayerDataResponse {
  bool status;
  String message;
  PlayerData data;

  PlayerDataResponse({this.status, this.message, this.data});

  PlayerDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PlayerData.fromJson(json['data']) : null;
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

class PlayerData {
  List<PlayerList> playerList;

  PlayerData({this.playerList});

  PlayerData.fromJson(Map<String, dynamic> json) {
    if (json['playerList'] != null) {
      playerList = <PlayerList>[];
      json['playerList'].forEach((v) {
        playerList.add(new PlayerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.playerList != null) {
      data['playerList'] = this.playerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerList {
  String playerId;
  String businessTypeId;
  String businessType;
  String disciplineId;
  String discipline;
  String customerId;
  String customer;
  String contactId;
  String contact;
  String contactEmail;
  String playerStatusId;
  String playerStatus;
  String customerLeadInitail;
  String cv;
  String isPrimaryPlayer;
  String pseCredit;
  String relevance;
  String isSar;
  String leadId;
  String leadName;
  String days;
  String customerRevenue;
  String customerEmployeeCount;
  String playerLevel;

  PlayerList(
      {this.playerId,
      this.businessTypeId,
      this.businessType,
      this.disciplineId,
      this.discipline,
      this.customerId,
      this.customer,
      this.contactId,
      this.contact,
      this.contactEmail,
      this.playerStatusId,
      this.playerStatus,
      this.customerLeadInitail,
      this.cv,
      this.isPrimaryPlayer,
      this.pseCredit,
      this.relevance,
      this.isSar,
      this.leadId,
      this.leadName,
      this.days,
      this.customerRevenue,
      this.customerEmployeeCount,
      this.playerLevel});

  PlayerList.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'].toString();
    businessTypeId = json['businessTypeId'].toString();
    businessType = json['businessType'].toString();
    disciplineId = json['disciplineId'].toString();
    discipline = json['discipline'].toString();
    customerId = json['customerId'].toString();
    customer = json['customer'].toString();
    contactEmail = json["contactEmail"].toString();
    contactId = json['contactId'].toString();
    contact = json['contact'].toString();
    playerStatusId = json['playerStatusId'].toString();
    playerStatus = json['playerStatus'].toString();
    customerLeadInitail = json['customerLeadInitail'].toString();
    cv = json['cv'].toString();
    isPrimaryPlayer = json['isPrimaryPlayer'].toString();
    pseCredit = json['pseCredit'].toString();
    relevance = json['relevance'].toString();
    isSar = json['isSar'].toString();
    leadId = json['leadId'].toString();
    leadName = json['leadName'].toString();
    days = json['days'].toString();
    customerRevenue = json['customerRevenue'].toString();
    customerEmployeeCount = json['customerEmployeeCount'].toString();
    playerLevel = json['playerLevel'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['businessTypeId'] = this.businessTypeId;
    data['businessType'] = this.businessType;
    data['disciplineId'] = this.disciplineId;
    data['discipline'] = this.discipline;
    data['customerId'] = this.customerId;
    data['customer'] = this.customer;
    data['contactId'] = this.contactId;
    data['contact'] = this.contact;
    data['playerStatusId'] = this.playerStatusId;
    data['playerStatus'] = this.playerStatus;
    data['customerLeadInitail'] = this.customerLeadInitail;
    data['cv'] = this.cv;
    data['isPrimaryPlayer'] = this.isPrimaryPlayer;
    data['pseCredit'] = this.pseCredit;
    data['relevance'] = this.relevance;
    data['isSar'] = this.isSar;
    data['leadId'] = this.leadId;
    data['leadName'] = this.leadName;
    data['days'] = this.days;
    data['customerRevenue'] = this.customerRevenue;
    data['customerEmployeeCount'] = this.customerEmployeeCount;
    data['playerLevel'] = this.playerLevel;
    return data;
  }
}
