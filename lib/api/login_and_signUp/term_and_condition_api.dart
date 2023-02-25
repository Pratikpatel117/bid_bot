import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/login_and_signUp/term_and_condition_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TermAndConditionAPi {
  Future<TermAndConditionResponse> getTermAndConditionApi() async {
    final String api =
        "${StringConst.COMMONREST_API}m1346130/${GlobalValues.verticalId}/${GlobalValues.appId}";

    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("term & condition api response == ${response.statusCode}");
    try {
      if(response.statusCode == 200) {
        return TermAndConditionResponse.fromJson(jsonDecode(response.body));
      }
       else {
         return TermAndConditionResponse(status: false,message: "",data: null);
      }
    } catch (e) {
      debugPrint("term & condition error == $e");
      throw Exception("platform exception error == $e");
    }
  }
}
