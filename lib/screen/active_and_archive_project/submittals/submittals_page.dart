import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bidbot/api/active_and_archive_project/submittals/submittals_api.dart';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/submittals_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SubmittalsPage extends StatefulWidget {
  const SubmittalsPage({Key key}) : super(key: key);

  @override
  _SubmittalsPageState createState() => _SubmittalsPageState();
}

class _SubmittalsPageState extends State<SubmittalsPage> {
  String projectId = " ";
  bool isLoading = false;
  bool Loading = false;
  List<SubmittalsData> submittalsData = [];
  int selectionIndex = 0;
  int progress = 0;
  String _progress = "-";
  ReceivePort receivePort = ReceivePort();
  var dio = Dio();

  Future<void> downloadDocumentFIle(SubmittalsData documentData) async {
    setState(() {
      isLoading = true;
    });
    // requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;
    var platformDirect;
    if (Platform.isIOS) {
      platformDirect = (await getApplicationDocumentsDirectory()).path;
    } else if (Platform.isAndroid) {
      platformDirect = (await getExternalStorageDirectory()).path;
    }
    // gets the directory where we will download the file.
    // var dir = (await getApplicationDocumentsDirectory()).path;

    // You should put the name you want for the file here.
    // Take in account the extension.
    String fileName = documentData.fileName;
    // final String url = "$pdfUrl$docId\.$fileExt";
    final String url =
        "${documentData.pdfUrl}${documentData.submittalId}\.${documentData.fileExtention}";
    // String url =  "https://ciright-documents.s3.amazonaws.com/${documentData.docId}\.${documentData.fileExt}";
    // downloads the file
    Dio dio = Dio();
    // await dio.download(url, "$platformDirect/$fileName");
    // opens the file
    // OpenFile.open("$platformDirect/$fileName", type: 'application/pdf');
    downloadDocument(documentData.pdfUrl, documentData.equipmentId,
        documentData.fileExtention);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onReceiveProgress(int received, int total) async {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

  void downloadDocument(String pdfUrl, String docId, String fileExt) async {
    setState(() {
      isLoading = true;
    });
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final String url = "$pdfUrl$docId\.$fileExt";
      debugPrint("String url == $url ");

      final id = await FlutterDownloader.enqueue(
          url: url, savedDir: baseStorage.path, fileName: "$docId\.$fileExt");
      debugPrint("ID == $id");
    } else {
      debugPrint("No Permission ");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "documentDownload");
    receivePort.listen((message) {
      if (mounted) {
        setState(() {
          progress = message;
          debugPrint("progress data === $progress");
        });
      }
    });

    FlutterDownloader.registerCallback(downloadCallBack);

    super.initState();
    if (GlobalValues.selectedBidIndex == 3) {
      projectId = ActiveProjectGlobalValue.activeProjectSubmittalsProjectId;
    }
    if (GlobalValues.selectedBidIndex == 4) {
      projectId = ProjectArchivesGlobalValue.projectArchiveSubmittalsProjectId;
    }
    getSubmittalsData(projectId);
  }

  static downloadCallBack(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("documentDownload");
    sendPort.send(progress);
  }

  Future getSubmittalsData(String projectId) async {
    setState(() {
      isLoading = true;
    });
    SubmittalsApi submittalsApi = SubmittalsApi();
    // List<SubmittalsData> list = [];
    await submittalsApi.getSubmittalsApi(projectId).then((value) {
      var status = value.status;
      debugPrint("Submittal Api status === $status");
      if (status == true) {
        submittalsData = value.data;
        /* value.data.forEach((element) {
        list.add(element);
      });*/
      }
      if (value.data == null) {
        submittalsData = null;
      }
    });
    setState(() {
      isLoading = false;
      // submittalsData.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submittals"),
        backgroundColor: ColorConst.appBarBackGroundColor,
        leading: Container(),
        titleSpacing: -30,
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Padding(
              padding: EdgeInsets.all(12),
              child: submittalsData != null
                  ? ListView.separated(
                      itemBuilder: (context, i) {
                        return submittalCard(submittalsData[i], i);
                      },
                      shrinkWrap: true,
                      separatorBuilder: (context, i) {
                        return Divider(
                          color: Colors.white,
                          height: 3,
                        );
                      },
                      itemCount: submittalsData.length)
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "No Data to display",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
            )
          : VisibleProgressBar(isLoading: isLoading, message: " "),
    );
  }

  Widget submittalCard(SubmittalsData submittalsData, int i) {
    return InkWell(
      onTap: () {
        setState(() {
          selectionIndex = i;
        });
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${submittalsData.projectEquipment}",
                style: TextStyle(
                  color: Color(0xff9A9A9A),
                  fontFamily: StringConst.FONT_FAMILY,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              /* Text(
                "${submittalsData.submittedDate}",
                style: TextStyle(
                  color: Color(0xff9A9A9A),
                  fontFamily: StringConst.FONT_FAMILY,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),*/
              /*  RichTextCommon(
                titleText: "Equipment : ",
                responceText: submittalsData.projectEquipment,
              ),
              RichTextCommon(
                titleText: "Submitted Date : ",
                responceText: submittalsData.submittedDate,
              ),*/
              selectionIndex == i
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RichTextCommon(
                          titleText: "Submitted Date : ",
                          responceText: submittalsData.submittedDate),
                    )
                  : Container(),
              selectionIndex == i
                  ? RichTextCommon(
                      titleText: "Submitted Status : ",
                      responceText: submittalsData.submittalStatus,
                    )
                  : Container(),
              selectionIndex == i
                  ? Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RichTextCommon(
                            titleText: "Tag : ",
                            responceText: submittalsData.tag,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RichTextCommon(
                              titleText: "Qty : ",
                              responceText: submittalsData.qty),
                        ),
                      ],
                    )
                  : Container(),
              selectionIndex == i
                  ? Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RichTextCommon(
                              titleText: "Lead Time : ",
                              responceText: submittalsData.leadTime),
                        ),
                        Expanded(
                          flex: 1,
                          child: RichTextCommon(
                            titleText: "Wanted Date : ",
                            responceText: submittalsData.wantedDate,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              selectionIndex == i
                  ? RichTextCommon(
                      titleText: "Equipment Status : ",
                      responceText: submittalsData.equipmentStatus,
                    )
                  : Container(),
              selectionIndex == i
                  ? RichTextCommon(
                      titleText: "Approved Date : ",
                      responceText: submittalsData.approvedDate,
                    )
                  : Container(),
              selectionIndex == i
                  ? RichTextCommon(
                      titleText: "Release Date : ",
                      responceText: submittalsData.requiredReleaseDate,
                    )
                  : Container(),
              selectionIndex == i
                  ? RichTextCommon(
                      titleText: "Prepared By : ",
                      responceText: submittalsData.preparedBy,
                    )
                  : Container(),
              selectionIndex == i
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            ActiveProjectGlobalValue.submittalsData =
                                submittalsData;
                            debugPrint(
                                "submittals Id === ${submittalsData.submittalId}");
                            Navigator.popAndPushNamed(
                                context, "/addSubmittals");
                          },
                          child: Icon(
                            Icons.file_upload,
                            color: Colors.blueAccent,
                          ),
                        ),

                        // Icon(Icons)
                        InkWell(
                          onTap: () //async
                              {
                            //  var tempDir = await getTemporaryDirectory();
                            //   String fullPath = tempDir.path + "/${submittalsData.submittalId}.${submittalsData.fileExtention}'";
                            //   print('full path $fullPath');
                            //   download2(dio, submittalsData.pdfUrl, fullPath);
                            downloadDocumentFIle(submittalsData);
                            // downloadDocument(
                            //     submittalsData.pdfUrl,
                            //     submittalsData.submittalId,
                            //     submittalsData.fileExtention);
                          },
                          child: Icon(
                            Icons.file_download,
                            color: Colors.blueAccent,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ActiveProjectGlobalValue.submittalsData =
                                submittalsData;
                            openPdf(
                                "${submittalsData.pdfUrl}${submittalsData.submittalId}.${submittalsData.fileExtention}");
                            debugPrint(
                                "tab url === ${submittalsData.pdfUrl}${submittalsData.submittalId}.${submittalsData.fileExtention}");
                          },
                          child: Icon(
                            Icons.description,
                            size: 20,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  openPdf(dynamic url) async {
    setState(() {
      isLoading = true;
    });
    PdfApi pdfApi = PdfApi();
    final file = await pdfApi.getPdfUrl(url);
    GlobalValues.pdfFile = file;
    setState(() {
      isLoading = false;
    });
    Navigator.pushNamed(context, "/pdfView");
  }
}
