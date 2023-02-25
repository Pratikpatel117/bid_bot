import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/bidding/notes/notes_list_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../const/widget.dart';

class NotesListApi {
  final String api = "${StringConst.API}m1342612";
  Future<NotesListResponce> notesListData(
      NotesListRequest notesListRequest) async {
    final response = await http.post(
      Uri.parse(api),
      headers: GlobalValues.apiHeaders,
      body: jsonEncode(notesListRequest.toJson()),
    );
    debugPrint("NotesApi Status Code === ${response.statusCode} ");
    debugPrint("NotesApi Status Code === ${response.body} ");
    debugPrint("Responce value = ${notesListRequest.toJson().toString()}");

    try {
      if (response.statusCode == 200) {
        return NotesListResponce.fromJson(jsonDecode(response.body));
      } else {
        return NotesListResponce();
      }
    } catch (e) {
      throw Exception("Notes Error $e");
    }
  }
}
