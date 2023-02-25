class StartUpDatesModel {
  bool status;
  String message;
  List<StartUpDateData> data;

  StartUpDatesModel({this.status, this.message, this.data});

  StartUpDatesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StartUpDateData>[];
      json['data'].forEach((v) {
        data.add(new StartUpDateData.fromJson(v));
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

class StartUpDateData {
  String equipmentId;
  String manufacturer;
  String product;
  String qty;
  String tag;
  String startUpDate;
  String actualStartupDate;
  String startUpRequired;
  String startupRequestDate;

  StartUpDateData(
      {this.equipmentId,
      this.manufacturer,
      this.product,
      this.qty,
      this.tag,
      this.startUpDate,
      this.actualStartupDate,
      this.startUpRequired,
      this.startupRequestDate});

  StartUpDateData.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipmentId'].toString();
    manufacturer = json['manufacturer'].toString();
    product = json['product'].toString();
    qty = json['qty'].toString();
    tag = json['tag'].toString();
    startUpDate = json['startUpDate'].toString();
    actualStartupDate = json['actualStartupDate'].toString();
    startUpRequired = json['startUpRequired'].toString();
    startupRequestDate = json['startupRequestDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentId'] = this.equipmentId;
    data['manufacturer'] = this.manufacturer;
    data['product'] = this.product;
    data['qty'] = this.qty;
    data['tag'] = this.tag;
    data['startUpDate'] = this.startUpDate;
    data['actualStartupDate'] = this.actualStartupDate;
    data['startUpRequired'] = this.startUpRequired;
    data['startupRequestDate'] = this.startupRequestDate;
    return data;
  }
}

class StartupRequestDate {
  String startupRequestDate;

  StartupRequestDate({this.startupRequestDate});

  StartupRequestDate.fromJson(Map<String, dynamic> json) {
    startupRequestDate = json['startupRequestDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startupRequestDate'] = this.startupRequestDate;
    return data;
  }
}
