import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../../const/string_const.dart';
import '../../../const/widget.dart';
import 'package:http/http.dart' as http;
import '../model/app_intro_model.dart';

class AppIntroApi {
  Future<GetAppIntroData> AppIntroData(String appId) async {
    final String api = "${StringConst.API}m1364524/${GlobalValues.appId}";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("App Intro api === $api");

    debugPrint("App Intro StatusCode === ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return GetAppIntroData.fromJson(jsonDecode(response.body));
      } else {
        GetAppIntroData(
          status: false,
          message: "App Intro list Not Found",
        );
      }
    } catch (e) {
      debugPrint("App Intro List Exception Error  === $e");
      Exception('Server Error $e');
    }
  }
}
