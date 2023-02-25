class GetAppIntroData {
  bool status;
  String message;
  List<IntroData> idata;

  GetAppIntroData({this.status, this.message, this.idata});

  GetAppIntroData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'].toString();
    if (json['data'] != null) {
      idata = <IntroData>[];
      json['data'].forEach((v) {
        idata.add(new IntroData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.idata != null) {
      data['data'] = this.idata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IntroData {
  String appTourGuideId;
  String description;
  String tabTypeId;
  String tabType;

  IntroData(
      {this.appTourGuideId, this.description, this.tabTypeId, this.tabType});

  IntroData.fromJson(Map<String, dynamic> json) {
    appTourGuideId = json['appTourGuideId'].toString();
    description = json['description'].toString();
    tabTypeId = json['tabTypeId'].toString();
    tabType = json['tabType'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appTourGuideId'] = this.appTourGuideId;
    data['description'] = this.description;
    data['tabTypeId'] = this.tabTypeId;
    data['tabType'] = this.tabType;
    return data;
  }
}
