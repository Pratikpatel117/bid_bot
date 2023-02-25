import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/submittals_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmittalsApi {
  Future<SubmittalsModel> getSubmittalsApi(String projectId) async {
    final String api =
        "${StringConst.API}m1342610/${GlobalValues.loginEmployee.employeeId}/$projectId";

    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("submittals response === ${response.statusCode}");
    debugPrint("submittals response === ${response.body}");
    try {
      if (response.statusCode == 200) {
        return submittalsModelFromJson(response.body);
      } else {
        return submittalsModelFromJson(response.body);
      }
    } catch (e) {
      debugPrint("submittals Exception Error === $e");
      throw Exception("Submittals Data Exception Error $e");
    }
  }
}
