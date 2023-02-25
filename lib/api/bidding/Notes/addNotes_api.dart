import 'dart:convert';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/notes/add_notes_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddNotesApi {
  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return DateFormat('mm/dd/yyyy').format(DateTime.now());
    }
    return object;
  }

  Future<AddNotesResponce> addNotesData(AddNotesRequest notesRequest) async {
    final String api = "${StringConst.API}m1342782";
    debugPrint("Notes Request = ${notesRequest.toJson().toString()}");
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(notesRequest.toJson(), toEncodable: myDateSerializer),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("Add Notes Responce Status ${response.statusCode}");
    debugPrint("Add Notes Responce  ${response.body}");
    try {
      if (response.statusCode == 200) {
        return AddNotesResponce.fromJson(jsonDecode(response.body));
      } else {
        return AddNotesResponce(
          status: false,
          message: "Data Not Fetch",
        );
      }
    } catch (e) {
      debugPrint("TabData Exception $e");
      throw Exception("TabData Exception $e");
    }
  }

  Future<DropDownResponse> notesTabData(AddNotesTabRequest tabRequest) async {
    final String api = "${StringConst.COMMONREST_API}m1345440";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(tabRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );
    debugPrint("Add Notes Tab Data Responce Status ${response.statusCode}");
    try {
      if (response.statusCode == 200) {
        return DropDownResponse.fromJson(jsonDecode(response.body));
      } else {
        return DropDownResponse(
            status: false, message: "Data Not Fetch", data: []);
      }
    } catch (e) {
      debugPrint("TabData Exception $e");
      throw Exception("TabData Exception $e");
    }
  }
}
