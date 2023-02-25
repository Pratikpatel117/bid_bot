import 'dart:async';

import 'package:bidbot/api/active_and_archive_project/archive_project_api/archives_project_api.dart';
import 'package:bidbot/api/project_info_api.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/active_project/active_project_model.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import '../../../const/function_const.dart';
import '../../../tutorial_coach_mark.dart';
import '../../bidding_page/project_information.dart';

class ArchivesProjectPage extends StatefulWidget {
  const ArchivesProjectPage({Key key}) : super(key: key);

  @override
  _ArchivesProjectPageState createState() => _ArchivesProjectPageState();
}

class _ArchivesProjectPageState extends State<ArchivesProjectPage> {
  final ScrollController scrollController = ScrollController();
  ActiveProjectRequest activeProjectRequest;
  List<ActiveProjectList> archiverProjectList = [];

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

  bool isLoading = true;
  String archivesProjectName = "";
  Timer _timer;
  String previousKeyword;
  int buttonIndex = 0;
  ProjectInformationData projectData;
  bool isSortBy = false;
  bool isSortOrder = true;
  String sortByValue = "0";
  String sortOrderValue = "0";
  int selectionIndex = 0;
  bool _isFirstRun;
  StreamSubscription<DataConnectionStatus> listener;
  var Internetstatus = "Unknown";

