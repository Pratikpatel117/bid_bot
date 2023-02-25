import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/bidder/add_bidder_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBidderApi {
  Future<UploadResponse> addBidderSave(AddBidderRequest bidderRequest) async {
    final String api = "${StringConst.API}m1342784/";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(bidderRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("AddBidderResponce StatusCode === ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return UploadResponse.fromJson(jsonDecode(response.body));
      } else {
        return UploadResponse(status: false, message: "Invalid AddBidder Data");
      }
    } catch (e) {
      throw Exception("Exception error == $e");
    }
  }

  Future<DropDownResponse> getAddBidderDropDownApi(String getApi) async {
    // final String api =
    //     "${StringConst.API}$getApi/${GlobalValues.loginEmployee.employeeId}";
    final response = await http.get(
      Uri.parse(getApi),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("addBidder DropDown Api response = ${response.body}");
    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        return DropDownResponse(status: false, message: "Phase Id Didn't Get");
      }
    } catch (e) {
      debugPrint("AddBidder Exception Error = $e");
      throw Exception("LeadId Exception Throw -- $e");
    }
  }
}
