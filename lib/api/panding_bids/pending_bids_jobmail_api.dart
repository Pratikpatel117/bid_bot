import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/pending_bids/pending_bids_model.dart';

class GetJobMessageApi {
  Future<DropDownResponse> getpenddingbidmessage(
      ShowMessageGetJob showMessageGetJob) async {
    final String api = "${StringConst.API}m1344021";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(showMessageGetJob.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("message response = ${response.statusCode}");
    debugPrint("message response = ${response.body}");

    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        DropDownResponse(status: false, message: "Invalid Data");
      }
    } catch (e) {
      debugPrint("Show Message Error = $e");
      throw Exception("Show Message Error == $e");
    }
  }

  Future<DropDownResponse> sendoutthisjobdmessage(
      ShowMessageGetJob showMessageGetJob) async {
    final String api = "${StringConst.API}m1344022";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(showMessageGetJob.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("message response = ${response.statusCode}");
    debugPrint("message response = ${response.body}");

    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        DropDownResponse(status: false, message: "Invalid Data");
      }
    } catch (e) {
      debugPrint("Show Message Error = $e");
      throw Exception("Show Message Error == $e");
    }
  }
}
