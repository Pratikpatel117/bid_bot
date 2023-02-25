// ignore_for_file: missing_return

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/line_Items/line_items_Model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LineItemsApi {
  Future<LineItemsResponce> getLineItemsApi(String projectId) async {
    final String api =
        "${StringConst.API}m1342613/$projectId/${GlobalValues.loginEmployee.employeeId}";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("LineItemsResponse api === $api");

    debugPrint("LineItemsResponce StatusCode === ${response.statusCode}");
    debugPrint("LineItemsResponce ProjectId === $projectId");

    try {
      if (response.statusCode == 200) {
        return LineItemsResponce.fromJson(jsonDecode(response.body));
      } else {
        LineItemsResponce(
          status: false,
          message: "LineItemsResponce Didn't Found ",
        );
      }
    } catch (e) {
      debugPrint("LineItemsResponce Exception Error  === $e");
      Exception('Server Error $e');
    }
  }

  Future<UpdateApiResponse> updateDisplayProposal(
      LineItemsDisplayProposalRequest displayProposalRequest,
      String equipmentId) async {
    final String api = "${StringConst.API}m1344570/$equipmentId";
    final response = await http.put(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(displayProposalRequest.toJson()),
    );
    debugPrint(
        "LineItemsDisplayProposalRequest StatusCode === ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        debugPrint(
            'LineItemsDisplayProposalRequest Status code =====  ${response.statusCode}');
        return UpdateApiResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint(
            "LineItemsDisplayProposalRequest Faille Status Code ====  ${response.statusCode}");
        return UpdateApiResponse();
      }
    } catch (e) {
      debugPrint('Exception throw =====  $e');
      throw Exception('Server Error $e');
    }
  }
}
