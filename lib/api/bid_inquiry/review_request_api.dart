// ignore_for_file: missing_return

import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bid_Inquiry/project_filter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../const/widget.dart';

class FilterApi {
  final String uri = "${StringConst.API}m1347758";

  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return DateFormat('MM-dd-yyyy').add_Hms().format(DateTime.now());
    }
    return object;
  }

  Future<DropDownResponse> filterApi(FilterRequest filterRequest) async {
    final response = await http.post(
      Uri.parse(uri),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(filterRequest.toJson(), toEncodable: myDateSerializer),
      encoding: Encoding.getByName(""),
    );
    debugPrint("response statusCode === ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        DropDownResponse(
            status: false, message: "Bid Inquiry Data Didn't Found ");
      }
    } catch (e) {
      Exception('Server Error $e');
    }
  }
}
