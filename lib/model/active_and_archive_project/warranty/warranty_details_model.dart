class WarrantyDetailsModel {
  bool status;
  String message;
  List<WarrantyData> data;

  WarrantyDetailsModel({this.status, this.message, this.data});

  WarrantyDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WarrantyData>[];
      json['data'].forEach((v) {
        data.add(new WarrantyData.fromJson(v));
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

class WarrantyData {
  String equipmentId;
  String manufacturer;
  String product;
  String qty;
  String tag;
  String warrantyTerm;
  String warrantyType;
  String startUpDate;

  WarrantyData(
      {this.equipmentId,
      this.manufacturer,
      this.product,
      this.qty,
      this.tag,
      this.warrantyTerm,
      this.warrantyType,
      this.startUpDate});

  WarrantyData.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipmentId'].toString();
    manufacturer = json['manufacturer'].toString();
    product = json['product'].toString();
    qty = json['qty'].toString();
    tag = json['tag'].toString();
    warrantyTerm = json['warrantyTerm'].toString();
    warrantyType = json['warrantyType'].toString();
    startUpDate = json['startUpDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentId'] = this.equipmentId;
    data['manufacturer'] = this.manufacturer;
    data['product'] = this.product;
    data['qty'] = this.qty;
    data['tag'] = this.tag;
    data['warrantyTerm'] = this.warrantyTerm;
    data['warrantyType'] = this.warrantyType;
    data['startUpDate'] = this.startUpDate;
    return data;
  }
}
