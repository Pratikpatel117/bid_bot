import 'dart:async';
import 'dart:core';

import 'package:bidbot/api/active_and_archive_project/active_project_api/active_project_api.dart';
import 'package:bidbot/api/app_intro_api.dart';
import 'package:bidbot/api/project_info_api.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/active_project/active_project_model.dart';
import 'package:bidbot/model/app_intro_model.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import '../../../tutorial_coach_mark.dart';
import '../../bidding_page/project_information.dart';

class ActiveProjectPage extends StatefulWidget {
  const ActiveProjectPage({Key key}) : super(key: key);

  @override
  _ActiveProjectPageState createState() => _ActiveProjectPageState();
}

class _ActiveProjectPageState extends State<ActiveProjectPage> {
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
  GlobalKey keyButton8 = GlobalKey();
  GlobalKey keyButton9 = GlobalKey();
  GlobalKey keyButton10 = GlobalKey();

  TextEditingController _controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<ActiveProjectList> activeProjectList = [];
  List<IntroData> introdata = [];
  bool isLoading = true;
  String projectName = "";
  Timer _timer;
  String previousKeyword;
  int buttonIndex = 0;
  bool isSortBy = false;
  bool isSortOrder = true;
  String sortByValue = "1";
  String sortOrderValue = "1";
  int selectionIndex = 0;
  String projectId = " ";
  ProjectInformationData projectData;
  bool _isFirstRun;
  StreamSubscription<DataConnectionStatus> listener;
  var Internetstatus = "Unknown";

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
    //  CheckInternet();
    _checkFirstRun();
    getActiveProject("");
    //  getTooltipData();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        debugPrint('Bidlist Api Printed Data Scroll');
        getActiveProject(previousKeyword);
        debugPrint('Scroll Activity Success');
      }
      // getActiveProject();
    });

    Timer(
        const Duration(
          milliseconds: 500,
        ), () {
      _isFirstRun == true &&
              selectionIndex == 0 &&
              TooltipsGlobalValues.activeTip == true
          ? Future.delayed(Duration.zero, showTutorial)
          : null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listener.cancel();
    super.dispose();
  }

  /* bool connect;
  CheckInternet() async {
    // Simple check to see if we have internet
    connect = await DataConnectionChecker().hasConnection;
    GlobalValues.checkconection = connect;
    //  print(await DataConnectionChecker().hasConnection);
    print(
        "conection global value in active project= ${GlobalValues.checkconection}");
*/ /*    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    print("Last results: ${DataConnectionChecker().lastTryResults}");*/ /*

    // actively listen for status updates
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          Internetstatus = "Connectd TO THe Internet";
          print('Data connection is available.$Internetstatus');
          setState(() {});
          break;
        case DataConnectionStatus.disconnected:
          Internetstatus = "No Data Connection";
          print('You are disconnected from the internet.$Internetstatus');
          setState(() {});
          break;
      }
    });
    return await await DataConnectionChecker().connectionStatus;
  }*/

  //App Intro Details
  Future getTooltipData() async {
    isLoading = true;

    AppIntroApi introApi = AppIntroApi();
    List<IntroData> list = [];
    await introApi.AppIntroData("${GlobalValues.appId}").then((value) {
      var status = value.status;
      debugPrint("get App Tool tip Data == $status");
      value.idata?.forEach((element) {
        list.add(element);
      });
      introdata.addAll(list);
    });

    setState(() {
      introdata.clear();
      isLoading = false;
    });
    debugPrint("Tool Tips data == ${introdata.length}");
  }

  Future getActiveProject(String searchText, {bool forceLoad = false}) async {
    var start =
        activeProjectList.isEmpty || forceLoad ? 0 : activeProjectList.length;
    setState(() {
      isLoading = true;
      if (start == 0) {
        activeProjectList.clear();
      }
    });

    sortProjectOrder(sortOrderValue, sortByValue) {
      this.sortOrderValue = sortOrderValue;
      this.sortByValue = sortByValue;
    }

    if (buttonIndex == 1) {
      if (isSortOrder == true) {
        sortProjectOrder("0", "0"); //alpha-down
      } else {
        sortProjectOrder("1", "0"); //alpha-up
      }
    } else if (buttonIndex == 2) {
      if (isSortBy == false) {
        sortProjectOrder("1", "1"); //num-up
      } else {
        sortProjectOrder("1", "0"); //num-down
      }
    }
    debugPrint(
        "is sort order == $sortOrderValue  &&  sort by value == $sortByValue");
    debugPrint("is sort order == $isSortOrder  &&  sort by value == $isSortBy");
    debugPrint("is sort order == $buttonIndex");
    var activeProjectRequest = ActiveProjectRequest(
      employeeId: GlobalValues.loginEmployee.employeeId.toString(),
      limit: GlobalValues.activeProjectPaginationLimit.toString(),
      sortBy: sortByValue,
      sortOrder: sortOrderValue,
      start: start.toString(),
      projectName: searchText,
    );

    ActiveProjectApi activeProjectApi = ActiveProjectApi();
    await activeProjectApi
        .getBidListApiData(activeProjectRequest)
        .then((value) {
      GlobalValues.activeProjectResponce = value.data.projectList;
      var list = <ActiveProjectList>[];
      debugPrint("ActiveProject List === ${value.status}");
      debugPrint("ActiveProject Data === ${value.data}");
      if (start == 0) {
        activeProjectList.clear();
      }
      value.data.projectList?.forEach((element) {
        if (activeProjectList.any((sec) => sec.bidDate == element.bidDate)) {
        } else {
          list.add(element);
        }
      });
      setState(() {
        isLoading = false;
        activeProjectList.addAll(list);
      });
    });
  }

  void isCheckSort() {
    setState(() {
      isSortBy = !isSortBy;
    });
  }

  void isCheckSortOrder() {
    setState(() {
      isSortOrder = !isSortOrder;
    });
  }

  /* bool checkIconsRights(String tabType) {
    bool isAvailable = false;
    for (int i = 0; i < TabRights.iconsBidding.length; i++) {
      TabData tab = TabRights.iconsBidding[i];
      if (tab.tabTypeUrl == tabType) {
        isAvailable = true;
        break;
      }
    }
    return isAvailable;
  }*/

  List<Widget> listOfIconsSecureOne(
      ActiveProjectList activeProjectList, BuildContext context) {
    List<Widget> list = [];

    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-line-item.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/line_items.png',
            key: keyButton2,
          ),
          onTap: () {
            ActiveProjectGlobalValue.activeProjectLineItemProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(context, "/lineItems");
          },
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-submittals.htm')) {
      list.add(
        InkWell(
          onTap: () {
            ActiveProjectGlobalValue.activeProjectSubmittalsProjectId =
                activeProjectList.projectId.toString();
            debugPrint("project Id == ${activeProjectList.projectId}");
            Navigator.pushNamed(context, "/submittals");
          },
          child: Stack(children: [
            Image.asset(
              'asset/image/submittal.png',
              key: keyButton3,
            ),
            activeProjectList.submittalCount == 0
                ? Container()
                : Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff43A047),
                      ),
                      child: Text(
                        activeProjectList.submittalCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ]),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-ship-dates.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/Shipdates.png',
            height: 23,
            width: 23,
            key: keyButton4,
          ),
          onTap: () {
            ActiveProjectGlobalValue.activeProjectScheduledShipDateProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(context, "/scheduledShipdate");
          },
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-warranty.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/Warrenty.png',
            key: keyButton5,
          ),
          onTap: () {
            ActiveProjectGlobalValue.activeProjectWarrantyDetailsProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(context, "/warrantyDetails");
          },
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == "bidlist-startup.htm")) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/Startup.png',
            height: 23,
            width: 23,
            key: keyButton6,
          ),
          onTap: () {
            ActiveProjectGlobalValue.activeProjectStartUpDateProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(context, "/startUpDate");
          },
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-ioms.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/IMOS.png',
            key: keyButton7,
          ),
          onTap: () {
            ProjectArchivesGlobalValue.communeScreenApi = 0;
            ActiveProjectGlobalValue.activeProjectEquipmentIOMProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(
              context,
              "/equipmentIOM",
            );
          },
        ),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-spare-parts-list.htm')) {
      list.add(
        InkWell(
          onTap: () {
            ProjectArchivesGlobalValue.communeScreenApi = 1;
            ActiveProjectGlobalValue.activeProjectEquipmentIOMProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(
              context,
              "/equipmentIOM",
            );
          },
          child: Image.asset(
            'asset/image/Sparepartlist.png',
            width: 23,
            height: 23,
            key: keyButton8,
          ),
        ),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-service-request.htm')) {
      list.add(
        InkWell(
          onTap: () {
            ActiveProjectGlobalValue.activeProjectServiceRequestProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(
              context,
              "/serviceRequest",
            );
          },
          child: Image.asset(
            'asset/image/servicerequestvan.png',
            width: 23,
            height: 23,
            key: keyButton9,
          ),
        ),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-service-reports.htm')) {
      list.add(
        InkWell(
          onTap: () {
            ProjectArchivesGlobalValue.communeScreenApi = 2;
            ActiveProjectGlobalValue.activeProjectEquipmentIOMProjectId =
                activeProjectList.projectId.toString();
            Navigator.pushNamed(
              context,
              "/equipmentIOM",
            );
          },
          child: Image.asset(
            'asset/image/Servicereport.png',
            width: 23,
            height: 23,
            key: keyButton10,
          ),
        ),
      );
    }
    /* if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-revised-estimate.htm')) {
      list.add(
        Image.asset(
          'asset/image/Revisedestimate.png',
          width: 23,
          height: 23,
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-credit-split.htm')) {
      list.add(
        Image.asset(
          'asset/image/Creditsplit.png',
          width: 23,
          height: 23,
        ),
      );
    }*/

    /*  if (checkIconsRights('bidlist-line-item.htm') == true) {
      list.add(
        Image.asset('asset/image/line_items.png'),
      );
    }
    if (checkIconsRights('bidlist-submittals.htm') == true) {
      list.add(
        Image.asset('asset/image/submittal.png'),
      );
    }
    if (checkIconsRights('bidlist-submittals.htm') == true) {//'bidlist-ship-dates.htm'
      list.add(
        Image.asset('asset/image/Shipdates.png',
          height: 23,
          width: 23,),
      );
    }

    if (checkIconsRights('bidlist-warranty.htm') == true) {
      list.add(
        Image.asset('asset/image/Warrenty.png'),
      );
    }
    if (checkIconsRights("bidlist-startup.htm") == true) {
      list.add(
        Image.asset(
          'asset/image/Startup.png',
          height: 23,
          width: 23,
        ),
      );
    }
    if (checkIconsRights('bidlist-ioms.htm') == true) {
      list.add(
        Image.asset('asset/image/IMOS.png'),
      );
    }
    if (checkIconsRights('bidlist-spare-parts-list.htm') == true) {
      list.add(
        Image.asset(
          'asset/image/Sparepartlist.png',
          width: 23,
          height: 23,
        ),
      );
    }
    if (checkIconsRights('bidlist-service-request.htm') == true) {
      list.add(
        Image.asset(
          'asset/image/servicerequestvan.png',
          width: 23,
          height: 23,
        ),
      );
    }
    if (checkIconsRights('bidlist-service-reports.htm') == true) {
      list.add(
        Image.asset(
          'asset/image/Servicereport.png',
          width: 23,
          height: 23,
        ),
      );
    }
    if (checkIconsRights('bidlist-revised-estimate.htm') == true) {
      list.add(
        Image.asset('asset/image/Revisedestimate.png'),
      );
    }
    if (checkIconsRights('bidlist-credit-split.htm') == true) {
      list.add(
        Image.asset('asset/image/Creditsplits.png'),
      );
    }*/
    return list;
  }

  List<Widget> listOfIconsSecureZero() {
    List<Widget> list = [];

    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-place-order.htm')) {
      list.add(
        Image.asset('asset/image/Placeorder.png'),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-negotiate-order.htm')) {
      list.add(
        Image.asset('asset/image/negotiateorder.png'),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bldlist-line-item-pricing.htm')) {
      if (GlobalValues.loginEmployee.sphereTypeId == 1) {
        list.add(
          Image.asset('asset/image/lineitmesprice.png'),
        );
      }
    }
    /*
    if(TabRights.tabListData.any((element) => element.tabTypeUrl == 'bidlist-line-item.htm')){
      list.add(
        Image.asset('asset/image/line_items.png'),
      );
    }
    if(TabRights.tabListData.any((element) => element.tabTypeUrl == 'bidlist-proposal.htm')){
      list.add(
        Image.asset(
          'asset/image/proposalnew.png',
          height: 23,
          width: 23,
        ),
      );
    }
    if(TabRights.tabListData.any((element) => element.tabTypeUrl == 'bidlist-public-notes.htm')){
      list.add(
        Image.asset(
          'asset/image/publicnote.png',
          height: 23,
          width: 23,
        ),
      );
    }
    if(TabRights.tabListData.any((element) => element.tabTypeUrl == 'bidlist-files.htm')){
      list.add(
        Image.asset(
          'asset/image/documents.png',
          height: 23,
          width: 23,
        ),
      );
    }
    if(TabRights.tabListData.any((element) => element.tabTypeUrl == 'bidlist-ioms.htm')){
      list.add(
        Image.asset(
          'asset/image/IMOS.png',
          height: 23,
          width: 23,
        ),
      );
    }*/

    /*
    if (checkIconsRights('bldlist-line-item-pricing.htm') == true) {
      list.add(
        Image.asset('asset/image/lineitmesprice.png'),
      );
    }
    if (checkIconsRights('bidlist-line-item.htm') == true) {
      list.add(
        Image.asset('asset/image/line_items.png'),
      );
    }
    if (checkIconsRights('bidlist-proposal.htm') == true) {
      list.add(
        Image.asset(
          'asset/image/proposalnew.png',
          height: 23,
          width: 23,
        ),
      );
    }
    if (checkIconsRights('bidlist-public-notes.htm') == true) {
      list.add(
        Image.asset('asset/image/publicnote.png'),
      );
    }
    if (checkIconsRights('bidlist-files.htm') == true) {
      list.add(
        Image.asset('asset/image/documents.png'),
      );
    }
    if (checkIconsRights('bidlist-ioms.htm') == true) {
      list.add(
        Image.asset('asset/image/IMOS.png'),
      );
    }*/
    return list;
  }

  void searchWithThrottle(String keyword,
      {bool forceLoad = false, int throttleTime}) {
    _timer?.cancel();
    // if (keyword != previousKeyword && keyword.isNotEmpty) {
    previousKeyword = keyword;
    _timer =
        Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
      print("Going to search with keyword : $keyword");
      getActiveProject(keyword, forceLoad: forceLoad);
      _timer.cancel();
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> secureZero = listOfIconsSecureZero();
    return GlobalValues.checkconection == true
        ? Stack(children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    //  Navigator.pushNamed(context, shareDocumentPage);
                  },
                  child: Text(
                    'Active Project',
                    style: TextstyleConst.HeaderTitlePage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SearchTextFormField(
                        searchWithThrottle: searchWithThrottle,
                      ),
                      InkWell(
                        child: Container(
                          height: 15,
                          width: 15,
                          child: isSortOrder == true
                              ? Image.asset(
                                  "asset/image/sort_alpha_up.png",
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.cover,
                                  // key: intro.keys[0],
                                  key: keyButton,
                                )
                              : Image.asset(
                                  "asset/image/sort_alpha.png",
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        onTap: () {
                          this.buttonIndex = 1;
                          isCheckSortOrder();
                          searchWithThrottle(previousKeyword, forceLoad: true);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 15,
                          width: 15,
                          child: isSortBy == false
                              ? Image.asset(
                                  "asset/image/sort_num_down.png",
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.cover,
                                  // key: intro.keys[1],
                                  key: keyButton1,
                                )
                              : Image.asset(
                                  "asset/image/sort_num1.png",
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        onTap: () {
                          this.buttonIndex = 2;
                          isCheckSort();
                          searchWithThrottle(previousKeyword, forceLoad: true);
                        },
                      ),
                    ],
                  ),
                ),
                //    isLoading ? Container() :
                activeProjectList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('There are no Projects Bidding.'),
                      )
                    : Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemBuilder: (context, i) {
                              /*    activeProjectList.sort((a, b) =>
                            b.approxCloseDate.compareTo(a.approxCloseDate));
                        activeProjectList.forEach((element) {
                          debugPrint("order date = ${element.approxCloseDate}");
                        });*/
                              // activeProjectList.sort();

                              var name = activeProjectList[i].projectName;
                              var date = activeProjectList[i].approxCloseDate;
                              // debugPrint(
                              //     "${activeProjectList[i].projectName} == ${activeProjectList[i].submittalCount} ");
                              return Card(
                                elevation: 2,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: name,
                                            style: TextstyleConst.ListTextStyle,
                                          ),
                                          WidgetSpan(
                                              child: GlobalValues.loginEmployee
                                                          .sphereTypeId ==
                                                      1
                                                  ? ProjectInformationButton(
                                                      projectId:
                                                          activeProjectList[i]
                                                              .projectId
                                                              .toString(),
                                                      isLoading: isLoading,
                                                    )
                                                  : Container())
                                        ]),
                                      ),
                                      /*Text(
                                  name,
                                  style: TextstyleConst.ListTextStyle,
                                ),*/
                                      subtitle: activeProjectList[i]
                                              .approxCloseDate
                                              .isNotEmpty
                                          ? Text("Order Date:$date")
                                          : Container(),
                                      /* trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  selectionIndex = i;
                                });
                              },
                              child: Image.asset(
                                  'asset/image/bluetick.png')),*/

                                      onTap: () {
                                        setState(() {
                                          selectionIndex = i;

                                          /*     selectionIndex == 0
                                        ? Future.delayed(
                                            Duration.zero, showTutorial)
                                        : null;*/
/*
                                    Timer(
                                        const Duration(
                                          milliseconds: 500,
                                        ), () {
                                      /// start the intro
                                      selectionIndex == 0
                                          ? intro.start(context)
                                          : null;
                                      //  selectionIndex == 0 ? intro.start(context) : null;
                                    });*/

                                          /*        activeProjectList.sort((a, b) => b
                                        .approxCloseDate
                                        .compareTo(a.approxCloseDate));*/
                                          activeProjectList.forEach((element) {
                                            /*  debugPrint(
                                          "order date = ${element.approxCloseDate} & ${activeProjectList.length}");*/
                                          });
                                        });
                                      },
                                    ),
                                    selectionIndex == i
                                        ? (activeProjectList[i].isSecure == 1)
                                            ? Align(
                                                heightFactor: 1.2,
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 6),
                                                  // height: 28,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children:
                                                        listOfIconsSecureOne(
                                                            activeProjectList[
                                                                i],
                                                            context),
                                                  ),
                                                ),
                                              )
                                            : Align(
                                                child: Container(),
                                              )
                                        : Container(),
                                    selectionIndex == i
                                        ? (activeProjectList[i].isSecure == 0)
                                            ? Align(
                                                heightFactor: 1.2,
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 6),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        secureZero.length < 4
                                                            ? MainAxisAlignment
                                                                .center
                                                            : MainAxisAlignment
                                                                .spaceEvenly,
                                                    children: secureZero,
                                                  ),
                                                ),
                                              )
                                            : Align(
                                                child: Container(),
                                              )
                                        : Container(),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, i) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: activeProjectList.length),
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
                    Text('Loading Active Projects...'),
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
          TooltipsGlobalValues.activeTip = false;
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
          TooltipsGlobalValues.activeTip = false;
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
                      "Alphabetic Order",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ascending and Descending list order Value Alphabetically.",
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
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Numeric Order",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Numeric Ascending and Descending list order By Date.",
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
        identify: "Target 2",
        keyTarget: keyButton2,
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
      identify: "Target 3",
      keyTarget: keyButton3,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "submittals",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    "It can show the details of Submittals Projects, Equipment list, Add Submittals, Upload document, View Document and share with Employees.. ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ))
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Ship Dates",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Scheduled Ship Dates..!",
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
                    "Warrenty",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Warrenty Detail Types and Period",
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
                      "Startup Dates",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Scheduled Startup Dates",
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
        identify: "Target 7",
        keyTarget: keyButton7,
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
                      "IOM's",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Equipment Installation And Operations Manuals",
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
        identify: "Target 8",
        keyTarget: keyButton8,
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
                      "Spare Parts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Define Equipment Spare Parts List with Manufacture name, date ,etc..",
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
        identify: "Target 9",
        keyTarget: keyButton9,
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
                      "Service Requests",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "It's Show list of Services Requsests & You can Add Service Request..!",
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
        identify: "Target 10",
        keyTarget: keyButton10,
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
                      "Service Reports",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Here,using this you can show Project Service Reports..!",
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
