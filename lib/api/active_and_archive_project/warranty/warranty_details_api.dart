import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/warranty/warranty_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WarrantyDetailsApi {
  Future<WarrantyDetailsModel> getWarrantyDetails(String projectId) async {
    final String api = "${StringConst.API}m1342995/$projectId";
    final response = await http.get(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("Warranty Date api response = ${response.statusCode}");
    try {
      /*   if (responce.statusCode == 200) {
        return WarrantyDetailsModel.fromJson(jsonDecode(responce.body));
      } else {
        return WarrantyDetailsModel(
            status: false, message: "In Valid Warranty data", data: null);*/

      if (response.statusCode == 200) {
        return WarrantyDetailsModel.fromJson(jsonDecode(response.body));
      } else {
        return WarrantyDetailsModel(
          status: false,
          message: "",
        );
      }
    } catch (e) {
      debugPrint("Warranty Date api data exception   = $e");
      throw Exception("Warranty Get data === $e");
    }
  }
}
