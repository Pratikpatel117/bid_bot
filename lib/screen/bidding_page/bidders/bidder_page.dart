import 'package:bidbot/api/bidding/bidders/bidder_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bidder/bidder_model.dart';
import 'package:flutter/material.dart';

import '../../../const/color_const.dart';
import '../../../const/style_const.dart';

class BiddersPage extends StatefulWidget {
  const BiddersPage({Key key}) : super(key: key);

  @override
  _BiddersPageState createState() => _BiddersPageState();
}

class _BiddersPageState extends State<BiddersPage> {
  bool isLoading = false;
  List<BidderData> listOfBidderData = [];
  BidderData bidderData;
  int selectionIndex = 0;
  String projectId = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.bidderData.projectId;
      debugPrint("fbhsdf===${BiddingGlobalValue.bidderData.projectId}");
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidlistBidder.projectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidBidder.projectId;
    }
    getBidderData();
  }

  Future getBidderData() async {
    isLoading = true;
    listOfBidderData.clear();
    var list = <BidderData>[];
    BidderApi bidderApi = BidderApi();
    await bidderApi.getBidderApi(projectId).then((value) {
      var bidderStatus = value.status;

      //  debugPrint("tokenValue ${value.data[0].userToken}");

      debugPrint("status of bidderApi on Page = $bidderStatus");

      value.data?.forEach((element) {
        list.add(element);
      });
    });

    setState(() {
      listOfBidderData.addAll(list);
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
        title: Text('Bidders'),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 11,
              top: 12,
              bottom: 10,
            ),
            alignment: Alignment.center,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: ColorConst.LoginButtonColor,
            ),
            width: 55,
            child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, "/QABPage");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'QAB',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ],
                )),
          ),
          TabRights.tabListData.any((element) => element.isAdd == 1)
              ? InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/addBidder");
                  },
                  child: Icon(
                    Icons.add_outlined,
                    size: 32,
                  ),
                )
              : Container(),
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: Column(
                  children: [
                    listOfBidderData.length != 0 && listOfBidderData != null
                        ? Expanded(
                            child: ListView.separated(
                                separatorBuilder: (context, i) {
                                  return Divider(
                                    height: 3,
                                    color: Colors.transparent,
                                  );
                                },
                                itemCount: listOfBidderData.length,
                                itemBuilder: (context, i) {
                                  listOfBidderData.sort((a, b) =>
                                      a.customer.compareTo(b.customer));
                                  return Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: Text(
                                              "${listOfBidderData[i].customer}",
                                              style: TextstyleConst
                                                  .biddingProjectTitle,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //customer name
                                                Expanded(
                                                  child: widgetWithText(
                                                      Icons.person,
                                                      " ${listOfBidderData[i].contact}",
                                                      Colors.blue),
                                                  flex: 1,
                                                ),
                                                // bid date
                                                Expanded(
                                                  child: widgetWithText(
                                                      Icons.event,
                                                      " ${listOfBidderData[i].bidDate}",
                                                      Colors.teal),
                                                  flex: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //bidDate
                                              Expanded(
                                                child: widgetWithText(
                                                    Icons.calendar_today,
                                                    " ${listOfBidderData[i].days}",
                                                    Colors.tealAccent),
                                                flex: 1,
                                              ),
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: "A/I : ",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 14,
                                                        fontFamily: StringConst
                                                            .FONT_FAMILY,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: listOfBidderData[i]
                                                                  .status ==
                                                              "1"
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
                                                    ),
                                                  ]),
                                                ),
                                                flex: 1,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6, bottom: 5),
                                            child: widgetWithText(
                                                Icons.mail,
                                                " ${listOfBidderData[i].contactEmailAddress}",
                                                Colors.orange),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "No Data to display",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          )
                  ],
                ),
              ),
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }

  RichText widgetWithText(
      IconData iconData, String stringText, Color iconColor) {
    return RichText(
        text: TextSpan(children: [
      WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Icon(
            iconData,
            size: 17,
            color: iconColor,
          ),
        ),
        style: TextStyle(
          color: Color(0xff000000),
          fontSize: 14,
          fontFamily: StringConst.FONT_FAMILY,
        ),
      ),
      TextSpan(
        text: stringText,
        style: TextStyle(
          color: Color(0xff9A9A9A),
          fontSize: 14,
          fontFamily: StringConst.FONT_FAMILY,
        ),
      ),
    ]));
  }
}
