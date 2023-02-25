import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bidbot/api/bidding/document/document_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/main.dart';
import 'package:bidbot/model/bidding/document/document_model.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_path_provider/android_path_provider.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:dio/dio.dart';

class DocumentPage extends StatefulWidget with WidgetsBindingObserver {
  const DocumentPage({Key key}) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage> {
  int selectionIndex = 0;
  DocumentDataRequest documentRequest;
  List<DocumentData> documentData = [];
  int listIndex;
  bool isLoading = false;
  int progress = 0;
  ReceivePort receivePort = ReceivePort();
  String projectId = " ";
  bool _permissionReady;
  String _localPath;
  final List<_TaskInfo> _tasks = [];
  _TaskInfo _taskInfo;
  final List<_ItemHolder> _items = [];
  _ItemHolder _itemHolder;

  Future downloadOptions(_TaskInfo task, String docId, String fileExt) async {
    // if (task.status == DownloadTaskStatus.undefined) {
    downloadDocument(docId, fileExt);
    // } else if (task.status == DownloadTaskStatus.complete) {
    //   _openDownloadedFile(task).then((success) {
    //     if (!success) {
    //       Scaffold.of(context)
    //           .showSnackBar(SnackBar(content: Text('Cannot open this file')));
    //     }
    //   });
    //   _openDownloadedFile(task);
    // }
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId);
    } else {
      return Future.value(false);
    }
  }

  void downloadDocument(String docId, String fileExt) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      if (Platform.isAndroid) {
        final baseStorage = await getExternalStorageDirectory();
        final String url =
            "https://ciright-documents.s3.amazonaws.com/$docId\.$fileExt";
        debugPrint("String url == $url ");

        final id = await FlutterDownloader.enqueue(
            url: url, savedDir: baseStorage.path, fileName: "$docId\.$fileExt");
        debugPrint("ID == $id");
      } else if (Platform.isIOS) {
        // final baseStorage =
        //     (await ExtStorage.getExternalStorageDirectory());
        final String url =
            "https://ciright-documents.s3.amazonaws.com/$docId\.$fileExt";
        debugPrint("String url == $url ");

        final id = await FlutterDownloader.enqueue(
          url: url,
          savedDir: _localPath,
          fileName: "$docId\.$fileExt",
          headers: {"auth": "test_for_sql_encoding"},
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true,
        );
        debugPrint("ID == $id");
        debugPrint("ID == $_localPath");
      }
      // final baseStorage =   await getApplicationDocumentsDirectory();
      // final String url =
      //     "https://ciright-documents.s3.amazonaws.com/$docId\.$fileExt";
      // debugPrint("String url == $url ");
      //
      // final id = await FlutterDownloader.enqueue(
      //     url: url, savedDir: baseStorage.path, fileName: "$docId\.$fileExt");
      // debugPrint("ID == $id");
    } else {
      debugPrint("No Permission ");
    }
    _openDownloadedFile(_taskInfo);
  }

  @override
  void initState() {
    // _bindBackgroundIsolate();
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.documentData.projectId;
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidListDocument.projectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidDocument.projectId;
    }
    getDocumentData();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "documentDownload");
    // receivePort.listen((message) {
    //   if(mounted) {
    //     setState(() {
    //       progress = message;
    //       debugPrint("progress data === $progress");
    //     });
    //   }
    // });
    receivePort.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });

    FlutterDownloader.registerCallback(downloadCallBack);

    super.initState();

    _prepare();
  }

  _prepare() async {
    await FlutterDownloader.loadTasks();
    // _items = [];
    int count = 0;
    List<_TaskInfo> testList = [];
    List<_ItemHolder> itemHolderList = [];
    // _tasks = [];
    // _tasks.addAll();
    // _tasks.add(_TaskInfo(name: "",link: ""));
    for (int i = count; i < documentData.length; i++) {
      _items.add(_ItemHolder(name: documentData[i].fileName, task: _tasks[i]));
      count++;
    }
    // tasks.forEach((task) {
    //   for (_TaskInfo info in _tasks) {
    //     if (info.link == task.url) {
    //       info.taskId = task.taskId;
    //       info.status = task.status;
    //       info.progress = task.progress;
    //     }
    //   }
    // });
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }
    // }
  }

  Future<void> downloadDocumentFIle(DocumentData documentData) async {
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
    var dir = (await getApplicationDocumentsDirectory()).path;

    // You should put the name you want for the file here.
    // Take in account the extension.
    String fileName = documentData.fileName;
    String url =
        "https://ciright-documents.s3.amazonaws.com/${documentData.docId}\.${documentData.fileExt}";
    // downloads the file
    Dio dio = Dio();
    await dio.download(url, "$platformDirect/$fileName");

    // opens the file
    OpenFile.open("$platformDirect/$fileName", type: 'application/pdf');
    setState(() {
      isLoading = false;
    });
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<bool> _checkPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (GlobalValues.platform == TargetPlatform.android &&
          androidInfo.version.sdkInt <= 28) {
        final status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (GlobalValues.platform == TargetPlatform.iOS) {
        final status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).path;
    }
    return externalStorageDirPath;
  }

  static downloadCallBack(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("documentDownload");
    sendPort.send(progress);
  }

  Future getDocumentData() async {
    setState(() {
      isLoading = true;
      documentData.clear();
    });
    documentRequest = DocumentDataRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      verticalId: "${GlobalValues.verticalId}",
      projectId: projectId,
      tabId: GlobalValues.loginEmployee.sphereTypeId == 1 ? null : "1508078",
      /*GlobalValues.drawerListData == null
          ? "1508078"
          : "${GlobalValues.drawerListData[0].tabId}",*/
    );
    DocumentAPi documentAPi = DocumentAPi();
    List<DocumentData> list = [];
    await documentAPi.documentData(documentRequest).then((value) {
      var status = value.status;
      debugPrint("get Document Data == $status");
      value.data?.forEach((element) {
        list.add(element);
        debugPrint("get Document Data == $element");
        debugPrint("get Tab Id == ${GlobalValues.drawerListData[0].tabId}");
      });
      documentData.addAll(list);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Docs'),
        actions: [
          GlobalValues.selectedBidIndex == 0 ||
                  GlobalValues.selectedBidIndex == 2 &&
                      GlobalValues.loginEmployee.sphereTypeId == 1 &&
                      TabRights.tabListData.any((element) => element.isAdd == 1)
              ? InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/addDocument");
                  },
                  child: Icon(
                    Icons.add_outlined,
                    size: 32,
                  ),
                )
              : SizedBox(),
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: documentData.isNotEmpty && documentData != null
                  ? ListView.separated(
                      separatorBuilder: (context, i) {
                        return Divider(
                          height: 4,
                        );
                      },
                      itemCount: documentData.length,
                      itemBuilder: (context, i) {
                        listIndex = i;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectionIndex = i;
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      "${documentData[i].fileName}",
                                      style: TextstyleConst.biddingProjectTitle,
                                    ),
                                  ),
                                  selectionIndex == i
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 1),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: "Created Date : ",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${documentData[i].createdDate.split(" ")[0]}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9A9A9A),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30),
                                                          child: Image.asset(
                                                              "asset/image/bidding/document_file.png")),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${documentData[i].fileSize}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9A9A9A),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  selectionIndex == i
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 1),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: "Created By : ",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${documentData[i].createdBy}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9A9A9A),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 33),
                                                        child: InkWell(
                                                          child: Icon(
                                                            Icons.get_app,
                                                            size: 28,
                                                            color: Color(
                                                                0xff0BA2E4),
                                                          ),
                                                          onTap: () {
                                                            downloadDocumentFIle(
                                                                documentData[
                                                                    i]);
                                                            // downloadOptions(
                                                            //     _taskInfo,
                                                            //     documentData[i].docId,
                                                            //     documentData[i]
                                                            //         .fileExt);
                                                            // downloadDocument(
                                                            //     documentData[i].docId,
                                                            //     documentData[i]
                                                            //         .fileExt);
                                                            // https://ciright-documents.s3.amazonaws.com/'row.docId
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "No Data to display",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
