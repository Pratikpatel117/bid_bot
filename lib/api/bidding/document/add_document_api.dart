import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/bidding/bidder/add_bidder_model.dart';
import 'package:bidbot/model/bidding/document/add_document_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../const/widget.dart';

class AddDocumentApi {
  Future<UploadResponse> addDocumentAPi(
      AddDocumentRequest documentRequest) async {
    final String api = "${StringConst.API}m1345439";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(documentRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("document Apio response = ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return UploadResponse.fromJson(jsonDecode(response.body));
      } else {
        return UploadResponse(status: false, message: "Invalid Document Data");
      }
    } catch (e) {
      debugPrint("Document Exception Error = $e");
      throw Exception("get Document Exception == $e");
    }
  }
}
