import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/login_and_signUp/change_password_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordApi {
  Future<ChangePasswordResponse> getChangePass(
      ChangePasswordRequest changePasswordRequest) async {
    final String url = '${StringConst.COMMONREST_API}m1303853';
    debugPrint('FOrgot Api StatusCode===$url');
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(changePasswordRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint(
        'Change Password Api Body===${jsonEncode(changePasswordRequest.toJson())}');
    debugPrint('Change Password Api StatusCode===${response.statusCode}');
    if (response.statusCode == 200) {
      debugPrint(
          'Change Password Api Responce ===${ChangePasswordResponse.fromJson(jsonDecode(response.body))}');
      return ChangePasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      return ChangePasswordResponse(
          status: false, message: 'Forgot Password Fail Try Again');
    }
  }
}
// without change  dHJpc3RhdGVAY2lyaWdodC5jb206dHJpQDEyMw==
// with web change dHJpc3RhdGVAY2lyaWdodC5jb206dHJpMTIz
