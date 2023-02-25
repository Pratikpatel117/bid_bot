import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/bid_list/bidlist_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../const/widget.dart';

class BidListApi {
  String api = "${StringConst.API}m1343759";

  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return DateFormat('mm/dd/yyyy').format(DateTime.now());
    }
    return object;
  }

  Future<BidListResponse> getBidListApiData(
      BidListRequest bidListRequest) async {
    debugPrint("BidList Data Request Parameter === ${bidListRequest.toJson()}");
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(bidListRequest.toJson(), toEncodable: myDateSerializer),
      headers: GlobalValues.apiHeaders,
    );

    try {
      if (response.statusCode == 200) {
        debugPrint("BidList Data REsponce === ${response.statusCode}");
        debugPrint("BidList Data === ${response.body}");

        return BidListResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint("BidList data Connection Fail === ${response.body}");
        return BidListResponse(
            status: false, message: 'BidList Data Are Not Found !');
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }
}
