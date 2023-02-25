import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/lead_support_management_model.dart';
import 'package:http/http.dart' as http;

class LeadSupportManagementApi {
  final String api = "${StringConst.API}m1346535";

  Future<LeadSupportManagementResponse> getLeadSupportManagementData(
      LeadSupportRequest leadSupportRequest) async {
    final response = await http.post(
      Uri.parse(
        api,
      ),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(leadSupportRequest.toJson()),
    );

    print("lead support management == ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return LeadSupportManagementResponse.fromJson(
            jsonDecode(response.body));
      } else {
        return LeadSupportManagementResponse(
            status: false, message: "invalid Data");
      }
    } catch (e) {
      throw Exception("exception error == $e");
    }
  }
}