  /*CheckInternet() async {
    // Simple check to see if we have internet
    GlobalValues.checkconection = await DataConnectionChecker().hasConnection;
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
    print(
        "conection global value in project archives= ${GlobalValues.checkconection}");
    getArchivesProjectData("");

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        debugPrint('Archive Printed Data Scroll ');
        getArchivesProjectData(previousKeyword);
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
              TooltipsGlobalValues.archiveTip == true
          ? Future.delayed(Duration.zero, showTutorial)
          : null;
    });
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
          // _onLoading();
          ConstWidgets().onLoading(context, projectData);
        });
      }
    });
    setState(() {
      isLoading = false;
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

  List<Widget> listOfIcons(ActiveProjectList archiverProjectList) {
    List<Widget> list = [];

    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-submittals.htm')) {
      list.add(
        InkWell(
          onTap: () {
            ProjectArchivesGlobalValue.projectArchiveSubmittalsProjectId =
                archiverProjectList.projectId.toString();
            Navigator.pushNamed(context, "/submittals");
          },
          child: Stack(children: [
            Image.asset(
              'asset/image/submittal.png',
              //key: intro.keys[0],
              key: keyButton2,
            ),
            archiverProjectList.submittalCount == 0
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
                        archiverProjectList.submittalCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
          ]),
        ),
      );
    }
    if (TabRights.tabListData
        .any((element) => element.tabTypeUrl == 'bidlist-warranty.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/Warrenty.png',
            key: keyButton3,
          ),
          onTap: () {
            ProjectArchivesGlobalValue.projectArchiveWarrantyDetailsProjectId =
                archiverProjectList.projectId.toString();
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
            key: keyButton4,
          ),
          onTap: () {
            ProjectArchivesGlobalValue.projectArchiveStartUpDateProjectId =
                archiverProjectList.projectId.toString();
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
            key: keyButton5,
          ),
          onTap: () {
            ProjectArchivesGlobalValue.projectArchiveEquipmentIOMProjectId =
                archiverProjectList.projectId.toString();
            ProjectArchivesGlobalValue.communeScreenApi = 0;
            Navigator.pushNamed(context, "/equipmentIOM");
          },
        ),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-spare-parts-list.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/Sparepartlist.png',
            width: 23,
            height: 23,
            key: keyButton6,
          ),
          onTap: () {
            ProjectArchivesGlobalValue.communeScreenApi = 1;
            ProjectArchivesGlobalValue.projectArchiveEquipmentIOMProjectId =
                archiverProjectList.projectId.toString();
            Navigator.pushNamed(
              context,
              "/equipmentIOM",
            );
          },
        ),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-service-request.htm')) {
      list.add(
        Image.asset(
          'asset/image/servicerequestvan.png',
          width: 23,
          height: 23,
          key: keyButton7,
        ),
      );
    }
    if (TabRights.tabListData.any(
        (element) => element.tabTypeUrl == 'bidlist-service-reports.htm')) {
      list.add(
        InkWell(
          child: Image.asset(
            'asset/image/Servicereport.png',
            width: 23,
            height: 23,
            key: keyButton8,
          ),
          onTap: () {
            ProjectArchivesGlobalValue.communeScreenApi = 2;
            ProjectArchivesGlobalValue.projectArchiveEquipmentIOMProjectId =
                archiverProjectList.projectId.toString();
            Navigator.pushNamed(context, "/equipmentIOM");
          },
        ),
      );
    }
    /* if(TabRights.tabListData.any((element) => element.tabTypeUrl ==  'bidlist-revised-estimate.htm')){//
      list.add(// Hide
        Image.asset('asset/image/Revisedestimate.png',width: 23,height: 23,),
      );
    }*/
    /* if(TabRights.tabListData.any((element) => element.tabTypeUrl ==  'bidlist-credit-split.htm')){
      list.add(//hide
        Image.asset('asset/image/Creditsplit.png',width: 23,height: 23,),
      );
    }*/
    /*
    if (checkIconsRights('bidlist-submittals.htm') == true) {
      list.add(
        Image.asset('asset/image/submittal.png'),
      );
    }
    if (checkIconsRights('bidlist-warranty.htm') == true) {
      list.add(
        Image.asset('asset/image/Warrenty.png'),
      );
    }
    if (checkIconsRights("bidlist-startup.htm") == true) {
      list.add(
        Image.asset('asset/image/Startup.png',height: 23,width: 23,),
      );
    }
    if (checkIconsRights('bidlist-ioms.htm') == true) {
      list.add(
        Image.asset('asset/image/IMOS.png'),
      );
    }
    if (checkIconsRights('bidlist-spare-parts-list.htm') == true) {
      list.add(
        Image.asset('asset/image/Sparepartlist.png',width: 23,height: 23,),
      );
    }
    if (checkIconsRights( 'bidlist-service-request.htm') == true) {
      list.add(
        Image.asset('asset/image/servicerequestvan.png',width: 23,height: 23,),
      );
    }
    if (checkIconsRights( 'bidlist-service-reports.htm') == true) {
      list.add(
        Image.asset('asset/image/Servicereport.png',width: 23,height: 23,),
      );
    }
    if(checkIconsRights('bidlist-revised-estimate.htm') == true){
      list.add(Image.asset('asset/image/Revisedestimate.png'),);}
    if(checkIconsRights('bidlist-credit-split.htm') == true){
      list.add(Image.asset('asset/image/Creditsplits.png'),);
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
      getArchivesProjectData(
        keyword,
        forceLoad: true,
      );
      _timer.cancel();
    });
    // }
  }

  Future getArchivesProjectData(String searchText,
      {bool forceLoad = false}) async {
    var start = archiverProjectList.isEmpty || forceLoad
        ? 0
        : archiverProjectList.length;
    setState(() {
      isLoading = true;
      if (start == 0) {
        archiverProjectList.clear();
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
        sortProjectOrder("0", "1"); //num-down
      }
    }

    var activeProjectRequest = ActiveProjectRequest(
      projectName: searchText,
      employeeId: GlobalValues.loginEmployee.employeeId.toString(),
      limit: GlobalValues.activeProjectPaginationLimit.toString(),
      sortBy: sortByValue,
      sortOrder: sortOrderValue,
      start: start.toString(),
    );

    ArchivesProjectApi archivesProjectApi = ArchivesProjectApi();
    await archivesProjectApi
        .getArchivesProjectApiData(activeProjectRequest)
        .then((value) {
      var list = <ActiveProjectList>[];
      if (start == 0) {
        archiverProjectList.clear();
      }
      debugPrint("start value = $start");
      debugPrint("ArchiveProject List === ${value.status}");
      debugPrint(
          "ArchiveProject Data length === ${value.data.projectList.length}");
      value.data.projectList?.forEach((element) {
        if (archiverProjectList.any((sec) => sec.bidDate == element.bidDate)) {
        } else {
          list.add(element);
        }
      });
      setState(() {
        isLoading = false;
        archiverProjectList.addAll(list);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlobalValues.checkconection == true
          ? Stack(children: [
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Project Archives',
                                style: TextstyleConst.HeaderTitlePage),
                            Text(" (${archiverProjectList.length})",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff252669),
                                    fontWeight: FontWeight.bold)),
                          ])),
                  Row(
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
                      //  Text("${archiverProjectList.length}"),
                    ],
                  ),
                  archiverProjectList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text('There are no Projects Bidding.'),
                        )
                      : Expanded(
                          child: ListView.separated(
                              controller: scrollController,
                              itemBuilder: (context, i) {
                                return Card(
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: archiverProjectList[i]
                                                  .projectName,
                                              style:
                                                  TextstyleConst.ListTextStyle,
                                            ),
                                            WidgetSpan(
                                                child: GlobalValues
                                                            .loginEmployee
                                                            .sphereTypeId ==
                                                        1
                                                    ? ProjectInformationButton(
                                                        projectId:
                                                            archiverProjectList[
                                                                    i]
                                                                .projectId
                                                                .toString(),
                                                        isLoading: isLoading,
                                                      )
                                                    : Container())
                                          ]),
                                        ),
                                        subtitle: archiverProjectList[i]
                                                .approxCloseDate
                                                .isNotEmpty
                                            ? Text(
                                                "Order Date:${archiverProjectList[i].approxCloseDate}")
                                            : Container(),
                                        onTap: () {
                                          setState(() {
                                            selectionIndex = i;
                                          });
                                        },
                                      ),
                                      selectionIndex == i
                                          ? Align(
                                              heightFactor: 1.2,
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: listOfIcons(
                                                      archiverProjectList[i]),
                                                ),
                                              ),
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
                              itemCount: archiverProjectList.length),
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
                      Text('Loading Project Archives...'),
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
          TooltipsGlobalValues.archiveTip = false;
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
          TooltipsGlobalValues.archiveTip = false;
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
      identify: "Target 3",
      keyTarget: keyButton3,
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
