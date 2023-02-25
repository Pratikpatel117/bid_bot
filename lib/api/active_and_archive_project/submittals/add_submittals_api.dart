// ignore_for_file: missing_return

import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/add_submittals_model.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/bidder/add_bidder_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddSubmittalsApi {
  Future<DropDownResponse> getTabListSubmittals(
      TabRequestSubmittals tabRequestSubmittals) async {
    final String api = "${StringConst.API}m1346066";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(tabRequestSubmittals.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("tab add submittals response = ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        DropDownResponse(status: false, message: "Invalid tab data");
      }
    } catch (e) {
      debugPrint("tab add Submittals Error = $e");
      throw Exception("Tab List Submittals Error == $e");
    }
  }

  Future<UploadResponse> uploadSubmittals(
      UploadSubmittalsRequest submittalsRequest) async {
    final String api = "${StringConst.API}m1346078";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(submittalsRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("Upload Submittals StatusCode === ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return UploadResponse.fromJson(jsonDecode(response.body));
      } else {
        return UploadResponse(status: false, message: "Invalid AddBidder Data");
      }
    } catch (e) {
      debugPrint("Upload Submittals Error === $e");
      throw Exception("Exception error == $e");
    }
  }

  Future<SubmittalsDetails> getSubmittalsDetails(String submittalsId) async {
    final String api =
        "${StringConst.API}m1348193/${GlobalValues.loginEmployee.employeeId}/$submittalsId";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("Submittals Details response = ${response.statusCode}");
    debugPrint("Submittals Details response = ${response.body}");

    try {
      if (response.statusCode == 200) {
        return SubmittalsDetails.fromJson(jsonDecode(response.body));
      } else {
        SubmittalsDetails(status: false, message: "Invalid Submittal data");
      }
    } catch (e) {
      debugPrint("tab add Submittals Error = $e");
      throw Exception("Tab List Submittals Error == $e");
    }
  }
}
