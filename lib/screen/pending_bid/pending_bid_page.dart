import 'dart:async';
import 'package:bidbot/api/pdf_view_api.dart';
import 'package:bidbot/api/pending_project/pending_project_api.dart';
import 'package:bidbot/api/project_info_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_list/bidlist_model.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:bidbot/model/pending_bids/pending_bids_model.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../../api/panding_bids/pending_bids_jobmail_api.dart';
import '../../const/function_const.dart';

import '../../tutorial_coach_mark.dart';
import '../bidding_page/project_information.dart';

class PendingBidPage extends StatefulWidget {
  const PendingBidPage({Key key}) : super(key: key);

  @override
  _PendingBidPageState createState() => _PendingBidPageState();
}

class _PendingBidPageState extends State<PendingBidPage> {
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  GlobalKey keyButton6 = GlobalKey();
  GlobalKey keyButton7 = GlobalKey();

  var projectName = '';
  BidListRequest bidListRequest;
  final listLimit = 50;
  final ScrollController scrollController = ScrollController();
  List<BidListData> pendingProject = [];
  Timer _timer;
  bool _isShown = true;
  String previousKeyword;
  int selectedIndex = 1;
  ProjectInformationData projectData;
  ShowMessageGetJob showMessageGetJob;
  bool _isFirstRun;

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
      debugPrint("First time Run app value = ${_isFirstRun}");
    });
  }

  Future messageGotThisJobData() async {
    GetJobMessageApi getJobMessageApi = GetJobMessageApi();
    setState(() {
      isLoading = true;
    });
    showMessageGetJob = ShowMessageGetJob(
      customerId: "${GlobalValues.loginEmployee.customerId}",
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: "${PendingBidGlobalValue.pendingBidWeGotThisJobProjectId}",
    );
    debugPrint(
        "ProjectId === ${PendingBidGlobalValue.pendingBidWeGotThisJobProjectId}");
    await getJobMessageApi
        .getpenddingbidmessage(showMessageGetJob)
        .then((value) {
      var status = value.status;
      debugPrint("Pass Message Status == $status");
      if (status == true) {
        debugPrint("You are successfully bidding on this job");
        final snackBar = SnackBar(
          content: Text("You are successfully bidding on this job"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.popAndPushNamed(context, "/homePage",
            arguments: {"isLogin": false});
        setState(() {
          isLoading = false;
        });
      } else if (status == null) {
        debugPrint("Error while biding on job");
        final snackBar = SnackBar(
          content: Text("Error while biding on job"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future messageOutThisJobData() async {
    GetJobMessageApi getJobMessageApi = GetJobMessageApi();
    setState(() {
      isLoading = true;
    });
    showMessageGetJob = ShowMessageGetJob(
      customerId: "${GlobalValues.loginEmployee.customerId}",
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: "${PendingBidGlobalValue.pendingBidWeOutThisJobProjectId}",
    );
    debugPrint(
        "ProjectId === ${PendingBidGlobalValue.pendingBidWeOutThisJobProjectId}");
    await getJobMessageApi
        .sendoutthisjobdmessage(showMessageGetJob)
        .then((value) {
      var status = value.status;
      debugPrint("Message Status == $status");

      if (status == true) {
        debugPrint("You are out of this job");
        final snackBar = SnackBar(
          content: Text("You are out of this job"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.popAndPushNamed(context, "/homePage",
            arguments: {"isLogin": false});
        setState(() {
          isLoading = false;
        });
      } else if (status == null) {
        debugPrint("Error while remove bidding on job");
        final snackBar = SnackBar(
          content: Text("Error while remove bidding on job"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkFirstRun();

    getPendingProject("");
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        debugPrint('Pending Project Printed Data Scroll');
        getPendingProject(previousKeyword);
        debugPrint('Scroll Activity Success');
      }
    });
  }

  Future equipmentProposal(BidProjectList biddingForEquipment) async {
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

  List<Widget> listOfIcons(BidProjectList pendingProjectList) {
    List<Widget> list = [];
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-we-got-this-job.htm')) {
      list.add(
        Container(
          height: 23,
          width: 23,
          child: InkWell(
            onTap: () {
              PendingBidGlobalValue.pendingBidWeGotThisJobProjectId =
                  pendingProjectList.projectId;
              _GetJob(context);
            },
            child: Image.asset(
              'asset/image/Wegotthisjob.png',
              height: 23,
              width: 23,
              key: keyButton4,
            ),
          ),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-we-are-out.htm')) {
      list.add(
        Container(
          height: 23,
          width: 23,
          child: InkWell(
            onTap: () {
              _delete(context);
              PendingBidGlobalValue.pendingBidWeOutThisJobProjectId =
                  pendingProjectList.projectId;
            },
            child: Image.asset(
              'asset/image/OUT.png',
              height: 23,
              width: 23,
              key: keyButton5,
            ),
          ),
        ),
      );
    }
    if (TabRights.tabListData.any((element) =>
        element.tabTypeUrl == 'bidlist-message-your-salesman.htm')) {
      list.add(
        Image.asset(
          'asset/image/Securedchats.png',
          height: 23,
          width: 23,
          key: keyButton7,
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-public-notes.htm')) {
      list.add(
        Container(
          height: 23,
          width: 23,
          child: InkWell(
            child: Image.asset(
              'asset/image/publicnote.png',
              key: keyButton,
            ),
            onTap: () {
              debugPrint("ProjectId=== ${pendingProjectList.projectId}");
              debugPrint(
                  "customerid == ${GlobalValues.loginEmployee.customerId}");
              debugPrint(
                  "Employeeid == ${GlobalValues.loginEmployee.employeeId}");
              PendingBidGlobalValue.pendingBidNoteProjectId =
                  pendingProjectList.projectId;
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
          height: 23,
          width: 23,
          child: InkWell(
            child: Image.asset(
              'asset/image/line_items.png',
              key: keyButton1,
            ),
            onTap: () {
              debugPrint("ProjectId=== ${pendingProjectList.projectId}");
              PendingBidGlobalValue.pendingBidLineItemsProjectId =
                  pendingProjectList.projectId;
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
          height: 23,
          width: 23,
          child: InkWell(
            child: Image.asset(
              'asset/image/proposalnew.png',
              height: 23,
              width: 23,
              key: keyButton2,
            ),
            onTap: () {
              PendingBidGlobalValue.pendingBidEquipmentProposal =
                  pendingProjectList;
              equipmentProposal(pendingProjectList);
            },
          ),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-bidders.htm')) {
      list.add(
        Container(
          height: 23,
          width: 23,
          child: InkWell(
            child: Image.asset(
              'asset/image/bidders.png',
              height: 23,
              width: 23,
              key: keyButton6,
            ),
            onTap: () {
              PendingBidGlobalValue.pendingBidBidder = pendingProjectList;
              Navigator.pushNamed(context, "/bidder");
            },
          ),
        ),
      );
    }
    /*if(TabRights.tabListData.any(
            (element) => element.tabTypeUrl == 'bidlist-players.htm')){
      list.add(
        InkWell(
          child: Image.asset('asset/image/players.png'),
          onTap: () {
            PendingBidGlobalValue.pendingBidPlayer = pendingProjectList;
            Navigator.pushNamed(context, "/player");
          },
        ),
      );
    }*/
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-files.htm')) {
      list.add(
        Container(
          height: 23,
          width: 23,
          child: InkWell(
            child: Image.asset(
              'asset/image/documents.png',
              key: keyButton3,
              //  key: _isFirstRun == true ? keyButton3 : null,
            ),
            onTap: () {
              PendingBidGlobalValue.pendingBidDocument = pendingProjectList;
              debugPrint("ProjectId=== ${pendingProjectList.projectId}");
              Navigator.pushNamed(context, "/document");
            },
          ),
        ),
      );
    }

    /* if (checkIconsRights('bidlist-update-proposal.htm') == true) {
      list.add(
        Image.asset('asset/image/update-proposal.png',width: 23,height: 23,),
      );
    }*/
    //  if(checkIconsRights(  'bidlist-add-me-as-a-bidder.htm') == true){ list.add(Image.asset('asset/image/Frame.png'),);}
    return list;
  }

  // search Function
  void searchWithThrottle(String keyword,
      {bool forceLoad = false, int throttleTime}) {
    _timer?.cancel();
    // if (keyword != previousKeyword && keyword.isNotEmpty) {
    previousKeyword = keyword;
    _timer =
        Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
      print("BidList Search Project Name: $keyword");
      getPendingProject(keyword, forceLoad: forceLoad);
      // getBidListData(keyword,forceLoad: forceLoad);
      _timer.cancel();
    });
    // }
  }

  Future getPendingProject(String searchText, {bool forceLoad = false}) async {
    setState(() {
      isLoading = true;
      if (pendingProject.isEmpty || forceLoad) {
        pendingProject.clear();
      }
    });
    debugPrint('get bidding called');
    DateTime now = DateTime.now();
    DateTime addOneDay = now.add(Duration(days: 1));

    if (pendingProject.isEmpty) {
      now = addOneDay;
      // addOneDay = DateTime.now();//scoreKeeper
    } else {
      String date = pendingProject.last.projectList.last.bidDate;
      // String dateWithT = 'MM/dd/yyyy';
      // DateTime dateTime = DateTime.parse(dateWithT);
      DateTime tempDate = new DateFormat('yyyy-mm-dd').parse(date); //MM/dd/yyyy
      addOneDay = tempDate;
    }
    String formattedDate = DateFormat('MM/dd/yyyy').format(addOneDay);

    bidListRequest = BidListRequest(
      projectName: searchText,
      employeeId: GlobalValues.loginEmployee.employeeId.toString(),
      startDate: formattedDate,
      limit: listLimit.toString(),
    );

    PendingProjectAPi pendingProjectAPi = PendingProjectAPi();
    pendingProjectAPi.getBidListApiData(bidListRequest).then((value) {
      debugPrint("Pending Project=== ${value.status}");
      var list = <BidListData>[];
      if (pendingProject.isEmpty || forceLoad) {
        pendingProject.clear();
      }
      value.data?.forEach((element) {
        if (pendingProject.any((sec) => sec.bidDate == element.bidDate)) {
        } else {
          list.add(element);
        }
      });
      setState(() {
        isLoading = false;
        pendingProject.addAll(list);
      });
    });
  }

  bool isLoading = true, isLoaded = false;

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

  void _delete(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to Out Of this Job ?'),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    messageOutThisJobData();
                    _isShown = false;
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }

  void _GetJob(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to Bidding this Job ?'),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    messageGotThisJobData();
                    _isShown = false;
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalValues.checkconection == true
        ? Stack(children: [
            Column(
              children: [
                Text(
                  'Pending Bids',
                  style: TextstyleConst.HeaderTitlePage,
                ),
                searchSort(),
                pendingProject.isEmpty
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
                            sectionList: pendingProject,
                            headerBuilder: (context, selectIndex, i) {
                              String bid = pendingProject[selectIndex].bidDate;
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
                                      '${pendingProject[selectIndex].projectList.length} Projects ',
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
                                  pendingProject[selectionIndex].projectList;
                              String name = list[itemIndex].projectName;
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  child: Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = i;
                                              //  selectedIndex = itemIndex;
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                _isFirstRun == true &&
                                                        selectedIndex == 1 &&
                                                        TooltipsGlobalValues
                                                                .pendingTip ==
                                                            true
                                                    ? Future.delayed(
                                                        Duration.zero,
                                                        showTutorial)
                                                    : null;
                                              });
                                            });
                                          },
                                          child: Container(
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
                                                                    : Container(),
                                                              ),
                                                            ]),
                                                      )),
                                                    ],
                                                  ),
                                                  selectedIndex == i
                                                      /*   selectedIndex ==
                                                            itemIndex*/
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
                                                              children:
                                                                  listOfIcons(list[
                                                                      itemIndex]),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              )),
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
                    Text('Loading Pending Bids...'),
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
          TooltipsGlobalValues.pendingTip = false;
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
          TooltipsGlobalValues.pendingTip = false;
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
                        "It's Define list of Line Items..!",
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
                    "It can show Project Proposal in Document ...! ",
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
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: keyButton4,
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
                    "Got This Job",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Click on it we can Succesfully Got this job ",
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
        identify: "Target 5",
        keyTarget: keyButton5,
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
                      "Out This Job",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Click on it You can Out this Project",
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
        identify: "Target 6",
        keyTarget: keyButton6,
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
                        "Show Bidders details , Add Bidders , Quick Add Bidders And share with other Bidders",
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
  }
}
