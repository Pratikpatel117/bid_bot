import 'dart:convert';

import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../const/string_const.dart';

class DrawerApi {
  Future<DrawerResponse> getDrawerData(DrawerRequest drawerRequest) async {
    final String uri = "${StringConst.COMMONREST_API}m1288635";
    debugPrint('Employ Id ==== ${drawerRequest.employeeId}');
    final response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(drawerRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint('Drawer APi Body===${jsonEncode(drawerRequest.toJson())}');
    debugPrint('Drawer Api StatusCode===${response.statusCode}');

    debugPrint('Drawer Api StatusCode===${response.body}');

    if (response.statusCode == 200) {
      return DrawerResponse.fromJson(jsonDecode(response.body));
    } else {
      return DrawerResponse(status: false, message: 'Drawer Data did');
    }
  }
}
