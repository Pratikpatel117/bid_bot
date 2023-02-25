import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectInformationApi {
  final String api = "${StringConst.API}m1348718/";
  Future<ProjectInformation> getProjectInformation(projectId) async {
    final response = await http.get(
      Uri.parse(api + projectId.toString()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint(" Project Information Status code = ${response.statusCode}");
    debugPrint(" Project Information APi Response == ${response.body}");
    debugPrint(" API Project Information Status code = ${api + projectId}");
    try {
      if (response.statusCode == 200) {
        return ProjectInformation.fromJson(jsonDecode(response.body));
      } else {
        return ProjectInformation(
            status: false, message: "Project Information Data Didn't Get");
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }
}
