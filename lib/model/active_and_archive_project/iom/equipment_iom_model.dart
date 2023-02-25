class EquipmentIOMModel {
  bool status;
  String message;
  List<EquipmentIOMData> data;

  EquipmentIOMModel({this.status, this.message, this.data});

  EquipmentIOMModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EquipmentIOMData>[];
      json['data'].forEach((v) {
        data.add(new EquipmentIOMData.fromJson(v));
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

class EquipmentIOMData {
  String submittalId;
  String tag;
  String fileName;
  String fileExtention;
  String pdfUrl;
  String manufacture;
  String product;
  String createdDate;

  EquipmentIOMData(
      {this.submittalId,
      this.tag,
      this.fileName,
      this.fileExtention,
      this.pdfUrl,
      this.manufacture,
      this.product,
      this.createdDate});

  EquipmentIOMData.fromJson(Map<String, dynamic> json) {
    submittalId = json['submittalId'].toString();
    tag = json['tag'].toString();
    fileName = json['fileName'].toString();
    fileExtention = json['fileExtention'].toString();
    pdfUrl = json['pdfUrl'].toString();
    manufacture = json['manufacture'].toString();
    product = json['product'].toString();
    createdDate = json['createdDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submittalId'] = this.submittalId;
    data['tag'] = this.tag;
    data['fileName'] = this.fileName;
    data['fileExtention'] = this.fileExtention;
    data['pdfUrl'] = this.pdfUrl;
    data['manufacture'] = this.manufacture;
    data['product'] = this.product;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
