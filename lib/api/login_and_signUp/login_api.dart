import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/login_and_signUp/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../const/widget.dart';

class LoginApi {
  //https://www.myciright.com/Ciright/api/commonrestapi/m1342055

  /* Common {
   var ws_login = commonURL + "m1342055";}

    BidList {
    var ws_getProject_byDate = bidListURL + "m1342056";}
*/

  Future<ResponseModel> getLogin(LoginRequest request) async {
    debugPrint('${StringConst.COMMONREST_API}m1342055');
    debugPrint('${request.toJson().toString()}');
    final response = await http.post(
      Uri.parse('${StringConst.COMMONREST_API}m1342055'),
      body: jsonEncode(request.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    try {
      if (response.statusCode == 200) {
        // debugPrint('Login Api Data Printed   ${response.body}');
        return ResponseModel.fromJson(jsonDecode(response.body));
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint('Api Data Not Printed  ${response.statusCode}');
        return ResponseModel(
            status: false, message: "Login failed. Try again.");
      }
    } catch (e) {
      debugPrint('Login Exception Error == $e');
      throw Exception("Login Exception Error");
    }
  }
}
