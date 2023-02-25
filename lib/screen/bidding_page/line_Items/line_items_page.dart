// ignore_for_file: missing_return

import 'package:bidbot/api/bidding/line_Items/line_item_api.dart';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/line_Items/line_items_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineItems extends StatefulWidget {
  const LineItems({Key key}) : super(key: key);

  @override
  _LineItemsState createState() => _LineItemsState();
}

class _LineItemsState extends State<LineItems> {
  bool isLoading = false;
  LineItemData lineItemData;

  /* double pricenumber =lineItemData.totalSalesPrice; */
  List<LineItemsProjectList> lineItemsProjectList = [];
  LineItemsDisplayProposalRequest displayProposalRequest;
  int selectionIndex = 0;
  bool isDisplayProposal;
  String projectId = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.biddingLineItemsProjectId;
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidListLineItemsProjectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidLineItemsProjectId;
    } else if (GlobalValues.selectedBidIndex == 3) {
      projectId = ActiveProjectGlobalValue.activeProjectLineItemProjectId;
    }
    getLineItemsData();
  }

  Future getLineItemsData() async {
    isLoading = true;
    var list = <LineItemsProjectList>[];
    LineItemsApi lineItemsApi = LineItemsApi();

    await lineItemsApi.getLineItemsApi("$projectId").then((value) {
      setState(() {
        var apiStatus = value?.status;
        lineItemData = value?.data;
        value.data?.projectList?.forEach((element) {
          list.add(element);
          debugPrint("LineItems Status == $element");
        });
        debugPrint("LineItems Status == $apiStatus");
      });
    });
    setState(() {
      isLoading = false;
      lineItemsProjectList.addAll(list);
      // manageBidData.addAll(list);
      // debugPrint("manage Bid resquest status on init == $manageBidData");
    });
  }

  Future displayProposal(LineItemsProjectList lineItemsProjectList) async {
    setState(() {
      isLoading = true;
    });
    displayProposalRequest = LineItemsDisplayProposalRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      isDisplayProposal:
          lineItemsProjectList.isDisplayProposal == "1" ? "0" : "1",
    );
    LineItemsApi lineItemsApi = LineItemsApi();
    await lineItemsApi
        .updateDisplayProposal(
            displayProposalRequest, "${lineItemsProjectList.item}")
        .then((value) {
      var updateResult = value.status;
      isDisplayProposal = value.status;
      if (isDisplayProposal == true) {
        if (lineItemsProjectList.isDisplayProposal == "1") {
          lineItemsProjectList.isDisplayProposal = "0";
        } else if (lineItemsProjectList.isDisplayProposal == "0") {
          lineItemsProjectList.isDisplayProposal = "1";
        }
      }
      // if(lineItemsProjectList.isDisplayProposal == "1"){
      //   isDisplayProposal = false;
      // } else if(lineItemsProjectList.isDisplayProposal == "0"){
      //   isDisplayProposal = true;
      // }
      debugPrint('update Display Proposal code =====  $updateResult');
      if (updateResult == true) {
        final snacbar = SnackBar(
          content: Text("Display Proposal Successfully change"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
        // Navigator.pop(context);
        // setState(() {
        // getProfileData();
        // });
      } else {
        final snacbar = SnackBar(
          content: Text("Display Proposal did not change"),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Line Items'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: lineItemsProjectList.isNotEmpty
                  ? Column(
                      children: [
                        lineItemData.totalSalesPrice != null &&
                                lineItemData.totalSalesPrice != "null"
                            ? Container(
                                child:
                                    GlobalValues.loginEmployee.sphereTypeId == 1
                                        ? RichText(
                                            text: TextSpan(children: [
                                            TextSpan(
                                                text: "Total Sale Price : ",
                                                style: TextStyle(
                                                    color: Color(0xff0098D4),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 22)),
                                            TextSpan(
                                                text: lineItemData
                                                                .totalSalesPrice !=
                                                            null &&
                                                        lineItemData
                                                                .totalSalesPrice !=
                                                            "null"
                                                    ? "${NumberFormat.simpleCurrency().format(double.parse(lineItemData.totalSalesPrice))}"
                                                    : " ",
                                                style: TextStyle(
                                                    color: Color(0xff0098D4),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 22)),
                                          ]))
                                        : Container())
                            : Container(),
                        Expanded(
                          child: ListView.separated(
                            itemCount: lineItemsProjectList.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                /*  onTap: () {
                                  setState(() {
                                    */ /*  debugPrint(
                                        "${NumberFormat.simpleCurrency().format(double.parse(lineItemData.totalSalesPrice))}");*/ /*
                                    selectionIndex = i;
                                  });
                                },*/
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${lineItemsProjectList[i].manufacturer}",
                                          style: TextStyle(
                                            color: Color(0xff9A9A9A),
                                            fontFamily: StringConst.FONT_FAMILY,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "${lineItemsProjectList[i].product}",
                                          style: TextStyle(
                                            color: Color(0xff9A9A9A),
                                            fontFamily: StringConst.FONT_FAMILY,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        /* selectionIndex == i
                                            ?*/
                                        /*   Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7),),*/
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: "Tag : ",
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${lineItemsProjectList[i].tag}",
                                            style: TextStyle(
                                              color: Color(0xff9A9A9A),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          ),
                                        ])),

                                        /*  : Container(),
                                        selectionIndex == i
                                            ?*/
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Quantity : ',
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${lineItemsProjectList[i].qty}",
                                            style: TextStyle(
                                              color: Color(0xff9A9A9A),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          ),
                                        ])),
                                        /*    : Container(),
                                        selectionIndex == i &&*/
                                        GlobalValues.loginEmployee
                                                    .sphereTypeId ==
                                                1
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Display Proposal : ",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      StringConst
                                                                          .FONT_FAMILY,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        displayProposal(
                                                                            lineItemsProjectList[i]);
                                                                        debugPrint(
                                                                            "is line Project Equipment Id == ${lineItemsProjectList[i].item}");
                                                                        debugPrint(
                                                                            "is line Project Equipment Id == ${lineItemsProjectList[i].isDisplayProposal}");
                                                                      });
                                                                    },
                                                                    child: lineItemsProjectList[i].isDisplayProposal ==
                                                                            "1"
                                                                        ? Icon(
                                                                            Icons.check_circle,
                                                                            size:
                                                                                17,
                                                                            color:
                                                                                Colors.greenAccent,
                                                                          )
                                                                        : Icon(
                                                                            Icons.cancel,
                                                                            color:
                                                                                Colors.redAccent,
                                                                            size:
                                                                                17,
                                                                          )),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                    (TabRights.tabListData.any(
                                                            (element) =>
                                                                element
                                                                    .tabTypeUrl ==
                                                                'bldlist-ship-date-required.htm'))
                                                        ? Expanded(
                                                            flex: 1,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "Ship Date Required : ",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            StringConst.FONT_FAMILY,
                                                                      ),
                                                                    ),
                                                                    WidgetSpan(
                                                                      child:
                                                                          Icon(
                                                                        lineItemsProjectList[i].isShipDateRequierd ==
                                                                                "1"
                                                                            ? Icons.check_circle
                                                                            : Icons.cancel,
                                                                        color: lineItemsProjectList[i].isShipDateRequierd ==
                                                                                "1"
                                                                            ? Colors.greenAccent
                                                                            : Colors.redAccent,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                    )
                                                                  ]),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        /*  selectionIndex == i
                                            ?*/
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: "Drawings : ",
                                              style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 14,
                                                fontFamily:
                                                    StringConst.FONT_FAMILY,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Row(
                                                children: lineItemsProjectList[
                                                                    i]
                                                                .equipmentDrawingUrls
                                                                ?.length !=
                                                            0 &&
                                                        lineItemsProjectList[i]
                                                                .equipmentDrawingUrls !=
                                                            null
                                                    ? drawingItems(
                                                        lineItemsProjectList[i])
                                                    : [],
                                              ),
                                            ),
                                          ]),
                                        ),
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Status : ',
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${lineItemsProjectList[i].equipmentStatus}",
                                            style: TextStyle(
                                              color: Color(0xff9A9A9A),
                                              fontSize: 14,
                                              fontFamily:
                                                  StringConst.FONT_FAMILY,
                                            ),
                                          ),
                                        ])),
                                        //: Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, i) {
                              return Divider(
                                height: 4,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Text(
                      "No data to display",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }

  List<Widget> drawingItems(LineItemsProjectList projectList) {
    List<Widget> list = [];
    projectList.equipmentDrawingUrls.forEach((element) {
      list.add(
        InkWell(
          onTap: () {
            documentOpen(element);
          },
          child: Icon(
            Icons.description,
            size: 17,
          ),
        ),
      );
      return list;
    });
    /* documentOpen(dynamic url)  async{
      PdfApi pdfApi = PdfApi();
      final file = await pdfApi.getPdfUrl(url);
      GlobalValues.pdfFile = file;
      Navigator.pushNamed(context, "/pdfView");
    }*/
  }

  documentOpen(dynamic url) async {
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
