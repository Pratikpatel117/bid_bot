import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/share_submittals_model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShareSubmittalsApi {
  Future<UpdateApiResponse> shareSubmittals(
      ShareSubmittalsRequest shareRequest) async {
    debugPrint("request == ${shareRequest.toJson().toString()}");
    final String api = "${StringConst.API}m1363335";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(shareRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("share Submittals statuus code == ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return UpdateApiResponse.fromJson(jsonDecode(response.body));
      } else {
        return UpdateApiResponse(status: false, message: "");
      }
    } catch (e) {
      throw Exception("Share Submittals error ==$e");
    }
  }
}
