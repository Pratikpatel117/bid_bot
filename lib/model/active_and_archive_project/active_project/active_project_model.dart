import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class ActiveProjectRequest {
  String employeeId;
  String projectName;
  String start;
  String limit;
  String sortBy;
  String sortOrder;

  ActiveProjectRequest(
      {this.employeeId,
      this.projectName,
      this.start,
      this.limit,
      this.sortBy,
      this.sortOrder});

  ActiveProjectRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    projectName = json['projectName'];
    start = json['start'];
    limit = json['limit'];
    sortBy = json['sortBy'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "employeeId": employeeId,
      "start": start,
      "sortBy": sortBy,
      "sortOrder": sortOrder,
      "projectName": projectName,
      "limit": limit,
    };
    return json;
  }
}

class ActiveProjectResponce {
  bool status;
  String message;
  Data data;

  ActiveProjectResponce({this.status, this.message, this.data});

  ActiveProjectResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data extends ExpandableListSection<ActiveProjectList> {
  int totalCount;
  List<ActiveProjectList> projectList;

  Data({this.totalCount, this.projectList});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['projectList'] != null) {
      projectList = <ActiveProjectList>[];
      json['projectList'].forEach((v) {
        projectList.add(new ActiveProjectList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.projectList != null) {
      data['projectList'] = this.projectList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<ActiveProjectList> getItems() {
    return projectList;
  }

  @override
  bool isSectionExpanded() {
    return true;
  }

  @override
  void setSectionExpanded(bool expanded) {}
}

class ActiveProjectList {
  int projectId;
  String projectName;
  String bidDate;
  int isSecure;
  int submittalCount;
  String approxCloseDate;
  int iomCount;
  int sparePartsCount;
  int serviceRequestCount;
  int soldToId;

  ActiveProjectList(
      {this.projectId,
      this.projectName,
      this.bidDate,
      this.isSecure,
      this.submittalCount,
      this.approxCloseDate,
      this.iomCount,
      this.sparePartsCount,
      this.serviceRequestCount,
      this.soldToId});

  ActiveProjectList.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    projectName = json['projectName'];
    bidDate = json['bidDate'];
    isSecure = json['isSecure'];
    submittalCount = json['submittalCount'];
    approxCloseDate = json['approxCloseDate'];
    iomCount = json['iomCount'];
    sparePartsCount = json['sparePartsCount'];
    serviceRequestCount = json['serviceRequestCount'];
    soldToId = json['soldToId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['bidDate'] = this.bidDate;
    data['isSecure'] = this.isSecure;
    data['submittalCount'] = this.submittalCount;
    data['approxCloseDate'] = this.approxCloseDate;
    data['iomCount'] = this.iomCount;
    data['sparePartsCount'] = this.sparePartsCount;
    data['serviceRequestCount'] = this.serviceRequestCount;
    data['soldToId'] = this.soldToId;
    return data;
  }
}
