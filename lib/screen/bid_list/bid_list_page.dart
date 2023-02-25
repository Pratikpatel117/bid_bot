import 'dart:async';

import 'package:bidbot/api/bid_list/bid_list_api.dart';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/api/project_info_api.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_list/bidlist_model.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../../const/function_const.dart';
import '../../tutorial_coach_mark.dart';
import '../bidding_page/project_information.dart';

class BidListPage extends StatefulWidget {
  const BidListPage({Key key}) : super(key: key);

  @override
  _BidListPageState createState() => _BidListPageState();
}

class _BidListPageState extends State<BidListPage> {
  BidListRequest bidListRequest;
  final listLimit = 5;
  final ScrollController scrollController = ScrollController();
  List<BidListData> bidListData = [];
  Timer _timer;
  String previousKeyword;
  int selectedIndex = 1;
  ProjectInformationData projectData;
  bool isLoading = true, isLoaded = false;

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
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
    getBidListData("");
    // _checkFirstCall();
    _checkFirstRun();
    print("conection global value in Bid list= ${GlobalValues.checkconection}");
    TabRights.extractIconMenuRides();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        debugPrint('Bidlist Api Printed Data Scroll ');
        getBidListData(previousKeyword);
        debugPrint('Scroll Activity Success');
      }
    });

    /*  /// Intro
    intro = Intro(
      stepCount: 2,
      maskClosable: true,
      onHighlightWidgetTap: (introStatus) {
        print(introStatus);
      },
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'Hello, Welcome to Bidbot..!',
          'Hello, Welcome to Bidbot..!',
        ],
        buttonTextBuilder: (currPage, totalPage) {
          return currPage < totalPage - 1 ? 'Next' : 'Finish';
        },
      ),
    );
    intro.setStepConfig(
      0,
      borderRadius: BorderRadius.circular(64),
    );
    debugPrint("Selection index== ${intro.keys}");*/
  }

  equipmentProposal(BidProjectList biddingForEquipment) async {
    setState(() {
      isLoading = true;
    });
    PdfApi pdfApi = PdfApi();
    String url =
        "https://www.myciright.com/Ciright/api/restpdf/proposaldetail/${biddingForEquipment.projectId}/7686051/324/${GlobalValues.loginEmployee.employeeId}/${GlobalValues.loginEmployee.sphereTypeId}";
    debugPrint("pdf Api CAll = $url");
    // debugPrint("projectId = $projectId");
    if (biddingForEquipment.url.isNotEmpty && biddingForEquipment.url != null) {
      final file = await pdfApi.getPdfUrl(biddingForEquipment.url);
      GlobalValues.pdfFile = file;
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, "/pdfView");
    } else {
      final file = await pdfApi.proposalPdf(url);
      GlobalValues.pdfFile = file;
      debugPrint("pdf Api CAll = $file");
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, "/pdfView");
    }

    /* setState(() {
      isLoading = false;
    });*/
  }

  bool checkIconsRights(String tabType) {
    bool isAvailable = false;
    for (int i = 0; i < TabRights.iconsBidding.length; i++) {
      TabData tab = TabRights.iconsBidding[i];
      if (tab.tabTypeUrl == tabType) {
        isAvailable = true;
        break;
      }
    }
    return isAvailable;
  }

  List<Widget> listOfIcons(BidProjectList bidlistProject) {
    List<Widget> list = [];
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-public-notes.htm')) {
      list.add(
        Container(
          child: InkWell(
            child: Image.asset(
              'asset/image/publicnote.png',
              key: keyButton,
            ),
            onTap: () {
              debugPrint("ProjectId=== ${bidlistProject.projectId}");
              BidListGlobalValue.bidListNoteProjectId =
                  bidlistProject.projectId;
              // BidlistGlobalValue.bidlistForNotes = bidlistProject;
              Navigator.pushNamed(context, "/notes");
            },
          ),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-line-item.htm')) {
      list.add(
        Container(
          child: InkWell(
            child: Image.asset(
              'asset/image/line_items.png',
              key: keyButton1,
            ),
            onTap: () {
              debugPrint("ProjectId=== ${bidlistProject.projectId}");
              BidListGlobalValue.bidListLineItemsProjectId =
                  bidlistProject.projectId;
              Navigator.pushNamed(context, "/lineItems");
            },
          ),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-proposal.htm')) {
      list.add(
        Container(
          child: InkWell(
            child: Image.asset(
              'asset/image/proposalnew.png',
              height: 23,
              width: 23,
              key: keyButton2,
            ),
            onTap: () {
              // BidListGlobalValue.bidListEquipmentProposal = bidlistProject;
              BidListGlobalValue.bidListEquipmentProjectName =
                  bidlistProject.projectName;
              equipmentProposal(bidlistProject);
            },
          ),
        ),
      );
    }
    if (checkIconsRights('bidlist-bidders.htm') == true) {
      list.add(
        Container(
          child: InkWell(
            child: Image.asset(
              'asset/image/bidders.png',
              key: keyButton4,
            ),
            onTap: () {
              BidListGlobalValue.bidlistBidder = bidlistProject;
              Navigator.pushNamed(context, "/bidder");
            },
          ),
        ),
      );
    }
    if (checkIconsRights('bidlist-players.htm') == true) {
      list.add(
        Container(
          child: InkWell(
            child: Image.asset(
              'asset/image/players.png',
              key: keyButton5,
            ),
            onTap: () {
              BidListGlobalValue.bidlistPlayer = bidlistProject;
              Navigator.pushNamed(context, "/player");
            },
          ),
        ),
      );
    }
    if (checkIconsRights('bidlist-files.htm') == true) {
      list.add(
        Container(
          child: InkWell(
            child: Image.asset(
              'asset/image/documents.png',
              key: keyButton3,
            ),
            onTap: () {
              BidListGlobalValue.bidListDocument = bidlistProject;
              debugPrint("ProjectId=== ${bidlistProject.projectId}");
              Navigator.pushNamed(context, "/document");
            },
          ),
        ),
      );
    }
    return list;
  }

  void searchWithThrottle(String keyword,
      {bool forceLoad = false, int throttleTime}) {
    _timer?.cancel();
    // if (keyword != previousKeyword && keyword.isNotEmpty) {
    previousKeyword = keyword;
    _timer =
        Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
      print("BidList Search Project Name: $keyword");
      getBidListData(keyword, forceLoad: forceLoad);
      _timer.cancel();
    });
    // }
  }

  Future getBidListData(String searchText, {bool forceLoad = false}) async {
    // var start = bidListData.isEmpty || forceLoad ? 0 : bidListData.length;
    setState(() {
      isLoading = true;
      if (bidListData.isEmpty || forceLoad) {
        bidListData.clear();
      }
    });
    debugPrint('get bidding called');
    DateTime now = DateTime.now();
    if (bidListData.isEmpty) {
      now = DateTime.now();
    } else {
      String date = bidListData.last.projectList.last.bidDate;
      // String dateWithT = 'MM/dd/yyyy';
      // DateTime dateTime = DateTime.parse(dateWithT);
      DateTime tempDate = new DateFormat('yyyy-mm-dd').parse(date); //MM/dd/yyyy
      now = tempDate;
    }
    String formattedDate = DateFormat('MM/dd/yyyy').format(now);

    bidListRequest = BidListRequest(
      projectName: searchText,
      employeeId: GlobalValues.loginEmployee.employeeId.toString(),
      startDate: formattedDate,
      limit: listLimit.toString(),
    );

    BidListApi bidListApi = BidListApi();
    bidListApi.getBidListApiData(bidListRequest).then((value) {
      var bool = value.status;
      debugPrint("BidList api call Status === $bool");
      debugPrint("BidList api data === ${value.data}");
      var list = <BidListData>[];
      if (bidListData.isEmpty || forceLoad) {
        bidListData.clear();
      }
      value.data?.forEach((element) {
        if (bidListData.any((sec) => sec.bidDate == element.bidDate)) {
        } else {
          list.add(element);
        }
      });
      setState(() {
        isLoading = false;
        bidListData.addAll(list);
      });
    });
  }

  Widget searchSort() {
    return Row(
      children: [
        Expanded(
          child: SearchTextFormField(
            searchWithThrottle: searchWithThrottle,
          ),
        ),
      ],
    );
  }

  getProjectInformation(String projectId) async {
    setState(() {
      isLoading = true;
    });
    ProjectInformationApi projectInformationApi = ProjectInformationApi();
    await projectInformationApi.getProjectInformation(projectId).then((value) {
      var projectResponce = value.status;
      debugPrint("get Profile Information responce = $projectResponce");
      debugPrint("get Profile Id = $projectId");
      if (projectResponce == true) {
        setState(() {
          projectData = value.data;
          ConstWidgets().onLoading(context, projectData);
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalValues.checkconection == true
        ? Stack(children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Bid List',
                    style: TextstyleConst.HeaderTitlePage,
                  ),
                ),
                searchSort(),
                bidListData.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('There are no Projects Bidding.'),
                      )
                    : Expanded(
                        child: ExpandableListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          //   padding: EdgeInsets.only(),
                          builder: SliverExpandableChildDelegate<BidProjectList,
                              BidListData>(
                            sectionList: bidListData,
                            headerBuilder: (context, selectIndex, i) {
                              String bid = bidListData[selectIndex].bidDate;
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        bid,
                                        style: TextstyleConst.ListTitleStyle,
                                      ),
                                      height: 38,
                                      alignment: Alignment.center,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Color(0xff262769),
                                          borderRadius:
                                              BorderRadius.circular(9)),
                                    ),
                                    Text(
                                      '${bidListData[selectIndex].projectList.length} Projects ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemBuilder:
                                (context, selectionIndex, itemIndex, i) {
                              List<BidProjectList> list =
                                  bidListData[selectionIndex].projectList;
                              String name = list[itemIndex].projectName;
                              /*  var sphereTypeId = GlobalValues.loginEmployee.sphereTypeId;
                  var isBidder = GlobalValues.biddingProjectListData.lastWhere((element) => true).isBidder;

                  var isMyCompanyBidder = GlobalValues.biddingProjectListData.lastWhere((element) => true).isMyCompanyBidder;

                  if (isBidder == null) {
                    isBidder = GlobalValues.isBidder.toString() ;
                    //  GlobalValues.isBidder = isBidder as int;
                  }
                  debugPrint("Isbidder in pass Value $isBidder");

                  if (isMyCompanyBidder ==null){
                    GlobalValues.isMyCompanyBidder = isMyCompanyBidder as int;
                  }
                  debugPrint("isMyCompanyBidder in pass Value ${isMyCompanyBidder}");*/

                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  child: Card(
                                    elevation: 2,
                                    child: Container(
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = i;
                                              debugPrint(
                                                  "selectedindex value = $selectedIndex && itemindex== $itemIndex & i val= $i & selection index = $selectionIndex");
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                /// start the intro
                                                /*   selectedIndex == 0
                                            ? intro.start(context)
                                            : null;*/
                                                _isFirstRun == true &&
                                                        selectedIndex == 1 &&
                                                        TooltipsGlobalValues
                                                                .bidListTip ==
                                                            true
                                                    ? Future.delayed(
                                                        Duration.zero,
                                                        showTutorial)
                                                    : null;
                                              });
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: 7,
                                              right: 6,
                                              left: 6,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: RichText(
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
                                                                              list[itemIndex].projectId,
                                                                          isLoading:
                                                                              isLoading,
                                                                        )
                                                                      : Container()),
                                                            ]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                selectedIndex == i
                                                    ? Align(
                                                        heightFactor: 1.5,
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 6),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: listOfIcons(
                                                                bidListData[selectionIndex]
                                                                        .projectList[
                                                                    itemIndex]),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
            Visibility(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/image/animation/bid-bot-loader-2.gif',
                      height: 150,
                      width: 150,
                    ),
                    Text('Loading Bid List...'),
                  ],
                ),
              ),
              visible: isLoading,
            ),
          ])
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
          TooltipsGlobalValues.bidListTip = false;
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
        setState(() {
          TooltipsGlobalValues.bidListTip = false;
        });
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
