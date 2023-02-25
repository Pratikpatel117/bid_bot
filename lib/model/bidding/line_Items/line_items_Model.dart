class LineItemsResponce {
  bool status;
  String message;
  LineItemData data;

  LineItemsResponce({this.status, this.message, this.data});

  LineItemsResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new LineItemData.fromJson(json['data']) : null;
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

class LineItemData {
  String totalSalesPrice;
  List<LineItemsProjectList> projectList;

  LineItemData({this.totalSalesPrice, this.projectList});

  LineItemData.fromJson(Map<String, dynamic> json) {
    totalSalesPrice = json['totalSalesPrice'].toString();
    if (json['projectList'] != null) {
      projectList = <LineItemsProjectList>[];
      json['projectList'].forEach((v) {
        projectList.add(new LineItemsProjectList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSalesPrice'] = this.totalSalesPrice;
    if (this.projectList != null) {
      data['projectList'] = this.projectList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LineItemsProjectList {
  String item;
  String manufacturer;
  String product;
  String qty;
  String tag;
  String salePrice;
  String margin;
  String isDisplayProposal;
  String isShipDateRequierd;
  List<dynamic> equipmentDrawingUrls;
  String equipmentStatus;
  String equipmentStatusId;

  LineItemsProjectList(
      {this.item,
      this.manufacturer,
      this.product,
      this.qty,
      this.tag,
      this.salePrice,
      this.margin,
      this.isDisplayProposal,
      this.isShipDateRequierd,
      this.equipmentDrawingUrls,
      this.equipmentStatus,
      this.equipmentStatusId});

  LineItemsProjectList.fromJson(Map<String, dynamic> json) {
    item = json['item'].toString();
    manufacturer = json['manufacturer'].toString();
    product = json['product'].toString();
    qty = json['qty'].toString();
    tag = json['tag'].toString();
    salePrice = json['salePrice'].toString();
    margin = json['margin'].toString();
    isDisplayProposal = json['isDisplayProposal'].toString();
    isShipDateRequierd = json['isShipDateRequierd'].toString();
    if (json['equipmentDrawingUrls'] != null) {
      equipmentDrawingUrls = <dynamic>[];
      json['equipmentDrawingUrls'].forEach((v) {
        equipmentDrawingUrls.add(v);
      });
    }
    equipmentStatus = json['equipmentStatus'].toString();
    equipmentStatusId = json['equipmentStatusId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['manufacturer'] = this.manufacturer;
    data['product'] = this.product;
    data['qty'] = this.qty;
    data['tag'] = this.tag;
    data['salePrice'] = this.salePrice;
    data['margin'] = this.margin;
    data['isDisplayProposal'] = this.isDisplayProposal;
    data['isShipDateRequierd'] = this.isShipDateRequierd;
    if (this.equipmentDrawingUrls != null) {
      data['equipmentDrawingUrls'] =
          this.equipmentDrawingUrls.map((v) => v.toJson()).toList();
    }
    data['equipmentStatus'] = this.equipmentStatus;
    data['equipmentStatusId'] = this.equipmentStatusId;
    return data;
  }
}

class LineItemsDisplayProposalRequest {
  String isDisplayProposal;
  String employeeId;

  LineItemsDisplayProposalRequest({this.isDisplayProposal, this.employeeId});

  LineItemsDisplayProposalRequest.fromJson(Map<String, dynamic> json) {
    isDisplayProposal = json['isDisplayProposal'];
    employeeId = json['employeeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDisplayProposal'] = this.isDisplayProposal;
    data['employeeId'] = this.employeeId;
    return data;
  }
}
