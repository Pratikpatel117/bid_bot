import 'dart:async';

import 'package:bidbot/api/bidding/add_me_as_bidder_api.dart';
import 'package:bidbot/api/bidding/change_to_no_bid_api.dart';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/const/globals.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bidding_model.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:bidbot/screen/bidding_page/project_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../../const/color_const.dart';
import '../../model/bidding/add_me_as_bidder_model.dart';
import '../../tutorial_coach_mark.dart';

typedef ValueSetter<T> = Future Function(T value);
typedef ProjectBidDate<X> = Future Function(X bidDate);

class BiddingProjectList extends StatefulWidget {
  BiddingProjectList(
      {Key key,
      @required this.scrollController,
      @required this.sectionList,
      this.onPressedAddBidder,
      this.projectBidDate,
      this.onPressedForRemoveBid
      // @required this.reCallGetBidding,
      // @required this.addMeBidderTap,
      })
      : super(key: key);

  final ScrollController scrollController;
  final List<BiddingData> sectionList;
  final String projectBidDate;
  // final Function reCallBidding;
  final ValueSetter<String> onPressedAddBidder;
  final ValueSetter<String> onPressedForRemoveBid;
  // final  Future Function(String) reCallGetBidding;
  // bool addMeBidderTap;

  @override
  State<BiddingProjectList> createState() => _BiddingProjectListState();
}

class _BiddingProjectListState extends State<BiddingProjectList> {
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();

  String projectId;
  ProjectInformationData projectData;
  bool isLoading = false;
  String documentUrl;
  AddMeAsBidderRequest addMeAsBidderRequest;
  // final getXBox = GetStorage();

