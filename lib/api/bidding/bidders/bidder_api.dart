// ignore_for_file: missing_return

import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bidder/bidder_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BidderApi {
  Future<BidderGetResponse> getBidderApi(String projectId) async {
    final String api =
        "${StringConst.API}m1342689/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}/${GlobalValues.loginEmployee.employeeId}/$projectId";
    http.Response response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("BidderGetResponse StatusCode === ${response.statusCode}");
    // debugPrint("BidderGetResponse StatusCode === ${response.body}");
    debugPrint("BidderGetResponse StatusCode === $api");
    try {
      if (response.statusCode == 200) {
        return BidderGetResponse.fromJson(jsonDecode(response.body));
      } else {
        return BidderGetResponse(status: false, message: "Invalid Bidder Data");
      }
    } catch (e) {
      debugPrint("BidderGetResponse Exception Error  === $e");
      Exception('Server Error $e');
    }
  }
}
