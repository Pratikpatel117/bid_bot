import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/player/player_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlayerApi {
  Future<PlayerDataResponse> getPlayerData(
      PlayerDataRequest playerRequest) async {
    final String api = "${StringConst.API}m1342611";
    debugPrint("request parameter == ${playerRequest.toJson().toString()}");
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(playerRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("player APi response = ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return PlayerDataResponse.fromJson(jsonDecode(response.body));
      } else {
        return PlayerDataResponse(
            status: false, message: "Invalid Player Data");
      }
    } catch (e) {
      debugPrint("Player Exception  Error = $e");
      throw Exception("Player Exception Error $e");
    }
  }
}
