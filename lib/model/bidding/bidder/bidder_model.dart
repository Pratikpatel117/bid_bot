class BidderGetResponse {
  bool status;
  String message;
  List<BidderData> data;

  BidderGetResponse({this.status, this.message, this.data});

  BidderGetResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BidderData>[];
      json['data'].forEach((v) {
        data.add(new BidderData.fromJson(v));
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

class BidderData {
  String bidderId;
  String contactId;
  String bidPrice;
  String customerId;
  String customer;
  String contact;
  String days;
  String shortlisted;
  String getthejob;
  String isCurrentBidder;
  String bidDate;
  String customerPhone;
  String contactPhone;
  String isPlayer;
  String leadEmail;
  String contactEmailAddress;
  String status;

  BidderData(
      {this.bidderId,
      this.contactId,
      this.bidPrice,
      this.customerId,
      this.customer,
      this.contact,
      this.days,
      this.shortlisted,
      this.getthejob,
      this.isCurrentBidder,
      this.bidDate,
      this.customerPhone,
      this.contactPhone,
      this.isPlayer,
      this.leadEmail,
      this.contactEmailAddress,
      this.status});

  BidderData.fromJson(Map<String, dynamic> json) {
    bidderId = json['bidderId'].toString();
    contactId = json['contactId'].toString();
    bidPrice = json['bidPrice'].toString();
    customerId = json['customerId'].toString();
    customer = json['customer'].toString();
    contact = json['contact'].toString();
    days = json['days'].toString();
    shortlisted = json['shortlisted'].toString();
    getthejob = json['getthejob'].toString();
    isCurrentBidder = json['isCurrentBidder'].toString();
    bidDate = json['bidDate'].toString();
    customerPhone = json['customerPhone'].toString();
    contactPhone = json['contactPhone'].toString();
    isPlayer = json['isPlayer'].toString();
    leadEmail = json['leadEmail'].toString();
    contactEmailAddress = json['contactEmailAddress'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bidderId'] = this.bidderId;
    data['contactId'] = this.contactId;
    data['bidPrice'] = this.bidPrice;
    data['customerId'] = this.customerId;
    data['customer'] = this.customer;
    data['contact'] = this.contact;
    data['days'] = this.days;
    data['shortlisted'] = this.shortlisted;
    data['getthejob'] = this.getthejob;
    data['isCurrentBidder'] = this.isCurrentBidder;
    data['bidDate'] = this.bidDate;
    data['customerPhone'] = this.customerPhone;
    data['contactPhone'] = this.contactPhone;
    data['isPlayer'] = this.isPlayer;
    data['leadEmail'] = this.leadEmail;
    data['contactEmailAddress'] = this.contactEmailAddress;
    data['status'] = this.status;
    return data;
  }
}
