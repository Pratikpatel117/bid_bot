import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/service_request/add_service_request_model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddServiceRequestApi {
  Future<LineItemsEquipment> getLineItemsEquipmentData() async {
    final String api =
        "${StringConst.API}m1349427/${ActiveProjectGlobalValue.activeProjectServiceRequestProjectId}";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint(
        "Service Request LineItems status code == ${response.statusCode}  ");
    try {
      if (response.statusCode == 200) {
        return LineItemsEquipment.fromJson(jsonDecode(response.body));
      } else {
        return LineItemsEquipment(
            status: false, message: "Invalid Data", data: null);
      }
    } catch (e) {
      debugPrint("Error Message line Items Data in Service === $e");
      throw Exception("Error Message line Items Data in Service Request");
    }
  }

  Future<UpdateApiResponse> submitservicerequestdata(
      Submitservicerequest submitservicerequest) async {
    debugPrint('AddServiceRequestData Api Call====${StringConst.API}m1349585');
    final String uri = '${StringConst.API}m1349585';
    debugPrint(
        'Json Body Parameter==== ${jsonEncode(submitservicerequest.toJson())}');

    final response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(submitservicerequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint('ResponceData Call==== ${response.body}');

    if (response.statusCode == 200) {
      //    debugPrint('Api Data Printed   ${resonce.body}' );

      return UpdateApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return UpdateApiResponse();
    }
  }
}
