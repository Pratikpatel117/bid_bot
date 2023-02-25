import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class ListRequest {
  String contactId;
  String startDate;
  String subscriptionId;
  String verticalId;
  String listLimit;
  String projectName;

  ListRequest(
      {this.listLimit,
      this.contactId,
      this.startDate,
      this.subscriptionId,
      this.verticalId,
      this.projectName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "subscriptionId": "7686051",
      "verticalId": "324",
      "contactId": contactId,
      'startDate': startDate,
      "limit": listLimit,
      "projectName": projectName,
    };
    return map;
  }
}

class BiddingListResponse {
  BiddingListResponse({
    this.status,
    this.message,
    this.data,
  });
  bool status;
  String message;
  List<BiddingData> data;

  BiddingListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => BiddingData.fromJson(e)).toList();
  }

  /* Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }*/
}

class BiddingData extends ExpandableListSection<ProjectList> {
  BiddingData({
    this.bidDate,
    this.projectList,
  });
  String bidDate;
  List<ProjectList> projectList;

  BiddingData.fromJson(Map<String, dynamic> json) {
    bidDate = json['bidDate'].toString();
    projectList = List.from(json['projectList'])
        .map((e) => ProjectList.fromJson(e))
        .toList();
  }

  @override
  List<ProjectList> getItems() {
    return projectList;
  }

  @override
  bool isSectionExpanded() {
    return true;
  }

  @override
  void setSectionExpanded(bool expanded) {}

  /* Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bidDate'] = bidDate;
    _data['projectList'] = projectList.map((e)=>e.toJson()).toList();
    return _data;
  }*/
}

class ProjectList {
  ProjectList({
    this.projectId,
    this.projectName,
    this.bidDate,
    this.qp,
    this.link,
    this.contactId,
    this.isBidder,
    this.bidderId,
    this.isMyCompanyBidder,
    this.isNotBidding,
    this.url,
    this.phase,
    this.subPhase,
  });
  String projectId;
  String projectName;
  String bidDate;
  String qp;
  String link;
  String contactId;
  String isBidder;
  String bidderId;
  String isMyCompanyBidder;
  String isNotBidding;
  String url;
  String phase;
  String subPhase;

  ProjectList.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'].toString();
    projectName = json['projectName'].toString();
    bidDate = json['bidDate'].toString();
    qp = json['qp'].toString();
    link = json['link'].toString();
    contactId = json['contactId'].toString();
    isBidder = json['isBidder'].toString();
    bidderId = json['bidderId'].toString();
    isMyCompanyBidder = json['isMyCompanyBidder'].toString();
    isNotBidding = json['isNotBidding'].toString();
    url = json['url'].toString();
    phase = json['phase'].toString();
    subPhase = json['subPhase'].toString();
  }

  /*Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['projectId'] = projectId;
    _data['projectName'] = projectName;
    _data['bidDate'] = bidDate;
    _data['qp'] = qp;
    _data['link'] = link;
    _data['contactId'] = contactId;
    _data['isBidder'] = isBidder;
    _data['bidderId'] = bidderId;
    _data['isMyCompanyBidder'] = isMyCompanyBidder;
    _data['isNotBidding'] = isNotBidding;
    _data['url'] = url;
    _data['phase'] = phase;
    _data['subPhase'] = subPhase;
    return _data;
  }*/
}
