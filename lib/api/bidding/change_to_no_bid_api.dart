import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/add_me_as_bidder_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangeToNoBidApi {
  Future<RemoveBids> ChangeToNoBid(String bidderId) async {
    final String api = "${StringConst.API}m1342292/$bidderId";
    final responce = await http.delete(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("bid remove status code == ${responce.statusCode}");

    try {
      if (responce.statusCode == 200) {
        return RemoveBids.fromJson(jsonDecode(responce.body));
      } else {
        RemoveBids(status: false, message: "didn't  remove Bid");
      }
    } catch (e) {
      debugPrint("Remove Bids Error == $e");
      throw Exception("Remove Bids Error == $e");
    }
  }
}
