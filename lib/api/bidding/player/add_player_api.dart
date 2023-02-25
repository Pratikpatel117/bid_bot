import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/player/add_player_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPlayerApi {
  Future<AddPlayerResponce> addPlayerApi(AddPlayerRequest playerRequest) async {
    final String api = "${StringConst.API}m1342783";
    final response = await http.post(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(playerRequest.toJson()),
    );
    debugPrint("Add Player StatusCode == ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return AddPlayerResponce.fromJson(jsonDecode(response.body));
      } else {
        return AddPlayerResponce(
            status: false, message: "Invalid Add Player Data");
      }
    } catch (e) {
      throw Exception("Add Player Exception Error === $e");
    }
  }
}
