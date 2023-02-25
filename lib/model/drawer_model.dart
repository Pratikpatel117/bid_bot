class DrawerRequest {
  String employeeId;
  String sphereUrl;

  DrawerRequest({this.employeeId, this.sphereUrl});

  DrawerRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    sphereUrl = json['sphereUrl'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "employeeId": employeeId,
      "sphereUrl": "bidlist-app.htm",
    };
    return map;
  }
}

class DrawerResponse {
  bool status;
  String message;
  List<TabData> data;

  DrawerResponse({this.status, this.message, this.data});

  DrawerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TabData>[];
      json['data'].forEach((v) {
        data.add(new TabData.fromJson(v));
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

class TabData {
  int tabId;
  String tabName;
  String tabCode;
  String tabLable;
  String tabUrl;
  int tabGroupId;
  String tabGroup;
  int tabSubGroupId;
  String tabSubGroup;
  int order;
  String tabDescription;
  String tabTypeName;
  String tabTypeUrl;
  int isHeadsUpDisplay;
  int isIrep;
  int isGold;
  int isSilver;
  int isPlatinum;
  int isDigitalDaily;
  int isAdd;
  int isEdit;
  int isDelete;
  int isExport;

  TabData(
      {this.tabId,
      this.tabName,
      this.tabCode,
      this.tabLable,
      this.tabUrl,
      this.tabGroupId,
      this.tabGroup,
      this.tabSubGroupId,
      this.tabSubGroup,
      this.order,
      this.tabDescription,
      this.tabTypeName,
      this.tabTypeUrl,
      this.isHeadsUpDisplay,
      this.isIrep,
      this.isGold,
      this.isSilver,
      this.isPlatinum,
      this.isDigitalDaily,
      this.isAdd,
      this.isEdit,
      this.isDelete,
      this.isExport});

  TabData.fromJson(Map<String, dynamic> json) {
    tabId = json['tabId'];
    tabName = json['tabName'];
    tabCode = json['tabCode'];
    tabLable = json['tabLable'];
    tabUrl = json['tabUrl'];
    tabGroupId = json['tabGroupId'];
    tabGroup = json['tabGroup'];
    tabSubGroupId = json['tabSubGroupId'];
    tabSubGroup = json['tabSubGroup'];
    order = json['order'];
    tabDescription = json['tabDescription'];
    tabTypeName = json['tabTypeName'];
    tabTypeUrl = json['tabTypeUrl'];
    isHeadsUpDisplay = json['isHeadsUpDisplay'];
    isIrep = json['isIrep'];
    isGold = json['isGold'];
    isSilver = json['isSilver'];
    isPlatinum = json['isPlatinum'];
    isDigitalDaily = json['isDigitalDaily'];
    isAdd = json['isAdd'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
    isExport = json['isExport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tabId'] = this.tabId;
    data['tabName'] = this.tabName;
    data['tabCode'] = this.tabCode;
    data['tabLable'] = this.tabLable;
    data['tabUrl'] = this.tabUrl;
    data['tabGroupId'] = this.tabGroupId;
    data['tabGroup'] = this.tabGroup;
    data['tabSubGroupId'] = this.tabSubGroupId;
    data['tabSubGroup'] = this.tabSubGroup;
    data['order'] = this.order;
    data['tabDescription'] = this.tabDescription;
    data['tabTypeName'] = this.tabTypeName;
    data['tabTypeUrl'] = this.tabTypeUrl;
    data['isHeadsUpDisplay'] = this.isHeadsUpDisplay;
    data['isIrep'] = this.isIrep;
    data['isGold'] = this.isGold;
    data['isSilver'] = this.isSilver;
    data['isPlatinum'] = this.isPlatinum;
    data['isDigitalDaily'] = this.isDigitalDaily;
    data['isAdd'] = this.isAdd;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
    data['isExport'] = this.isExport;
    return data;
  }
}
