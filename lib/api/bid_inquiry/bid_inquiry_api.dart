// ignore_for_file: missing_return

import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/bidding/bid_inquiry_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../const/widget.dart';

final String uri = "${StringConst.API}m1345637";

class BidInquiryApi {
  Future<BidInquiryResponse> bidInquiryData(
      BidInquiryRequest bidInquiryRequest) async {
    final response = await http.post(
      Uri.parse(uri),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(bidInquiryRequest.toJson()),
    );
    debugPrint("response statusCode === ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return BidInquiryResponse.fromJson(jsonDecode(response.body));
      } else {
        BidInquiryResponse(
            status: false, message: "Bid Inquiry Data Didn't Found ");
      }
    } catch (e) {
      Exception('Server Error $e');
    }
  }
}
