import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/active_project/scheduled_ship_date/scheduled_shipdate_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheduledShipDateApi {
  Future<ScheduledShipDateModel> getScheduledShipDate(String projectId) async {
    final String api = "${StringConst.API}m1342994/$projectId";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("schedule ship date api response = ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return ScheduledShipDateModel.fromJson(jsonDecode(response.body));
      } else {
        return ScheduledShipDateModel(
            status: false, message: "In Valid Scheduled data", data: null);
      }
    } catch (e) {
      debugPrint("Scheduled data exception   = $e");
      throw Exception("Scheduled data exception  === $e");
    }
  }
}
