// ignore_for_file: missing_return

import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/manage_bid_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ManageBidInquiryApi {
  Future<ManageBidRequests> manageBidInquiry() async {
    final String api =
        "${StringConst.API}m1345892/${GlobalValues.loginEmployee.employeeId}/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("ManageBidResponse StatusCode === ${response.statusCode}");
    // debugPrint("ManageBidResponse body === ${response.body}");

    try {
      if (response.statusCode == 200) {
        return ManageBidRequests.fromJson(jsonDecode(response.body));
      } else {
        ManageBidRequests(
            status: false,
            message: "ManageBidResponse Didn't Found ",
            data: []);
      }
    } catch (e) {
      debugPrint("ManageBidResponse Exception Error  === $e");
      Exception('Server Error $e');
    }
  }
}
