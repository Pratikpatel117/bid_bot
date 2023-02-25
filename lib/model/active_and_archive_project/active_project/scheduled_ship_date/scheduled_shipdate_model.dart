class ScheduledShipDateModel {
  bool status;
  String message;
  List<ShipDateData> data;

  ScheduledShipDateModel({this.status, this.message, this.data});

  ScheduledShipDateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShipDateData>[];
      json['data'].forEach((v) {
        data.add(new ShipDateData.fromJson(v));
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

class ShipDateData {
  String equipmentId;
  String manufacturer;
  String product;
  String qty;
  String tag;
  String customerReleaseDate;
  String scheduledShipDate;
  String forcastedShipDate;
  String actualShipDate;
  String equipmentStatus;

  ShipDateData(
      {this.equipmentId,
      this.manufacturer,
      this.product,
      this.qty,
      this.tag,
      this.customerReleaseDate,
      this.scheduledShipDate,
      this.forcastedShipDate,
      this.actualShipDate,
      this.equipmentStatus});

  ShipDateData.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipmentId'].toString();
    manufacturer = json['manufacturer'].toString();
    product = json['product'].toString();
    qty = json['qty'].toString();
    tag = json['tag'].toString();
    customerReleaseDate = json['customerReleaseDate'].toString();
    scheduledShipDate = json['scheduledShipDate'].toString();
    forcastedShipDate = json['forcastedShipDate'].toString();
    actualShipDate = json['actualShipDate'].toString();
    equipmentStatus = json['equipmentStatus'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentId'] = this.equipmentId;
    data['manufacturer'] = this.manufacturer;
    data['product'] = this.product;
    data['qty'] = this.qty;
    data['tag'] = this.tag;
    data['customerReleaseDate'] = this.customerReleaseDate;
    data['scheduledShipDate'] = this.scheduledShipDate;
    data['forcastedShipDate'] = this.forcastedShipDate;
    data['actualShipDate'] = this.actualShipDate;
    data['equipmentStatus'] = this.equipmentStatus;
    return data;
  }
}
