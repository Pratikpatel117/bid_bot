import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/login_and_signUp/signup_model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpApi {
  Future<UpdateApiResponse> getSignUp(SignUpRequest signUpRequest) async {
    debugPrint('SignUpApi Call====${StringConst.API}m1345640');
    final String uri = '${StringConst.API}m1345640';
    debugPrint('Json Body Parameter==== ${jsonEncode(signUpRequest.toJson())}');

    final response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(signUpRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint('REsPonceData Call==== ${response.body}');

    if (response.statusCode == 200) {
      //    debugPrint('Api Data Printed   ${resonce.body}' );

      return UpdateApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return UpdateApiResponse(
          status: false, message: "Registration failed. Try again.");
    }
  }
}
