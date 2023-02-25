import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/service_request/service_request_model.dart';
import 'package:flutter/cupertino.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;

class ServiceRequestApi {
  Future<ServiceRequestResponse> getServiceRequest(
      ServiceRequest serviceRequest) async {
    final String api = "${StringConst.API}m1349600";
    final response = await http.post(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(serviceRequest.toJson()),
    );
    debugPrint("Service Request Api Responce  === ${response.statusCode}");
    // debugPrint("StartUp Dates Api Responce  === ${response.body}");
    try {
      if (response.statusCode == 200) {
        return ServiceRequestResponse.fromJson(jsonDecode(response.body));
      } else {
        return ServiceRequestResponse(
            status: false, message: "In Valid Warranty data", data: null);
      }
    } catch (e) {
      debugPrint("Service Request Exception Error  === $e");
      throw Exception("Service Request Exception Error  === $e");
    }
  }
}
