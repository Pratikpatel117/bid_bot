import 'dart:async';
import 'dart:convert';

import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:bidbot/model/login_and_signUp/login_model.dart';
import 'package:bidbot/utils/routes.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/bid_inquiry/manage_bid_inquiry_api.dart';
import '../../api/drawer_api.dart';
import '../../const/color_const.dart';
import '../../const/string_const.dart';
import 'package:http/http.dart' as http;
import '../../tutorial_coach_mark.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    Key key,
    this.employData,
    this.title,
  }) : super(key: key);

  final Employees employData;
  final String title;

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  DrawerRequest drawerRequest;
  bool isLoading = false;
  bool _isFirstCall;
  bool _isFirstRun;
  bool boolValue;
  String boolVar;
  StreamSubscription<DataConnectionStatus> listener;
  var Internetstatus = "Unknown";
  bool connect;
  CheckInternet() async {
    // Simple check to see if we have internet
    connect = await DataConnectionChecker().hasConnection;
    GlobalValues.checkconection = connect;
    //  print(await DataConnectionChecker().hasConnection);
    print(
        "conection global value in active project= ${GlobalValues.checkconection}");
/*    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    print("Last results: ${DataConnectionChecker().lastTryResults}");*/

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
  }

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
    });
  }

  void _checkFirstCall() async {
    bool ifc = await IsFirstRun.isFirstCall();
    setState(() {
      _isFirstCall = ifc;
      debugPrint("First time call app value = ${_isFirstCall}");
    });
  }

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
    _checkFirstCall();
    CheckInternet();
    Timer(
        const Duration(
          milliseconds: 500,
        ), () {
      TooltipsGlobalValues.drawerTip == true && _isFirstRun == true
          ? Future.delayed(Duration.zero, showTutorial)
          : null;
    });
  }

  void dispose() {
    super.dispose();
  }

  bool checkTabRights(String tabType) {
    bool isAvailable = false;
    for (int a = 0; a < TabRights.sideMenuBidding.length; a++) {
      TabData tab = TabRights.sideMenuBidding[a];
      if (tab.tabTypeUrl == tabType) {
        isAvailable = true;
        break;
      }
    }
    return isAvailable;
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    debugPrint(
        "before logout bio status == ${preferences.getBool("bioMetric")}");
    preferences.remove("username");
    preferences.remove("password");
    preferences.remove("credential");
    preferences.remove("bioMetric");
    debugPrint(
        "after logout bio status == ${preferences.getBool("bioMetric")}");
    Navigator.pushNamedAndRemoveUntil(context, loginPage, (route) => false);
    // Navigator.pushNamed(context, LOGIN_PAGE);
    // GlobalValues.deepLink = null;
    GlobalValues.personaIndex = 0;
    GlobalValues.faceIdEnable = false;
    GlobalValues.deepLink = "";
    GlobalValues.userToken = null;
    GlobalValues.loginEmployee = null;
    GlobalValues.selectedBidIndex = 0;
    GlobalValues.calenderView = true;
    GlobalValues.drawerListData.clear();
    TabRights.tabListData.clear();
    TabRights.sideMenuBidding.clear();
    TabRights.iconsBidding.clear();
    GlobalValues.manageBidData?.clear();
    GlobalValues.biddingProjectListData.clear();
  }

  List<Widget> listOfTiles() {
    List<Widget> list = [];
    list.add(DrawerListTab(
      context: context,
      name: 'Profile',
      index: 5,
      leadingIcon: Icon(
        Icons.account_circle,
        size: 27,
        key: keyButton1,
      ),
    )); // Profile
    if (checkTabRights("bidlist-bidding.htm") == true) {
      list.add(
        DrawerListTab(
          context: context,
          name: "Bidding",
          index: 0,
          leadingIcon: Icon(
            Icons.gavel,
            size: 27,
            key: keyButton2,
          ),
        ),
        //Bidding
      );
    }
    if (checkTabRights("bidlist-bidlist.htm") == true) {
      list.add(
        DrawerListTab(
          context: context,
          name: "My Bid List",
          index: 1,
          leadingIcon: Icon(
            Icons.receipt_long,
            size: 27,
            key: keyButton3,
          ),
        ), //Bid-List
      );
    }
    if (checkTabRights("bidlist-pending.htm") == true) {
      list.add(
        DrawerListTab(
          context: context,
          name: "Pending Bids",
          index: 2,
          leadingIcon: Icon(
            Icons.pending_actions_outlined,
            size: 27,
            key: keyButton4,
          ),
        ), //Pending
      );
    }
    if (checkTabRights("bidlist-active.htm") == true) {
      list.add(
        DrawerListTab(
          context: context,
          name: "Active Project",
          index: 3,
          leadingIcon: Icon(
            Icons.verified,
            size: 26.5,
            key: keyButton5,
          ),
        ), //Active
      );
    }
    if (checkTabRights("bidlist-archives.htm") == true) {
      list.add(
        DrawerListTab(
          context: context,
          name: "Project Archives",
          index: 4,
          leadingIcon: Icon(
            Icons.archive,
            size: 27,
            key: keyButton6,
          ),
        ), //A
      );
    }
    list.add(
      DrawerListTab(
          context: context,
          name: "Setting",
          index: 7,
          leadingIcon: Icon(
            Icons.settings_suggest_rounded,
            size: 27.8,
            key: keyButton7,
          )),
    );
    list.add(
      DrawerListTab(
          context: context,
          name: "Help",
          index: 8,
          leadingIcon: Icon(
            Icons.contact_support,
            size: 27,
          )),
    );
    list.add(
      Padding(
        padding: const EdgeInsets.only(top: 17),
        child: InkWell(
          onTap: () {
            logout();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffEE3737),
            ),
            alignment: Alignment.center,
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Text(
              'LogOut',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _scaffoldKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 33, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //Image.asset('asset/image/leftback.png',height: 32,width: 32,)
              children: [
                //  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.home)),
                Flexible(
                  child: IconButton(
                    icon: Image.asset(
                      'asset/image/leftback.png',
                      height: 50,
                      width: 32,
                    ),
                    tooltip: "Back Button",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3, right: 13),
                    child: Image.network(
                      'https://www.myciright.com/Ciright/ajaxCall-photo.htm?flag=employeePhoto&compress=0&id=${widget.employData.employeeId}',
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          'WelCome Back',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffB4B4B4)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        InkWell(
                          onTap: () {
                            _onLoading(GlobalValues.listOfLoginPersona);
                          },
                          child: Icon(
                            Icons.groups,
                            size: 27,
                            color: Color(0xff019fe6),
                            key: keyButton,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.employData.name,
                      style: TextStyle(
                          fontSize: 21,
                          color: Color(0xff6C6C6C),
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.employData.customerName,
                      style: TextStyle(fontSize: 17, color: Color(0xff252669)),
                    ),
                  ],
                  //key: keyBottomNavigation1,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 44, right: 44, top: 20),
            child: Column(
              children: listOfTiles(),
            ),
          ),
        ],
      ),
    );
  }

  _onLoading(List<Employees> employeeData) {
    showDialog(
      context: context,
      barrierColor: Colors.white,
      barrierLabel: "Select Role",
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height,
            // color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Select Role",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: StringConst.FONT_FAMILY),
                  ),
                ]),
                SizedBox(
                  height: 80,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: GlobalValues.listOfLoginPersona != null
                      ? listOfPersona(employeeData)
                      : [],
                ),
              ],
            ),
          ),
          // titlePadding: EdgeInsets.only(right: 30),
        );
      },
    );
    // Navigator.of(context,rootNavigator: true).pop();
  }

  List<Widget> listOfPersona(List<Employees> employees) {
    List<Widget> list = [];
    int count = 0;
    for (int i = count; i < employees.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: InkWell(
            child: RoleGradientContainer(
                imagePath:
                    employees[i].sphereTypeId == 1 ? "employee" : "customer",
                roleName:
                    employees[i].sphereTypeId == 1 ? "Employees" : "Customers"),
            onTap: () {
              personaTap(employees, i);
            }),
      ));
      count++;
    }
    return list;
  }

  personaTap(List<Employees> employees, int i) {
    GlobalValues.loginEmployee = employees[i];
    GlobalValues.selectedBidIndex = 0;
    GlobalValues.calenderView = true;
    GlobalValues.drawerListData.clear();
    TabRights.tabListData.clear();
    TabRights.sideMenuBidding.clear();
    TabRights.iconsBidding.clear();
    GlobalValues.manageBidData?.clear();
    debugPrint(
        "Login SphereTypeId ===== ${GlobalValues.loginEmployee.sphereTypeId} ");
    debugPrint("Login user Name ===== ${GlobalValues.loginEmployee.name} ");
    debugPrint(
        "Login contactId ===== ${GlobalValues.loginEmployee.contactId} ");
    drawerRequest = DrawerRequest(
        employeeId: GlobalValues.loginEmployee.employeeId.toString());
    getTabRights();
    getCreateNewProjectData();
    Navigator.pop(context);
  }

  Future getTabRights() async {
    DrawerApi apiCall = DrawerApi();
    await apiCall.getDrawerData(drawerRequest).then((value) {
      var drawerApiResponse = value.status;
      GlobalValues.drawerListData = value.data;
      debugPrint('Drawer Api response status ==$drawerApiResponse');
      if (drawerApiResponse == true) {
        TabRights.tabListData = value.data;
        debugPrint(
            "List Index of TabListData right === ${TabRights.tabListData.length}");
        debugPrint("List Index of TabListData right === ${value.data.length}");
        TabRights.extractDrawerMenuRights();
        TabRights.extractIconMenuRides();
        debugPrint("List array tab right ${TabRights.sideMenuBidding.length}");
        goToHomeAfterLogin();
      }
    });
  }

  Future getCreateNewProjectData() async {
    ManageBidInquiryApi manageBidInquiryApi = ManageBidInquiryApi();
    await manageBidInquiryApi.manageBidInquiry().then((value) {
      var response = value.status;
      if (response == true) {
        GlobalValues.manageBidData = value.data;
      }
    });
  }

  void goToHomeAfterLogin() {
    final snacbar = SnackBar(
      content: Text('Welcome !'),
      backgroundColor: ColorConst.successSnackBarColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snacbar);
    //   showAlertDialog(context);
    Navigator.popAndPushNamed(context, '/homePage',
        arguments: {
          "isLogin": true,
          //  "cust": dropValue,
        },
        result: false);
    // setState(() {
    //   isLoading = false;
    // });
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
          TooltipsGlobalValues.drawerTip = false;
        });
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () async {
        print("skip");
        setState(() {
          TooltipsGlobalValues.drawerTip = false;
        });
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
                      "Persona Switcher",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Click Here And Select Your Role ...!',
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
                      "Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "It\'s Your Profile Details Page ...!",
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
                      "Bidding",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Here,List OF Bidding Projects ...!',
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
          align: ContentAlign.top,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Bid List",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  'List of Bidding Project ...!',
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
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Pendding Bids",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    'Your Pendding Bids Show Here ...!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ))
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Active Projects",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  'Show Active Projects ...!',
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
            align: ContentAlign.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Project Archives",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Text(
                    "Archive Projects ...!",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
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
                      "Setting",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Your App Settings ...!',
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

class DrawerListTab extends StatelessWidget {
  DrawerListTab({
    Key key,
    @required this.context,
    @required this.name,
    @required this.index,
    this.leadingIcon,
  }) : super(key: key);
  final String name;
  final int index;
  final Icon leadingIcon;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon,
      minLeadingWidth: 45,
      horizontalTitleGap: 15,
      tileColor: index <= 4
          ? GlobalValues.selectedBidIndex == index
              ? Color(0xffF6F6FF)
              : Color(0xffEDEDFF)
          : null,
      title: Text(
        name,
        style: TextStyle(
            fontSize: 21,
            color: Color(0xff6D6C6C),
            fontWeight: FontWeight.w400), //252669 --visible
      ),
      trailing: Visibility(
        child: index <= 4
            ? GlobalValues.selectedBidIndex == index
                ? Icon(Icons.remove_red_eye)
                : Icon(Icons.remove_red_eye_outlined)
            : SizedBox(),
      ),
      onTap: () {
        GlobalValues.selectedBidIndex = index; // Profile
        index <= 7 ? Navigator.pop(context) : null;
      },
    );
  }
}
