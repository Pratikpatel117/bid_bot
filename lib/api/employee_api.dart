import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeApi {
  final String api = "${StringConst.API}m1346209";
  // EmployeeListRequest employeeListRequest;
  Future<DropDownResponse> employeeApiData(
      EmployeeListRequest employeeListRequest) async {
    // print("employee request == ${employeeListRequest.toString()}");

    final response = await http.post(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(employeeListRequest.toJson()),
    );
    print("employee response =${response.statusCode}");
    print("employee response =${employeeListRequest.toJson().toString()}");
    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        return DropDownResponse(status: false, message: "invalid Data");
      }
    } catch (e) {
      throw Exception("exception error $e");
    }
  }
}
