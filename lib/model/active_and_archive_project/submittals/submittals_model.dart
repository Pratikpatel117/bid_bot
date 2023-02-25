// To parse this JSON data, do
//
//     final submittalsModel = submittalsModelFromJson(jsonString);

import 'dart:convert';

SubmittalsModel submittalsModelFromJson(String str) =>
    SubmittalsModel.fromJson(json.decode(str));

String submittalsModelToJson(SubmittalsModel data) =>
    json.encode(data.toJson());

class SubmittalsModel {
  bool status;
  String message;
  List<SubmittalsData> data;

  SubmittalsModel({this.status, this.message, this.data});

  SubmittalsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubmittalsData>[];
      json['data'].forEach((v) {
        data.add(new SubmittalsData.fromJson(v));
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

class SubmittalsData {
  String submittalId;
  String projectEquipment;
  String submittedDate;
  String submittalStatus;
  String status;
  String approvedDate;
  String equipmentStatus;
  String wantedDate;
  String tag;
  String qty;
  String leadTime;
  String requiredReleaseDate;
  String letterColor;
  String backGroundColor;
  String preparedBy;
  String equipmentDocType;
  String document;
  String fileName;
  String fileExtention;
  String pdfUrl;
  String equipmentId;
  String minWantedDate;

  SubmittalsData(
      {this.submittalId,
      this.projectEquipment,
      this.submittedDate,
      this.submittalStatus,
      this.status,
      this.approvedDate,
      this.equipmentStatus,
      this.wantedDate,
      this.tag,
      this.qty,
      this.leadTime,
      this.requiredReleaseDate,
      this.letterColor,
      this.backGroundColor,
      this.preparedBy,
      this.equipmentDocType,
      this.document,
      this.fileName,
      this.fileExtention,
      this.pdfUrl,
      this.equipmentId,
      this.minWantedDate});

  SubmittalsData.fromJson(Map<String, dynamic> json) {
    submittalId = json['submittalId'].toString();
    projectEquipment = json['projectEquipment'].toString();
    submittedDate = json['submittedDate'].toString();
    submittalStatus = json['submittalStatus'].toString();
    status = json['status'].toString();
    approvedDate = json['approvedDate'].toString();
    equipmentStatus = json['equipmentStatus'].toString();
    wantedDate = json['wantedDate'].toString();
    tag = json['tag'].toString();
    qty = json['qty'].toString();
    leadTime = json['leadTime'].toString();
    requiredReleaseDate = json['requiredReleaseDate'].toString();
    letterColor = json['letterColor'].toString();
    backGroundColor = json['backGroundColor'].toString();
    preparedBy = json['preparedBy'].toString();
    equipmentDocType = json['equipmentDocType'].toString();
    document = json['document'].toString();
    fileName = json['fileName'].toString();
    fileExtention = json['fileExtention'].toString();
    pdfUrl = json['pdfUrl'].toString();
    equipmentId = json['equipmentId'].toString();
    minWantedDate = json['minWantedDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submittalId'] = this.submittalId;
    data['projectEquipment'] = this.projectEquipment;
    data['submittedDate'] = this.submittedDate;
    data['submittalStatus'] = this.submittalStatus;
    data['status'] = this.status;
    data['approvedDate'] = this.approvedDate;
    data['equipmentStatus'] = this.equipmentStatus;
    data['wantedDate'] = this.wantedDate;
    data['tag'] = this.tag;
    data['qty'] = this.qty;
    data['leadTime'] = this.leadTime;
    data['requiredReleaseDate'] = this.requiredReleaseDate;
    data['letterColor'] = this.letterColor;
    data['backGroundColor'] = this.backGroundColor;
    data['preparedBy'] = this.preparedBy;
    data['equipmentDocType'] = this.equipmentDocType;
    data['document'] = this.document;
    data['fileName'] = this.fileName;
    data['fileExtention'] = this.fileExtention;
    data['pdfUrl'] = this.pdfUrl;
    data['equipmentId'] = this.equipmentId;
    data['minWantedDate'] = this.minWantedDate;
    return data;
  }
}
