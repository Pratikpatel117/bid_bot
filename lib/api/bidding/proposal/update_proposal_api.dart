import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bidder/add_bidder_model.dart';
import 'package:bidbot/model/bidding/update_proposal/updateProposal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UploadProposalApi {
  Future<UploadResponse> uploadProposalAPi(
      UpdateProposalRequest proposalRequest) async {
    final String api = "${StringConst.API}m1345628";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(proposalRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("proposalRequest Api response = ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return UploadResponse.fromJson(jsonDecode(response.body));
      } else {
        return UploadResponse(status: false, message: "Invalid Document Data");
      }
    } catch (e) {
      debugPrint("proposalRequest Exception Error = $e");
      throw Exception("get Document Exception == $e");
    }
  }
}
