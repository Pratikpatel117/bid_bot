import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class BidListRequest {
  String employeeId;
  String startDate;
  String endDate;
  String projectName;
  String limit;

  BidListRequest(
      {this.employeeId,
      this.projectName,
      this.endDate,
      this.limit,
      this.startDate});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "employeeId": employeeId,
      "startDate": startDate,
      "endDate": "",
      "projectName": projectName,
      "limit": limit,
    };
    return json;
  }
}

class BidListResponse {
  bool status;
  String message;
  List<BidListData> data;

  BidListResponse({this.status, this.message, this.data});

  BidListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BidListData>[];
      json['data'].forEach((v) {
        data.add(new BidListData.fromJson(v));
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

class BidListData extends ExpandableListSection<BidProjectList> {
  String bidDate;
  List<BidProjectList> projectList;

  BidListData({this.bidDate, this.projectList});

  BidListData.fromJson(Map<String, dynamic> json) {
    bidDate = json['bidDate'];
    if (json['projectList'] != null) {
      projectList = <BidProjectList>[];
      json['projectList'].forEach((v) {
        projectList.add(new BidProjectList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bidDate'] = this.bidDate;
    if (this.projectList != null) {
      data['projectList'] = this.projectList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<BidProjectList> getItems() {
    return projectList;
  }

  @override
  bool isSectionExpanded() {
    return true;
  }

  @override
  void setSectionExpanded(bool expanded) {}
}

class BidProjectList {
  String projectId;
  String projectName;
  String bidDate;
  String url;

  BidProjectList({this.projectId, this.projectName, this.bidDate, this.url});

  BidProjectList.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'].toString();
    projectName = json['projectName'].toString();
    bidDate = json['bidDate'].toString();
    url = json['url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['bidDate'] = this.bidDate;
    data['url'] = this.url;
    return data;
  }
}

/*{
	"employeeId": "49148",
	"startDate": "2/12/2021",
	"endDate": "14/1/2022",
	"projectName": "Test project - Bhatt",
	"limit": "10"
}*/
/*class BidListResponce {
  bool status;
  String message;
  List<Data> data;

  BidListResponce({this.status, this.message, this.data});

  BidListResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String bidDate;
  List<ProjectList> projectList;

  Data({this.bidDate, this.projectList});

  Data.fromJson(Map<String, dynamic> json) {
    bidDate = json['bidDate'];
    if (json['projectList'] != null) {
      projectList = new List<ProjectList>();
      json['projectList'].forEach((v) {
        projectList.add(new ProjectList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bidDate'] = this.bidDate;
    if (this.projectList != null) {
      data['projectList'] = this.projectList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectList {
  int projectId;
  String projectName;
  String bidDate;
  String url;

  ProjectList({this.projectId, this.projectName, this.bidDate, this.url});

  ProjectList.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    projectName = json['projectName'];
    bidDate = json['bidDate'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['bidDate'] = this.bidDate;
    data['url'] = this.url;
    return data;
  }
}
*/
