import 'dart:convert';

import 'package:bidbot/model/bidding/bidder/qab_bidder_model.dart';
import 'package:flutter/cupertino.dart';
import '../../../const/string_const.dart';
import '../../../const/widget.dart';
import 'package:http/http.dart' as http;

import '../../../model/profile_model.dart';

class QABBidderApi {
  Future<QABBidderGetResponse> qabData() async {
    final String api =
        "${StringConst.API}m1362491/${GlobalValues.loginEmployee.employeeId}";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("QabBidderResponse api === $api");

    debugPrint("QabBidderResponse StatusCode === ${response.statusCode}");
    // debugPrint("QabBidderResponse StatusCode === ${}");
    debugPrint(
        "QabBidderResponse EmployeeId === ${GlobalValues.loginEmployee.employeeId}");

    try {
      if (response.statusCode == 200) {
        return QABBidderGetResponse.fromJson(jsonDecode(response.body));
      } else {
        return QABBidderGetResponse(
          status: false,
          message: "QAB Not Found",
        );
      }
    } catch (e) {
      debugPrint("QAB Exception Error  === $e");
      Exception('Server Error $e');
    }
  }

  Future<QABGetContactData> QABContactData(String customerId) async {
    final String api = "${StringConst.API}m1362492/$customerId";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("QabBidderContactData api === $api");

    debugPrint("QabBidderContactData StatusCode === ${response.statusCode}");
    debugPrint(
        "QabBidderContactData EmployeeId === ${GlobalValues.loginEmployee.employeeId}");

    try {
      if (response.statusCode == 200) {
        return QABGetContactData.fromJson(jsonDecode(response.body));
      } else {
        QABGetContactData(
          status: false,
          message: "QAB Contact list Not Found",
        );
      }
    } catch (e) {
      debugPrint("QAB Contact List Exception Error  === $e");
      Exception('Server Error $e');
    }
  }

  Future<UpdateApiResponse> submitselectedcontactdata(
      QABSubmitData qabSubmitData) async {
    debugPrint('QAB Save Contact Data Api Call====${StringConst.API}m1362493');
    final String uri = '${StringConst.API}m1362493';
    debugPrint('Json Body Parameter==== ${jsonEncode(qabSubmitData.toJson())}');

    final response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(qabSubmitData.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint('Responce Save Contact Data Call==== ${response.body}');

    if (response.statusCode == 200) {
      //    debugPrint('Api Data Printed   ${resonce.body}' );
      return UpdateApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return UpdateApiResponse();
    }
  }
}
