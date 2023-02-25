import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  Future<File> getPdfUrl(String url) async {
    /*   final pdfBytes = base64Url.decode(url);
    debugPrint("pdf pdfBytes = $pdfBytes");
  */
    final response = await http.get(
      Uri.parse(url),
    );
    final bytes = response.bodyBytes;
    debugPrint("pdf Api bytes = $bytes");
    // final file = base64UrlEncode(bytes);
    final filename = basename(url);
    debugPrint("pdf Api fileNAme = $filename");
    Directory dir = await getApplicationDocumentsDirectory();
    debugPrint("pdf Api dir = $dir");
    final file = File('${dir.path}/$filename');
    debugPrint("pdf file Document = $file");
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> proposalPdf(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );
    debugPrint("response of proposal = ${response.body}");

    Map<String, dynamic> decodeToBytes = jsonDecode(response.body);
    var onlyByte = decodeToBytes["byteData"];
    // debugPrint("pdf fileTest = $onlyByte");
    Uint8List decodeByte = base64Decode(onlyByte);
    // debugPrint("pdf fileTest = ${decodeByte.buffer}");
    final pdfName = basename(decodeByte.toString());
    debugPrint("pdf fileTest = $pdfName");
    final filename = basename(url);
    debugPrint("pdf Api fileNAme = $filename");
    Directory dir = await getApplicationDocumentsDirectory();
    debugPrint("pdf Api dir = $dir");
    final file = File('${dir.path}/$filename');
    debugPrint("pdf file Document = $file");
    await file.writeAsBytes(decodeByte, flush: true);
    return file;
    /*   final pdfBytes = base64Url.decode(url);
    debugPrint("pdf pdfBytes = $pdfBytes");
  */
    // final bytes = response.bodyBytes;
    // debugPrint("pdf Api bytes = $bytes");
    // Uint8List fileTest = base64Decode(response.body);
    // debugPrint("pdf fileTest = $fileTest");
  }
}
