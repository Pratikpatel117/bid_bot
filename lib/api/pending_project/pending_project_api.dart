import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_list/bidlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PendingProjectAPi {
  String api = "${StringConst.API}m1343207";

  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return DateFormat('mm/dd/yyyy').format(DateTime.now());
    }
    return object;
  }

  Future<BidListResponse> getBidListApiData(
      BidListRequest bidListRequest) async {
    debugPrint("Pending Project Parameter === ${bidListRequest.toJson()}");
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(bidListRequest.toJson(), toEncodable: myDateSerializer),
      headers: GlobalValues.apiHeaders,
    );
    try {
      if (response.statusCode == 200) {
        debugPrint("Pending Project REsponce === ${response.statusCode}");
        debugPrint("Pending Project === ${response.body}");
        return BidListResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint("Pending Project Connection Fail === ${response.body}");
        return BidListResponse(
            status: false, message: 'BidList Data Are Not Found !');
      }
    } catch (e) {
      throw Exception('Server Error $e');
    }
  }
}
