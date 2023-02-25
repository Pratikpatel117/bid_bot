import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/add_me_as_bidder_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMeAsBidderApi {
  Future<AddMeAsBidderResponse> addMeAsBidderTap(
      AddMeAsBidderRequest addBidderRequest) async {
    final String api = "${StringConst.API}m1342058";
    debugPrint(
        "adMeAsBidder Request status code == ${addBidderRequest.toJson().toString()}");
    final response = await http.post(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(addBidderRequest.toJson()),
    );
    debugPrint("adMeAsBidder status code == ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return AddMeAsBidderResponse.fromJson(jsonDecode(response.body));
      } else {
        return AddMeAsBidderResponse(
          status: false,
          message: "",
        );
      }
    } catch (e) {
      debugPrint("add me as bidder exception error == $e");
      throw Exception("exception Error show ==$e");
    }
  }
}
