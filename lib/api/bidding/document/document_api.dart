import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/bidding/document/document_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../const/widget.dart';

class DocumentAPi {
  Future<DocumentDataResponce> documentData(
      DocumentDataRequest documentRequest) async {
    final String api = "${StringConst.API}m1342690";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(documentRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("document Apio response = ${response.statusCode}");
    debugPrint("document Apio response = ${response.body}");
    try {
      if (response.statusCode == 200) {
        return DocumentDataResponce.fromJson(jsonDecode(response.body));
      } else {
        return DocumentDataResponce(
            status: false, message: "Invalid Document Data");
      }
    } catch (e) {
      throw Exception("get Document Exception == $e");
    }
  }
}
