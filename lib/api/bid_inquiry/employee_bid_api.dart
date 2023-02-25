// ignore_for_file: missing_return

import 'dart:convert';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/employee_bid_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

final String uri = "${StringConst.API}m1346329";

class EmployeeBidsApi {
  Future<EmployeeBidResponse> employeeBids(
      EmployeeBidRequest employeeBidRequest) async {
    final response = await http.post(
      Uri.parse(uri),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(
        employeeBidRequest.toJson(),
      ),
    );
    debugPrint("Employee Bid StatusCode === ${response.statusCode}");
    debugPrint("Employee Bid StatusCode === ${response.body}");

    try {
      if (response.statusCode == 200) {
        return EmployeeBidResponse.fromJson(jsonDecode(response.body));
      } else {
        EmployeeBidResponse(
            status: false,
            message: "Employee Bid Data Didn't Found ",
            data: []);
      }

      if (response.statusCode != 200) {
        // logout();
      }
    } catch (e) {
      debugPrint("Employee Bid StatusCode === $e");
      Exception('Server Error $e');
    }
  }
}

void logout() async {
/*  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove("username");
//  Navigator.popAndPushNamed(context, loginPage);
  //Navigator.pushNamed(context, LOGIN_PAGE);
  GlobalValues.userToken = null;
  GlobalValues.loginEmployee = null;
  GlobalValues.selectedBidIndex = 0;
  GlobalValues.calenderView = true;
  GlobalValues.drawerListData.clear();
  TabRights.tabListData.clear();
  TabRights.sideMenuBidding.clear();
  TabRights.iconsBidding.clear();
  GlobalValues.manageBidData?.clear();*/
}
