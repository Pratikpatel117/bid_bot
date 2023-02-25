import 'package:bidbot/api/bid_inquiry/manage_bid_inquiry_api.dart';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/manage_bid_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageBidRequest extends StatefulWidget {
  const ManageBidRequest({Key key}) : super(key: key);

  @override
  _ManageBidRequestState createState() => _ManageBidRequestState();
}

class _ManageBidRequestState extends State<ManageBidRequest> {
  bool isLoading = false;
  int selectionIndex = 0;
  List<ManageBidData> manageBidData = [];

  @override
  void initState() {
    super.initState();
    getManageBidRequest();
  }

  Future getManageBidRequest() async {
    isLoading = true;
    var list = <ManageBidData>[];
    ManageBidInquiryApi manageBidInquiryApi = ManageBidInquiryApi();
    await manageBidInquiryApi.manageBidInquiry().then((value) {
      // var data = value.status;
      // debugPrint("manage Bid request status on init == $data");
      value.data?.forEach((element) {
        list.add(element);
      });

      /*  if (data == true) {
        setState(() {
          manageBidData = value.data;
        });
      }*/
    });
    setState(() {
      isLoading = false;
      manageBidData.addAll(list);
      // debugPrint("manage Bid resquest status on init == $manageBidData");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalValues.checkconection == true
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff252669),
              leading: Container(),
              titleSpacing: -30,
              title: Text('Manage Inquires'),
              actions: [
                InkWell(
                  child: Image.asset("asset/image/crossback.png"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: isLoading != true
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: manageBidData.isNotEmpty
                        ? ListView.separated(
                            itemCount: manageBidData.length,
                            separatorBuilder: (context, i) {
                              return Divider(
                                height: 5,
                              );
                            },
                            itemBuilder: (context, i) {
                              return Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 6, bottom: 6),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectionIndex = i;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${manageBidData[i].projectName}",
                                                style: TextStyle(
                                                  color: Color(0xff9A9A9A),
                                                  fontFamily:
                                                      StringConst.FONT_FAMILY,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        selectionIndex == i
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text: "BidDate : ",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontSize: 14,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${manageBidData[i].estimatedBidDate}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff9B9B9B),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                      //bidData[i].leadName
                                                    ])),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        semanticsLabel: "Lead",
                                                        text:
                                                            "Confidential Project",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                      WidgetSpan(
                                                          child: SizedBox(
                                                        width: 5,
                                                      )),
                                                      WidgetSpan(
                                                        child: Container(
                                                          child: manageBidData[
                                                                          i]
                                                                      .isConfidentialPrivateProject ==
                                                                  1
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .greenAccent,
                                                                  size: 17,
                                                                )
                                                              : Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .redAccent,
                                                                  size: 17,
                                                                ),
                                                          // height: 30,
                                                          // width: 30,
                                                        ),
                                                      ),
                                                    ])),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text: "Created By : ",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${manageBidData[i].createdBy}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff9B9B9B),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                    ])),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        semanticsLabel: "Lead",
                                                        text:
                                                            "Equipment Replacement",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                      WidgetSpan(
                                                          child: SizedBox(
                                                        width: 5,
                                                      )),
                                                      WidgetSpan(
                                                        child: Container(
                                                          child: manageBidData[
                                                                          i]
                                                                      .isEquipmentReplacement ==
                                                                  1
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 17,
                                                                  color: Colors
                                                                      .greenAccent,
                                                                )
                                                              : Icon(
                                                                  Icons.cancel,
                                                                  size: 17,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                          // height: 30,
                                                          // width: 30,
                                                        ),
                                                      ),
                                                      //bidData[i].salePrice
                                                    ])),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      WidgetSpan(
                                                          child: Text(
                                                              "Attachment : ")),
                                                      WidgetSpan(
                                                        child:
                                                            getAttachmentIcons(
                                                                manageBidData[
                                                                    i]),
                                                      ),
                                                      //bidData[i].salePrice
                                                    ])),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                              semanticsLabel:
                                                                  "Lead",
                                                              text:
                                                                  "Part Price Request",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff000000),
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    StringConst
                                                                        .FONT_FAMILY,
                                                              ),
                                                            ),
                                                            WidgetSpan(
                                                                child: SizedBox(
                                                              width: 5,
                                                            )),
                                                            WidgetSpan(
                                                              child: Container(
                                                                child: manageBidData[i]
                                                                            .isPartsPriceRequest ==
                                                                        1
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        size:
                                                                            17,
                                                                        color: Colors
                                                                            .greenAccent,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .redAccent,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                // height: 30,
                                                                // width: 30,
                                                              ),
                                                            ),
                                                            //bidData[i].salePrice
                                                          ])),
                                                    ]),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text: "Created Date : ",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${manageBidData[i].createdDate}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff9B9B9B),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              StringConst
                                                                  .FONT_FAMILY,
                                                        ),
                                                      ),
                                                    ])),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        selectionIndex == i
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6,
                                                    bottom: 6,
                                                    left: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: WidgetSpan(
                                                          child: InkWell(
                                                            onTap: () {
                                                              GlobalValues
                                                                      .reviewRequestData =
                                                                  manageBidData[
                                                                      i];
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/createNewProject',
                                                                  arguments: {
                                                                    "projectId":
                                                                        true,
                                                                  });
                                                            },
                                                            child: Container(
                                                              height: 25,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.2,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(
                                                                          0xff252669),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      // border: Border.fromBorderSide(BorderSide(color: Color(0xff252669), width: 3)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                              child: Text(
                                                                'Review Request',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'No Data to display',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                  )
                : Visible(isLoading: isLoading, message: ""),
          )
        : Center(
            child: CupertinoAlertDialog(
              title: const Icon(
                Icons.wifi_off_outlined,
                color: Colors.black,
                size: 50,
              ),
              content: const Text('No Internet Connection!'),
            ),
          );
  }

  Widget getAttachmentIcons(ManageBidData manageBidData) {
    return manageBidData.attachmentUrls?.length != 0 &&
            manageBidData.attachmentUrls != null
        ? Row(
            children: showAttachDocument(manageBidData),
          )
        : Container();
  }

  List<Widget> showAttachDocument(ManageBidData manageBidData) {
    List<Widget> list = [];
    // manageBidData.attachmentUrls.forEach((element) => list.add(element));
    // manageBidData.attachmentUrls.
    //  manageBidData.attachmentUrls.length = list.length;
    manageBidData.attachmentUrls.forEach((element) {
      list.add(
        InkWell(
          onTap: () {
            openPdf(element);
            // element;
            // manageBidData.attachmentUrls.forEach((element) { });
          },
          child: Icon(
            Icons.description,
            size: 17,
          ),
        ),
      );
      debugPrint("List Elements Items ===$element ");
    });

    //  manageBidData.attachmentUrls.addAll(list);
    return list;
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
/* TextSpan(
                                                  semanticsLabel: "Lead",
                                                  text: manageBidData[i]
                                                              .attachmentUrls !=
                                                          null
                                                      ? "${manageBidData[i].attachmentUrls.join(",").split("/").last}" //.toString().split("/").last
                                                      : "",
                                                  style: TextStyle(
                                                    color: Color(0xff9A9A9A),
                                                    fontSize: 14,
                                                    fontFamily:
                                                        StringConst.FONT_FAMILY,
                                                  ),
                                                ),*/
