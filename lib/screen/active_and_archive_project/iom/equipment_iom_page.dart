import 'package:bidbot/api/active_and_archive_project/iom/equipment_iom_api.dart';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/iom/equipment_iom_model.dart';
import 'package:flutter/material.dart';

import '../../../const/style_const.dart';

class EquipmentIOMPage extends StatefulWidget {
  const EquipmentIOMPage({Key key}) : super(key: key);

  @override
  _EquipmentIOMPageState createState() => _EquipmentIOMPageState();
}

class _EquipmentIOMPageState extends State<EquipmentIOMPage> {
  bool isLoading = false;
  List<EquipmentIOMData> equipmentIomData = [];
  String projectId = " ";

  // int selectionIndex;
  String apiNumber = " ";
  String pageName = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 3) {
      projectId = ActiveProjectGlobalValue.activeProjectEquipmentIOMProjectId;
    }
    if (GlobalValues.selectedBidIndex == 4) {
      projectId =
          ProjectArchivesGlobalValue.projectArchiveEquipmentIOMProjectId;
    }
    if (ProjectArchivesGlobalValue.communeScreenApi == 0) {
      apiNumber = "m1344236";
      pageName = 'IOM\'s';
    } else if (ProjectArchivesGlobalValue.communeScreenApi == 1) {
      apiNumber = "m1344239";
      pageName = "Spare Parts";
    } else if (ProjectArchivesGlobalValue.communeScreenApi == 2) {
      apiNumber = "m1344240";
      pageName = "Service Reports";
    }
    getequipmentIOMData(apiNumber, projectId);
  }

  Future getequipmentIOMData(String apiNumber, String projectId) async {
    setState(() {
      isLoading = true;
    });
    EquipmentIOMApi equipmentIOMApi = EquipmentIOMApi();
    // List<EquipmentIOMData> list = [];
    await equipmentIOMApi.getEquipmentIOM(apiNumber, projectId).then((value) {
      var status = value.status;
      debugPrint("StartUp Date responce = $status");

      if (status == true) {
        setState(() {
          equipmentIomData = value.data;
        });
        // value.data?.forEach((element) {
        //   list.add(element);
        // });
      }
      if (value.data == null) {
        equipmentIomData = null;
      }
    });
    setState(() {
      isLoading = false;
      // equipmentIomData.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text(pageName),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? equipmentIomData != null
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    alignment: Alignment.center,
                    child: ListView.builder(
                        physics: PageScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: equipmentIomData.length,
                        // controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          // selectionIndex = i;
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            // color: Colors.blueAccent,
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            child: Center(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // if you need this
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                // color: Colors.greenAccent,
                                shadowColor: Color(0xff0BA2E4),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 27,
                                    bottom: 27,
                                    left: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${equipmentIomData[i].manufacture}",
                                        style: TextstyleConst
                                            .horizontalCardHeaderStyle,
                                      ),
                                      Text(
                                        "${equipmentIomData[i].product}",
                                        style: TextstyleConst
                                            .horizontalCardSubHeaderStyle,
                                      ),
                                      /* Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'profile-generic.png'),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),*/
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: richText(
                                            "Date : ",
                                            "${equipmentIomData[i].createdDate}",
                                            i),
                                      ),
                                      RichText(
                                        text: TextSpan(children: [
                                          /*TextSpan(
                                  text: "File Name : ",
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontFamily:
                                    StringConst.FONT_FAMILY,
                                  ),
                                ),*/
                                          WidgetSpan(
                                              child: Text(
                                            "File Name : ",
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          )),
                                          WidgetSpan(
                                              child: InkWell(
                                            onTap: () {
                                              openPdf(
                                                  "${equipmentIomData[i].pdfUrl}${equipmentIomData[i].submittalId}.${equipmentIomData[i].fileExtention}");
                                              debugPrint(
                                                  "tap url =-==== ${equipmentIomData[i].pdfUrl}${equipmentIomData[i].submittalId}.${equipmentIomData[i].fileExtention}");
                                            },
                                            child: Text(
                                              "${equipmentIomData[i].fileName}",
                                              style: TextStyle(
                                                color: Color(0xff0BA2E4),
                                                fontSize: 14,
                                                fontFamily:
                                                    StringConst.FONT_FAMILY,
                                              ),
                                            ),
                                          ))
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: richText(
                                                  "Tag : ",
                                                  "${equipmentIomData[i].tag}",
                                                  i),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: "View : ",
                                                  style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontSize: 14,
                                                    fontFamily:
                                                        StringConst.FONT_FAMILY,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: InkWell(
                                                    child: Icon(
                                                      Icons.description,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                    onTap: () {
                                                      openPdf(
                                                          "${equipmentIomData[i].pdfUrl}${equipmentIomData[i].submittalId}.${equipmentIomData[i].fileExtention}");
                                                      debugPrint(
                                                          "tap url =-==== ${equipmentIomData[i].pdfUrl}${equipmentIomData[i].submittalId}.${equipmentIomData[i].fileExtention}");
                                                    },
                                                    /*  onTap: () {
                                            downloadDocument(
                                                documentData[i].docId,
                                                documentData[i]
                                                    .fileExt);
                                            // https://ciright-documents.s3.amazonaws.com/'row.docId
                                          },*/
                                                  ),
                                                ),
                                              ])),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 48),
                                        child: Center(
                                          child: Text(
                                            "${i + 1}/${equipmentIomData.length}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "No Data to display",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                )
          : Visible(isLoading: isLoading, message: ""),
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

  RichText richText(String titleText, String responceText, int i) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: titleText,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        TextSpan(
          text: responceText,
          style: TextStyle(
            color: Color(0xff9A9A9A),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
      ]),
    );
  }

  RichText fileRichText(String titleText, String responceText, int i) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: titleText,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        TextSpan(
          text: responceText,
          style: TextStyle(
            color: Color(0xff0BA2E4),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
      ]),
    );
  }
}
