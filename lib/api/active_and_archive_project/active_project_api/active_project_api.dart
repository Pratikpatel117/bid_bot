import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/active_and_archive_project/active_project/active_project_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../const/widget.dart';

class ActiveProjectApi {
  final String api = '${StringConst.API}m1343208';

  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return DateFormat('mm/dd/yyyy').format(DateTime.now());
    }
    return object;
  }

  Future<ActiveProjectResponce> getBidListApiData(
      ActiveProjectRequest activeProjectRequest) async {
    debugPrint(
        "Active Project Data Request Parameter === ${activeProjectRequest.toJson()}");
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(activeProjectRequest.toJson(),
          toEncodable: myDateSerializer),
      headers: GlobalValues.apiHeaders,
    );
    try {
      if (response.statusCode == 200) {
        debugPrint("Active Project Response === ${response.statusCode}");

        return ActiveProjectResponce.fromJson(jsonDecode(response.body));
      } else {
        debugPrint("Active Project data Connection Fail === ${response.body}");
        return ActiveProjectResponce(
            status: false, message: 'BidList Data Are Not Found !');
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }
}
