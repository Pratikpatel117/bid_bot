import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/bid_inquiry_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateNewProjectApi {
  Future<BidInquiryResponse> createNewProject(
      CreateNewProjectRequest createNewProjectRequest) async {
    final String api = "${StringConst.API}m1345627";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(createNewProjectRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("status code of new project == ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return BidInquiryResponse.fromJson(jsonDecode(response.body));
      } else {
        return BidInquiryResponse();
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }

  Future<DropDownResponse> getCreateProjectApi(String getApi) async {
    final String api =
        "${StringConst.API}$getApi/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );

    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        return DropDownResponse(status: false, message: "Phase Id Didn't Get");
      }
    } catch (e) {
      throw Exception("LeadId Exception Throw -- $e");
    }
  }
}
/*

  Future getLeadId() async {
    final String api =
        "${StringConst.API}m1345633/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}";
    final responce = await http.get(
      Uri.parse(api),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Basic $token",
        "Content-Type": "application/json",
      },
    );
    debugPrint(
        " Project Information Status code = ${responce.statusCode} ** $api");
    try {
      if (responce.statusCode == 200) {
        return LeadResponce.fromJson(jsonDecode(responce.body));
      } else {
        return LeadResponce(status: false, message: "Lead Id Didn't Get");
      }
    } catch (e) {
      throw Exception("LeadId Exception Throw -- $e");
    }
  }

  Future getPhaseId() async {
    final String api =
        "${StringConst.API}m1345632/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}";
    final responce = await http.get(
      Uri.parse(api),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Basic $token",
        "Content-Type": "application/json",
      },
    );

    try {
      if (responce.statusCode == 200) {
        return LeadResponce.fromJson(jsonDecode(responce.body));
      } else {
        return LeadResponce(status: false, message: "Phase Id Didn't Get");
      }
    } catch (e) {
      throw Exception("LeadId Exception Throw -- $e");
    }
  }
*/
