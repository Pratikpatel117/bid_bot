import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/startUp_date/startUp_date_model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartUpDatesApi {
  Future<StartUpDatesModel> getStartUpDates(String projectId) async {
    final String api = "${StringConst.API}m1342996/$projectId";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("StartUp Dates Api Responce  === ${response.statusCode}");
    debugPrint("StartUp Dates Api Responce  === ${response.body}");

    try {
      if (response.statusCode == 200) {
        return StartUpDatesModel.fromJson(jsonDecode(response.body));
      } else {
        return StartUpDatesModel(
            status: false, message: "In Valid Warranty data", data: null);
      }
    } catch (e) {
      debugPrint("StartUp DAtes Exception Error  === $e");
      throw Exception("StartUp DAtes Exception Error  === $e");
    }
  }

  Future<UpdateApiResponse> requestStartUpDate(
      StartupRequestDate startupRequestDate, String equipmentId) async {
    final String api = "${StringConst.API}m1345325/$equipmentId";
    final response = await http.put(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(startupRequestDate.toJson()),
    );
    debugPrint("StartUp Date Change StatusCode === ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        debugPrint(
            'StartUp Date Change Status code =====  ${response.statusCode}');
        return UpdateApiResponse.fromJson(jsonDecode(response.body));
      } /*else if (response.statusCode != 200) {
        logout();
      }*/
      else {
        debugPrint(
            "StartUp Date Change Faille Status Code ====  ${response.statusCode}");
        return UpdateApiResponse();
      }
    } catch (e) {
      debugPrint('StartUp Date Change Exception throw =====  $e');
      throw Exception('StartUp Date Change Server Error $e');
    }
  }
}

/*
void logout() async {
 SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove("username");
  // Get.toNamed('/login');
  //Navigator.pushNamedAndRemoveUntil(context, loginPage, (route) => false);
  GlobalValues.userToken = null;
  GlobalValues.loginEmployee = null;
  GlobalValues.selectedBidIndex = 0;
  GlobalValues.calenderView = true;
  GlobalValues.drawerListData.clear();
  TabRights.tabListData.clear();
  TabRights.sideMenuBidding.clear();
  TabRights.iconsBidding.clear();
  GlobalValues.manageBidData?.clear();
}
*/
