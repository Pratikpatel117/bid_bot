import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileApi {
  Future<ProfileResponse> getProfileApiData() async {
    //https://www.myciright.com/Ciright/api/commonrestapi/m1064731/%7BemployeeId%7D
    final String uri =
        "${StringConst.COMMONREST_API}m1064731/${GlobalValues.loginEmployee.employeeId}";
    final response = await http.get(
      Uri.parse(uri),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint('Profile Page Status =====  ${response.statusCode}');
    try {
      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        return ProfileResponse();
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }

  Future<UpdateApiResponse> updateProfile(
      ProfileUpdateRequest profileRequest) async {
    final String uri =
        "${StringConst.COMMONREST_API}m1065385/${GlobalValues.loginEmployee.employeeId}";
    final response = await http.put(
      Uri.parse(uri),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(profileRequest.toJson()),
    );
    debugPrint("Profile Responce = ${profileRequest.toJson().toString()}");
    try {
      if (response.statusCode == 200) {
        debugPrint('Profile Update Status code =====  ${response.statusCode}');
        return UpdateApiResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint(
            " Profile Update Faille Status Code ====  ${response.statusCode}");

        return UpdateApiResponse();
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }
}