  bool _isFirstRun;

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
      debugPrint("First time Run app value = ${_isFirstRun}");
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("bidding_project list");
    _checkFirstRun();
  }

  Future changeToNoBid(String bidderId) async {
    ChangeToNoBidApi changeToNoBidApi = ChangeToNoBidApi();
    await changeToNoBidApi.ChangeToNoBid(bidderId).then((value) {
      var status = value.status;
      debugPrint("Remove Bids status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Bidder Successfully Removed"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // Navigator.popAndPushNamed(context, "/homePage",
        //     arguments: {"isLogin": false});
      } else {
        final snackBar = SnackBar(
          content: Text("Bidder Add Submittals Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future addMeAsBidderTap(String projectLink) {
    setState(() {
      isLoading = true;
      GlobalValues.addMeAsBidderTap = true;
    });
    /*  widget.addMeBidderTap = true;
    final getXBox = GetStorage();
    getXBox.write("bidderTap", widget.sectionList);*/
    addMeAsBidderRequest = AddMeAsBidderRequest(
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      appId: "${GlobalValues.appId}",
      link: projectLink,
    );
    AddMeAsBidderApi addMeAsBidderApi = AddMeAsBidderApi();
    addMeAsBidderApi.addMeAsBidderTap(addMeAsBidderRequest).then((value) {
      var status = value.status;
      debugPrint("update Submittals status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Bidder Added Successfully"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // widget.reCallGetBidding("$projectDate");
      } else {
        final snackBar = SnackBar(
          content: Text("Error while adding as a bidder"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    setState(() {
      isLoading = false;
      // GlobalValues.addMeAsBidderTap = false;
    });
  }

  equipmentProposal(ProjectList biddingForEquipment) async {
    PdfApi pdfApi = PdfApi();
    String url =
        "https://www.myciright.com/Ciright/api/restpdf/proposaldetail/${biddingForEquipment.projectId}/7686051/324/${GlobalValues.loginEmployee.employeeId}/${GlobalValues.loginEmployee.sphereTypeId}";
    debugPrint("pdf Api CAll = $url");
    // debugPrint("projectId = $projectId");
    if (biddingForEquipment.url.isNotEmpty && biddingForEquipment.url != null) {
      final file = await pdfApi.getPdfUrl(biddingForEquipment.url);
      GlobalValues.pdfFile = file;
      Navigator.pushNamed(context, "/pdfView");
    } else {
      final file = await pdfApi.proposalPdf(url);
      GlobalValues.pdfFile = file;
      debugPrint("pdf Api CAll = $file");
      Navigator.pushNamed(context, "/pdfView");
    }
    /* setState(() {
      isLoading = false;
    });*/
  }

  List<Widget> list = [];
  int selectedIndex = 1;

  List<Widget> listOfIcons(ProjectList biddingList) {
    List<Widget> list = [];
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-public-notes.htm')) {
      list.add(
        InkWell(
            onTap: () {
              debugPrint("ProjectId=== ${biddingList.projectId}");
              BiddingGlobalValue.biddingForNotes = biddingList;
              BiddingGlobalValue.biddingNoteProjectId = biddingList.projectId;
              Navigator.pushNamed(context, "/notes");
            },
            child: Image.asset(
              'asset/image/publicnote.png',
              key: keyButton,
            )),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-line-item.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/line_items.png',
          ),
          onTap: () {
            BiddingGlobalValue.biddingForLineItems = biddingList;
            BiddingGlobalValue.biddingLineItemsProjectId =
                biddingList.projectId;
            Navigator.pushNamed(context, "/lineItems");
          },
          key: keyButton1,
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-proposal.htm')) {
      //https://www.myciright.com/Ciright/api/restpdf/proposaldetail/'projectId'/7686051/324/'employeeId'/'sphereTypeId
      list.add(
        InkWell(
          onTap: () {
            equipmentProposal(biddingList);
            BiddingGlobalValue.equipmentProposal = biddingList;
          },
          child: Image.asset(
            'asset/image/proposalnew.png',
            height: 23,
            width: 23,
            key: keyButton2,
          ),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-bidders.htm')) {
      list.add(
        InkWell(
          onTap: () {
            BiddingGlobalValue.bidderData = biddingList;
            Navigator.pushNamed(context, "/bidder");
          },
          child: Image.asset(
            'asset/image/bidders.png',
            height: 23,
            width: 23,
            key: keyButton4,
          ),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-players.htm')) {
      list.add(
        InkWell(
            onTap: () {
              BiddingGlobalValue.playerData = biddingList;
              Navigator.pushNamed(context, "/player");
            },
            child: Image.asset(
              'asset/image/players.png',
              key: keyButton5,
            )),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-files.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/documents.png',
            key: keyButton3,
          ),
          onTap: () {
            BiddingGlobalValue.documentData = biddingList;
            debugPrint("document projectId = ${biddingList.projectId}");
            Navigator.pushNamed(context, "/document");
          },
        ),
      );
    }
/*
   if (TabRights.tabListData.any(
*/

/*    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-update-proposal.htm')) {
      list.add(
        InkWell(
          onTap: () {
            Navigator.popAndPushNamed(context, "/updateProposal");
            BiddingGlobalValue.updateProposal = biddingList;
          },
          child: Image.asset(
            'asset/image/update-proposal.png',
            width: 23,
            height: 23,
          ),
        ),
      );
    }*/
    return list;
  }

  void _noBidInfo(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text(
              'This Project is No Bid For [ TriState HVAC Equipment, LLP ]',
              style: TextStyle(fontSize: 15),
            ),
            //content: const Text('Are you sure to Bidding this Job ?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
                isDefaultAction: true,
                isDestructiveAction: true,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalValues.checkconection == true
        ? isLoading != true
            ? Expanded(
                child: ExpandableListView(
                  controller: widget.scrollController,
                  shrinkWrap: true,
                  //   padding: EdgeInsets.only(),
                  builder:
                      SliverExpandableChildDelegate<ProjectList, BiddingData>(
                    removeItemsOnCollapsed: true,
                    sectionList: widget.sectionList,
                    headerBuilder: (context, selectIndex, i) {
                      String bid = widget.sectionList[selectIndex].bidDate;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                bid,
                                textAlign: TextAlign.center,
                                style: TextstyleConst.ListTitleStyle,
                              ),
                              height: 38,
                              alignment: Alignment.center,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Color(0xff262769),
                                  borderRadius: BorderRadius.circular(9)),
                            ),
                            Text(
                              '${widget.sectionList[selectIndex].projectList.length} Projects ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    },
                    itemBuilder: (context, selectionIndex, itemIndex, i) {
                      List<ProjectList> list =
                          widget.sectionList[selectionIndex].projectList;
                      String name = list[itemIndex].projectName;
                      var sphereTypeId =
                          GlobalValues.loginEmployee.sphereTypeId;
                      var isBidder = list[itemIndex].isBidder;
                      var isMyCompanyBidder = list[itemIndex].isMyCompanyBidder;
                      var isNotBidding = list[itemIndex].isNotBidding;
                      var listProjectId = list[itemIndex].projectId;

                      var bidDate = widget.sectionList[selectionIndex]
                          .projectList[itemIndex].bidDate;
                      var projectLink = widget.sectionList[selectionIndex]
                          .projectList[itemIndex].link;
                      // DateTime tempDate = new DateFormat('MM/dd/yyyy').parse("${widget.sectionList[selectionIndex].bidDate}");
                      // String formattedDate = DateFormat('MM/dd/yyyy').format(tempDate);

                      // var dateTime = DateFormat('mm-dd-yyyy').parse("${widget.sectionList[selectionIndex].bidDate}");
                      // var bidDate = DateFormat('mm-dd-yyyy').format(dateTime);

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Card(
                            elevation: 2,
                            // color: Colors.white24,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // selectedIndex = selectionIndex;
                                    // selectedIndex = itemIndex;
                                    selectedIndex = i;
                                    debugPrint(
                                        "project link ${list[itemIndex].link} ");
                                    debugPrint(
                                        "isBidder index == ${list[itemIndex].projectId}");
                                    debugPrint(
                                        "index value = $selectedIndex && itemindex== $itemIndex & i val= $i & selection index = $selectionIndex");

                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      /// start the intro
                                      /*           selectionIndex == 0
                                      ? intro.start(context)
                                      : null;*/
                                      /* selectedIndex == 1 &&
                                          itemIndex == 0 &&
                                          selectionIndex == 0 &&
                                          i == 1
                                      ?*/
                                      _isFirstRun == true &&
                                              selectedIndex == 1 &&
                                              TooltipsGlobalValues.biddingTip ==
                                                  true
                                          ? Future.delayed(
                                              Duration.zero, showTutorial)
                                          : null;
                                      /* : null;*/
                                    });
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    //    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                              child: RichText(
                                            // textDirection: TextDirection.LTR,
                                            textAlign: TextAlign.left,
                                            maxLines: 5,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: name,
                                                  style: TextstyleConst
                                                      .ListTextStyle,
                                                ),
                                                WidgetSpan(
                                                  child: GlobalValues
                                                              .loginEmployee
                                                              .sphereTypeId ==
                                                          1
                                                      ? ProjectInformationButton(
                                                          projectId:
                                                              listProjectId,
                                                          isLoading: isLoading,
                                                        )
                                                      : Container(),
                                                ),
                                                WidgetSpan(
                                                  child: TabRights.tabListData
                                                              .any((element) =>
                                                                  element
                                                                      .tabTypeUrl ==
                                                                  'bidlist-company-bidding.htm') &&
                                                          isMyCompanyBidder ==
                                                              "1"
                                                      ? Container(
                                                          // color: Colors.redAccent,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 5,
                                                          ),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            size: 22,
                                                            color: Colors
                                                                .green[800],
                                                          ))
                                                      : Container(),
                                                ),
                                                WidgetSpan(
                                                  child: isNotBidding == "1"
                                                      ? Container(
                                                          // color: Colors.greenAccent,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: InkWell(
                                                            onTap: () {
                                                              _noBidInfo(
                                                                  context);
                                                              debugPrint(
                                                                  "This Project is No Bid for(TriState HVAC Equipment, LLP)");
                                                            },
                                                            child: Icon(
                                                              Icons.cancel,
                                                              color: Colors
                                                                  .red[800],
                                                              size: 22,
                                                            ),
                                                          ))
                                                      : Container(),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                      //Remove Bid Button
                                      Container(
                                        //color: Colors.greenAccent,
                                        padding: EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 6,
                                            ),
                                            (isBidder == "1" &&
                                                    TabRights.tabListData.any(
                                                        (element) =>
                                                            element
                                                                .tabTypeUrl ==
                                                            'bidlist-add-me-as-a-bidder.htm'))
                                                ? Align(
                                                    heightFactor: 1.2,
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            GlobalValues
                                                                    .addMeAsBidderTap =
                                                                true;
                                                            /* changeToNoBid(
                                                            list[itemIndex]
                                                                .bidderId);*/
                                                            GlobalValues
                                                                    .bidDateForBiddingStatus =
                                                                bidDate;
                                                            widget.onPressedForRemoveBid(
                                                                "${list[itemIndex].bidderId}");
                                                            widget.sectionList
                                                                .clear();
                                                            debugPrint(
                                                                "bidder bid date == $bidDate");
                                                          });
                                                        },
                                                        child:
                                                            BidderStatusButton(
                                                          buttonName:
                                                              "Change To No Bid",
                                                          colorCode: 0xffE67442,
                                                        )),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),

                                      //add me as a bidder
                                      (isBidder == "0" &&
                                              sphereTypeId == 2 &&
                                              TabRights.tabListData.any((element) =>
                                                  element.tabTypeUrl ==
                                                  'bidlist-add-me-as-a-bidder.htm')) //isBidder is InComplete
                                          ? Align(
                                              heightFactor: 1.5,
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    GlobalValues
                                                            .addMeAsBidderTap =
                                                        true;
                                                    GlobalValues
                                                            .bidDateForBiddingStatus =
                                                        bidDate;
                                                    widget.onPressedAddBidder(
                                                        "$projectLink");
                                                    debugPrint(
                                                        "bidder bid date == $bidDate");
                                                    // addMeAsBidderTap(
                                                    //     "${list[itemIndex].link}");
                                                    // addAndRemoveBidsTap = true;
                                                    // widget.sectionList.clear();
                                                    // widget.projectBidDate = bidDate;
                                                  });
                                                },
                                                child: BidderStatusButton(
                                                  colorCode: 0xff298be0,
                                                  buttonName:
                                                      "Add me as a Bidder",
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      selectedIndex == i
                                          ? Align(
                                              heightFactor: 1.0,
                                              alignment: Alignment.bottomRight,
                                              child: (isBidder == "1" &&
                                                          sphereTypeId == 2) ||
                                                      sphereTypeId == 1
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 6),
                                                      // color: Colors.greenAccent,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: listOfIcons(
                                                            list[itemIndex]),
                                                      ),
                                                    )
                                                  : Container(),
                                            )
                                          : Container(
                                              height: 0,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              )
            : Visible(isLoading: isLoading, message: "")
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

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black12,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        setState(() {
          TooltipsGlobalValues.biddingTip = false;
        });
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        TooltipsGlobalValues.biddingTip = false;
        print("skip");
      },
    )..show();
  }

  void initTargets() {
    targets.clear();

    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Notes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Public, Private and Semi-Privates Notes. Private Only you can see, Semi-Private You and Your Cowerkers ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton1,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Line Items",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "It's Define list of Equipment Line Items..!",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: keyButton2,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Proposal",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    "It can show Project Equipment Proposal in Document ...! ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyButton3,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Docs",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Project Files; Documents, Project Files, Videos, Etc ...!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
      shape: ShapeLightFocus.RRect,
    ));

    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: keyButton4,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bidders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Show identifieds Bidders , Add Bidders , Quick Add Bidders And share with other Bidders",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(TargetFocus(
      identify: "Target 5",
      keyTarget: keyButton5,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Players",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Using This You can Show Project Players List ...!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }
}

class BidderStatusButton extends StatelessWidget {
  const BidderStatusButton({Key key, this.colorCode, this.buttonName})
      : super(key: key);
  final String buttonName;
  final int colorCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width / 2.2,
      padding: EdgeInsets.only(right: 8, left: 8),
      // margin: EdgeInsets.only(right: 7),
      decoration: BoxDecoration(
        color: Color(colorCode),
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(buttonName,
          style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: StringConst.FONT_FAMILY,
              fontWeight: FontWeight.bold)),
    );
  }
}
