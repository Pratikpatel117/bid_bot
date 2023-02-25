class ShareSubmittalsRequest {
  String employeeId;
  String submittalId;
  List<Recipient> recipient;

  ShareSubmittalsRequest({this.employeeId, this.submittalId, this.recipient});

  ShareSubmittalsRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    submittalId = json['submittalId'];
    if (json['recipient'] != null) {
      recipient = <Recipient>[];
      json['recipient'].forEach((v) {
        recipient.add(new Recipient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['submittalId'] = this.submittalId;
    if (this.recipient != null) {
      data['recipient'] = this.recipient.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recipient {
  String leadId;
  String supportId;
  String managementId;
  List<String> bidders;
  List<String> players;
  List<String> employees;

  Recipient(
      {this.leadId,
      this.supportId,
      this.managementId,
      this.bidders,
      this.players,
      this.employees});

  Recipient.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    supportId = json['supportId'];
    managementId = json['managementId'];
    bidders = json['bidders'].cast<String>();
    players = json['players'].cast<String>();
    employees = json['employees'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['supportId'] = this.supportId;
    data['managementId'] = this.managementId;
    data['bidders'] = this.bidders;
    data['players'] = this.players;
    data['employees'] = this.employees;
    return data;
  }
}
