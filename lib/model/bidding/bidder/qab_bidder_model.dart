class QABBidderGetResponse {
  bool status;
  String message;
  List<QABData> data;

  QABBidderGetResponse({this.status, this.message, this.data});

  QABBidderGetResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <QABData>[];
      json['data'].forEach((v) {
        data.add(new QABData.fromJson(v));
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

class QABData {
  String customerId;
  String customerName;
  String bidderCount;

  QABData({this.customerId, this.customerName, this.bidderCount});

  QABData.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'].toString();
    customerName = json['customerName'].toString();
    bidderCount = json['bidderCount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['bidderCount'] = this.bidderCount;
    return data;
  }
}

class QABGetContactData {
  bool status;
  String message;
  List<QABContactData> data;

  QABGetContactData({this.status, this.message, this.data});

  QABGetContactData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <QABContactData>[];
      json['data'].forEach((v) {
        data.add(new QABContactData.fromJson(v));
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

class QABContactData {
  String customerContactId;
  String customerContactName;
  String email;
  String title;
  String phone;
  bool isDone = false;

  QABContactData({
    this.customerContactId,
    this.customerContactName,
    this.email,
    this.title,
    this.phone,
    this.isDone,
  });

  QABContactData.fromJson(Map<String, dynamic> json) {
    customerContactId = json['customerContactId'].toString();
    customerContactName = json['customerContactName'].toString();
    email = json['email'].toString();
    title = json['title'].toString();
    phone = json['phone'].toString();
    isDone = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerContactId'] = this.customerContactId;
    data['customerContactName'] = this.customerContactName;
    data['email'] = this.email;
    data['title'] = this.title;
    data['phone'] = this.phone;
    return data;
  }

  void toggleDone() {
    isDone = !isDone;
  }
}

class QABSubmitData {
  List<String> contactIds;
  String projectId;
  String customerId;
  String employeeId;

  QABSubmitData(
      {this.contactIds, this.projectId, this.customerId, this.employeeId});

  QABSubmitData.fromJson(Map<String, dynamic> json) {
    contactIds = json['contactIds'].cast<String>();
    projectId = json['projectId'].toString();
    customerId = json['customerId'].toString();
    employeeId = json['employeeId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactIds'] = this.contactIds;
    data['projectId'] = this.projectId;
    data['customerId'] = this.customerId;
    data['employeeId'] = this.employeeId;
    return data;
  }
}
