import 'package:bidbot/api/bid_inquiry/employee_bid_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/employee_bid_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeBids extends StatefulWidget {
  const EmployeeBids({Key key}) : super(key: key);

  @override
  _EmployeeBidsState createState() => _EmployeeBidsState();
}

class _EmployeeBidsState extends State<EmployeeBids> {
  bool isLoading = false;
  List<BidData> bidData = [];
  int selectionIndex = 0;

//  EmployeeBidRequest employeeBidRequest;

  @override
  void initState() {
    super.initState();
    employeeBidData();
  }

  Future employeeBidData() async {
    isLoading = true;
    DateTime now = DateTime.now();
    String toDayDate = DateFormat('MM/dd/yyyy').format(now);
    debugPrint("employee Bids toDayDate == $toDayDate");

    var employeeBidRequest = EmployeeBidRequest(
        employeeId: "${GlobalValues.loginEmployee.employeeId}",
        todayDate: toDayDate);
    var employeeBidsApi = EmployeeBidsApi();
    await employeeBidsApi.employeeBids(employeeBidRequest).then((value) {
      setState(() {
        bidData = value?.data;
        debugPrint("employee Bids responce == ${value?.status}");
        // return bidData;
        // debugPrint(
        //     "Employee Bid Responce projectName = ${bidData[0].projectName}");
      });
      // value.data.forEach((element) {});
    });

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('My Bids'),
        actions: [
          InkWell(
            child: Image.asset("asset/image/crossback.png"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GlobalValues.checkconection == true
          ? isLoading != true
              ? Container(
                  child: bidData != null
                      ? ListView.separated(
                          itemCount: bidData.length, //bidData.length
                          separatorBuilder: (context, i) {
                            return Divider(
                              height: 5,
                            );
                          },
                          itemBuilder: (context, i) {
                            return Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectionIndex = i;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${bidData[i].projectName}",
                                        style: TextStyle(
                                          color: Color(0xff9A9A9A),
                                          fontFamily: StringConst.FONT_FAMILY,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
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
                                                      text: TextSpan(children: [
                                                    TextSpan(
                                                      text: "Lead : ",
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
                                                          "${bidData[i].leadName}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9B9B9B),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    //bidData[i].leadName
                                                  ])),
                                                  RichText(
                                                      text: TextSpan(children: [
                                                    WidgetSpan(
                                                        child: Container(
                                                      child: Image.asset(
                                                          "asset/image/bidding/salePrice.png"),
                                                      // height: 30,
                                                      // width: 30,
                                                    )),
                                                    WidgetSpan(
                                                        child: SizedBox(
                                                      width: 5,
                                                    )),
                                                    TextSpan(
                                                      semanticsLabel: "Lead",
                                                      text:
                                                          "\$${bidData[i].salePrice}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9A9A9A),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    //bidData[i].salePrice
                                                  ])),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      selectionIndex == i
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text: "Support : ",
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontSize: 14,
                                                      fontFamily: StringConst
                                                          .FONT_FAMILY,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${bidData[i].supportName}",
                                                    style: TextStyle(
                                                      color: Color(0xff9B9B9B),
                                                      fontSize: 14,
                                                      fontFamily: StringConst
                                                          .FONT_FAMILY,
                                                    ),
                                                  ),
                                                  //bidData[i].leadName
                                                ])),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  WidgetSpan(
                                                      child: Container(
                                                    child: Image.asset(
                                                        "asset/image/bidding/marginPrice.png"),
                                                    // height: 30,
                                                    // width: 30,
                                                  )),
                                                  WidgetSpan(
                                                      child: SizedBox(
                                                    width: 5,
                                                  )),
                                                  TextSpan(
                                                    semanticsLabel: "Lead",
                                                    text:
                                                        "\$${bidData[i].margin}",
                                                    style: TextStyle(
                                                      color: Color(0xff9A9A9A),
                                                      fontSize: 14,
                                                      fontFamily: StringConst
                                                          .FONT_FAMILY,
                                                    ),
                                                  ),
                                                  //bidData[i].salePrice
                                                ])),
                                              ],
                                            )
                                          : Container(),
                                      selectionIndex == i
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 6,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RichText(
                                                      text: TextSpan(children: [
                                                    WidgetSpan(
                                                        child: Container(
                                                      child: Image.asset(
                                                          "asset/image/bidding/phase.png"),
                                                      // height: 30,
                                                      // width: 30,
                                                    )),
                                                    WidgetSpan(
                                                        child: SizedBox(
                                                      width: 5,
                                                    )),
                                                    TextSpan(
                                                      semanticsLabel: "Lead",
                                                      text:
                                                          "${bidData[i].phase}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9A9A9A),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    //bidData[i].salePrice
                                                  ])),
                                                  RichText(
                                                      text: TextSpan(children: [
                                                    WidgetSpan(
                                                        child: Container(
                                                      child: Image.asset(
                                                          "asset/image/bidding/subPhase.png"),
                                                      // height: 30,
                                                      // width: 30,
                                                    )),
                                                    WidgetSpan(
                                                        child: SizedBox(
                                                      width: 5,
                                                    )),
                                                    TextSpan(
                                                      semanticsLabel: "Lead",
                                                      text:
                                                          "${bidData[i].subPhase}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9A9A9A),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    //bidData[i].salePrice
                                                  ])),
                                                ],
                                              ),
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
                          child: Text('No Data to display'),
                        ),
                )
              : Visible(
                  isLoading: isLoading,
                  message: '',
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
            ),
    );

    //   Visible(isLoading: isLoading),
  }
}
