import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bidbot/model/bidding/bidding_model.dart';
import 'package:intl/intl.dart';

class BiddingProjectListApi {
  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return DateFormat('mm/dd/yyyy').format(DateTime.now());
    }
    return object;
  }

  Future<BiddingListResponse> getListData(ListRequest listRequest) async {
    debugPrint('${listRequest.toJson().toString()}');
    final response = await http.post(
      Uri.parse('${StringConst.API}m1342056'),
      body: jsonEncode(listRequest.toJson(), toEncodable: myDateSerializer),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint('Bidding ListData =====  ${response.statusCode}');
    // debugPrint('Bidding ListData =====  ${response.body}');
    try {
      if (response.statusCode == 200) {
        var biddingResponse =
            BiddingListResponse.fromJson(jsonDecode(response.body));
        return biddingResponse;
      } else {
        //ListResponce.fromJson(jsonDecode(response.body));
        debugPrint(response.statusCode.toString());
        return BiddingListResponse();
      }
    } catch (e) {
      debugPrint("Bidding exception error === $e");
      throw Exception('Server Error $e');
    }
    //   debugPrint('StatusCode =====  ${response.statusCode}');
    // debugPrint('date time== ${listRequest.toJson().toString()}');
  }
}
