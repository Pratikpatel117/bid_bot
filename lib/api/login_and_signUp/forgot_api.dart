import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/login_and_signUp/forgot_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotApi {
  Future<ForgotResponse> getForgot(ForgotRequest forgotRequest) async {
    final String url = '${StringConst.API}m1342390';
    debugPrint('FOrgot Api StatusCode===$url');
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(forgotRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint('Forgot Body===${jsonEncode(forgotRequest.toJson())}');
    debugPrint('FOrgot Api StatusCode===${response.statusCode}');
    if (response.statusCode == 200) {
      debugPrint(
          'FOrgot Api Responce ===${ForgotResponse.fromJson(jsonDecode(response.body))}');
      return ForgotResponse.fromJson(jsonDecode(response.body));
    } else {
      return ForgotResponse(
          status: false, message: 'Forgot Password Fail Try Again');
    }
  }
}
