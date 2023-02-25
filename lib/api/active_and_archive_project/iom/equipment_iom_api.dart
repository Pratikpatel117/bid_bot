import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/iom/equipment_iom_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EquipmentIOMApi {
  Future<EquipmentIOMModel> getEquipmentIOM(
      String apiNumber, String projectId) async {
    final String api =
        "${StringConst.API}$apiNumber/${GlobalValues.loginEmployee.employeeId}/$projectId"; //m1344236
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("Equipment IOM Date api response = ${response.statusCode}");
    debugPrint("Equipment IOM Date api response = ${response.body}");
    try {
      if (response.statusCode == 200) {
        return EquipmentIOMModel.fromJson(jsonDecode(response.body));
      } else {
        return EquipmentIOMModel(
            status: false, message: "In Valid Warranty data", data: null);
      }
    } catch (e) {
      debugPrint("Equipment IOM api data exception   = $e");
      throw Exception("Warranty Get data === $e");
    }
  }
}
