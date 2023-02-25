// ignore_for_file: unnecessary_statements

import 'dart:async';
import 'dart:core';

import 'package:bidbot/model/active_and_archive_project/active_project/active_project_model.dart';
import 'package:bidbot/screen/active_and_archive_project/active_project/active_project.dart';
import 'package:bidbot/api/bid_inquiry/manage_bid_inquiry_api.dart';
import 'package:bidbot/api/drawer_api.dart';
import 'package:bidbot/api/login_and_signUp/login_api.dart';
import 'package:bidbot/const/asset_const.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_list/bidlist_model.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:bidbot/model/bidding/bidding_model.dart';
import 'package:bidbot/model/login_and_signUp/login_model.dart';
import 'package:bidbot/model/login_and_signUp/signup_model.dart';
import 'package:bidbot/screen/active_and_archive_project/archives_project/archives_project_page.dart';
import 'package:bidbot/screen/bid_list/bid_list_page.dart';
import 'package:bidbot/screen/bidding_page/bidding_page.dart';
import 'package:bidbot/screen/pending_bid/pending_bid_page.dart';
import 'package:bidbot/screen/profile/profile_page.dart';
import 'package:bidbot/utils/routes.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../../api/bidding/add_me_as_bidder_api.dart';
import '../../api/local_auth_api.dart';
import '../../const/function_const.dart';
import '../../model/bidding/add_me_as_bidder_model.dart';
import '../../tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  const HomePage({
    Key key,
    @required this.isLoggedIn,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DrawerRequest drawerRequest;

  ListRequest listRequest;
  BidListRequest bidListRequest;
  ActiveProjectRequest activeProjectRequest;
  LoginSignUpValue loginSignUpValue;

  List<BiddingData> sectionList = [];
  List<BidListData> bidListData = [];
  String loginUserName;
  String loginPassword;
  bool isLoading = false, isLoaded = false;
  LoginRequest loginRequest;
  bool isBioMetric = false;
  var day = DateFormat('EEEE').format(DateTime.now());
  var date = DateFormat("MMMM dd, yyyy").format(DateTime.now());
  final ScrollController scrollController = ScrollController();
  String username;
  String password;
  var globalValue;
  AddMeAsBidderRequest addMeAsBidderRequest;

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  bool _isFirstCall;
  bool _isFirstRun;

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
      debugPrint("First time Run app value = $_isFirstRun");
    });
  }

  void _checkFirstCall() async {
    bool ifc = await IsFirstRun.isFirstCall();
    setState(() {
      _isFirstCall = ifc;
      debugPrint("First time call app value = $_isFirstCall");
    });
  }

  // String deepLinkURL = "";
  // bool calling = false;
  Future initialGlobalLink() async {
    try {
      final initialLink = getInitialLink();
      return initialLink;
    } on PlatformException catch (e) {
      debugPrint("initial global link exception error == $e");
      // log(e.message);
    }
  }

  getLink() {
    initialGlobalLink().then((value) {
      if (value != null) {
        var linkResponse = value;
        debugPrint("link response ==>> $linkResponse");
        debugPrint("link  another index value");
        setState(() {
          linkResponse != null
              ? GlobalValues.deepLink = linkResponse
              : GlobalValues.deepLink = "";
          debugPrint("link response global value =>  ${GlobalValues.deepLink}");
          GlobalValues.deepLink != null && GlobalValues.deepLink.isNotEmpty
              ? addMeAsBidderTap("${GlobalValues.deepLink.split("/")[4]}")
              : null;
        });
      } else {
        debugPrint("link response ==>> $value");
      }
    });
  }

  refreshIndicatorState() {
    GlobalValues.deepLink = "Blank url";
  }

/*  @override
  void initState() {
    getLink();
    widget.isLoggedIn != true ? getLogin() : null;
    super.initState();
    //   debugPrint("isLogin ==${widget.isLogin}");
    sharedPreference();
  }*/
  Future getLogin() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var credential = prefs.getStringList("credential");
    var personaIndex = prefs.getInt("personaIndex");
    loginRequest = LoginRequest(
      password: credential.last,
      username: credential.first,
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      appId: '${GlobalValues.appId}',
      sphereUrl: "${GlobalValues.sphereUrl}",
    );

    LoginApi loginApi = LoginApi();
    await loginApi.getLogin(loginRequest).then((value) {
      debugPrint("login home page response == ${value.status}");
      GlobalValues.loginEmployee = value.data[0].employees[
          GlobalValues.personaIndex != 0 ? GlobalValues.personaIndex : 0];
      GlobalValues.userToken = value.data[0].userToken;
      GlobalValues.listOfLoginPersona = value.data[0].employees;
      debugPrint("Login person Index ===== ${GlobalValues.personaIndex}");
      debugPrint(
          "Login SphereTypeId ===== ${GlobalValues.loginEmployee.sphereTypeId} ");
      debugPrint(
          "Login contactId ===== ${GlobalValues.loginEmployee.contactId} ");
      var statusCheck = value.status;
      if (statusCheck == true) {
        //   var message = value.message;
        if (value.data.length > 0) {
          var tokenValue = value.data[0].token;
          debugPrint("tokenValue $tokenValue");
          if (tokenValue.isNotEmpty) {
            drawerRequest = DrawerRequest(
                employeeId: GlobalValues.loginEmployee.employeeId.toString());
            getTabRights();
            getCreateNewProjectData();
            /*  final snacbar = SnackBar(
              content:
                  Text('Welcome Back, ${GlobalValues.loginEmployee.name}'),
              backgroundColor: ColorConst.successSnackBarColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snacbar);*/
          }
        }
      } else {
        var message = value.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: ColorConst.failedSnackBarColor,
          ),
        );
      }
    });
  }

  Future getTabRights() async {
    DrawerApi apicall = DrawerApi();
    await apicall.getDrawerData(drawerRequest).then((value) {
      var drawerApiResponce = value.status;
      GlobalValues.drawerListData = value.data;
      debugPrint('Drawer Api responce status ==$drawerApiResponce');
      if (drawerApiResponce == true) {
        TabRights.tabListData = value.data;
        TabRights.extractDrawerMenuRights();
        TabRights.extractIconMenuRides();
        debugPrint("List array tab right ${TabRights.sideMenuBidding.length}");
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future getCreateNewProjectData() async {
    ManageBidInquiryApi manageBidInquiryApi = ManageBidInquiryApi();
    await manageBidInquiryApi.manageBidInquiry().then((value) {
      var responce = value.status;
      if (responce == true) {
        GlobalValues.manageBidData = value.data;
      }
    });
  }

  void calenderChange() {
    debugPrint("calender Change ==${GlobalValues.calenderView}");
    setState(() {
      GlobalValues.calenderView = !GlobalValues.calenderView;
    });
  }

  String deepLinkURL = "";
  bool calling = false;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
    _checkFirstCall();
    // CheckInternet();
    debugPrint("FaceId value= ${GlobalValues.faceIdEnable}");
    //getLink();

    WidgetsBinding.instance.addObserver(this);
    print("home init deeplink == ${GlobalValues.deepLink}");
    // GlobalValues.deepLink == null || GlobalValues.deepLink.isEmpty
    //     ? getLink()
    //     : null;

    Timer(const Duration(milliseconds: 500), () {
      _isFirstCall == true ? Future.delayed(Duration.zero, showTutorial) : null;
    });

    widget.isLoggedIn != true ? getLogin() : null;
    /*   GlobalValues.checkconection == true
        ? widget.isLoggedIn != true
            ? getLogin()
            : null
        : Center(
            child: CupertinoAlertDialog(
              title: const Icon(
                Icons.wifi_off_outlined,
                color: Colors.black,
                size: 50,
              ),
              content: const Text('No Internet Connection!'),
            ),
          );*/
  }

/*  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GlobalValues.deepLink == "";
    super.dispose();
  }*/

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('MyApp state = $state');
    if (state == AppLifecycleState.inactive) {
      // app transitioning to other state.
      // GlobalValues.deepLink = "";
    } else if (state == AppLifecycleState.paused) {
      // app is on the background.
      // GlobalValues.deepLink = "";
      //  debugPrint("global deep value pause == ${GlobalValues.deepLink}");
      GlobalValues.deepLink = "";
      debugPrint("global deep value pause == ${GlobalValues.deepLink}");
    } else if (state == AppLifecycleState.detached) {
      GlobalValues.deepLink = "";
      // flutter engine is running but detached from views
    } else if (state == AppLifecycleState.resumed) {
      // app is visible and running.+
      // pauseAndResume().then((value) => value == true ? );
      // bioMetricAuth();
      GlobalValues.deepLink != null ? getLink() : null;
      debugPrint("route method call = ${GlobalValues.deepLink}");
      // GlobalValues.deepLink != null && GlobalValues.deepLink.isNotEmpty
      /*GlobalValues.deepLink != null && GlobalValues.deepLink.isNotEmpty
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(isLoggedIn: false)),
            )
          // ? Navigator.popAndPushNamed(context, homePage,
          //     arguments: {"isLoading": true})
          : null;
          : null;*/
    }
  }

  bioMetricAuth() async {
    final preference = await SharedPreferences.getInstance();
    var authStatus = preference.getBool("bioMetric");
    authStatus == true ? homeAuthFunction() : null;
  }

  Future homeAuthFunction() async {
    final function = await FunctionConst().authenticateBioMetric();
    if (function == true) {
      Navigator.popAndPushNamed(context, "/homePage",
          arguments: {"isLogin": false});
    } else {
      debugPrint("home not authenticate == $function");
      // homeAuthFunction();
      //  Navigator.popAndPushNamed(context, "/login");
    }
  }

  Future<bool> pauseAndResume() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    debugPrint("auth status === $isAuthenticated");
    return isAuthenticated;
  }

  Future addMeAsBidderTap(String projectLink) {
    setState(() {
      isLoading = true;
    });
    // GlobalValues.drawerListData.clear();
    // TabRights.tabListData.clear();
    // TabRights.sideMenuBidding.clear();
    // TabRights.iconsBidding.clear();
    // GlobalValues.manageBidData?.clear();
    print("projectLink in bidder APi == $projectLink");
    addMeAsBidderRequest = AddMeAsBidderRequest(
        subscriptionId: "${GlobalValues.subscriptionId}",
        verticalId: "${GlobalValues.verticalId}",
        appId: "${GlobalValues.appId}",
        link: "$projectLink");
    AddMeAsBidderApi addMeAsBidderApi = AddMeAsBidderApi();
    addMeAsBidderApi.addMeAsBidderTap(addMeAsBidderRequest).then((value) {
      var status = value.status;
      debugPrint("update Submittals status === $status");

      if (status == true) {
        setState(() {
          GlobalValues.loginEmployee.name = value.data.employeeData.name;
          GlobalValues.loginEmployee.employeeId =
              value.data.employeeData.employeeId;
          GlobalValues.loginEmployee.sphereId =
              value.data.employeeData.sphereId;
          GlobalValues.loginEmployee.sphere = value.data.employeeData.sphere;
          GlobalValues.loginEmployee.sphereTypeId =
              value.data.employeeData.sphereTypeId;
          GlobalValues.loginEmployee.sphereType =
              value.data.employeeData.sphereType;
          GlobalValues.profileData?.email = value.data.employeeData.email;
          GlobalValues.loginEmployee.customerId =
              value.data.employeeData.customerId;
          GlobalValues.loginEmployee.customerName =
              value.data.employeeData.customerName;
          GlobalValues.loginEmployee.contactId =
              value.data.employeeData.contactId;
          GlobalValues.loginEmployee.isFidoEnable =
              value.data.employeeData.isFidoEnable;
          GlobalValues.mfa = value.data.employeeData.mfa;
          GlobalValues.token = value.data.employeeData.token;
        });
        final snackBar = SnackBar(
          content: Text("Bidder Added Successfully"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // Navigator.popAndPushNamed(context, "/homePage",
        //     arguments: {"isLogin": false});
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // getInitialLink().then((value) => value != null && value.isNotEmpty ? getLink(): refreshIndicatorState());
    // getLink();
    // DeepLinkBloc bloc = DeepLinkBloc();
    return /*Scaffold(
      appBar: loginAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text("Deeplink URL"),
            Text(
                deepLinkURL == null ? "link" : " $deepLinkURL"),
            // Text("${test.split("/")[4]}"),
          ],
        ),
      ),

    );
*/
        isLoading != true
            ? Scaffold(
                key: _scaffoldKey,
                appBar: loginAppBar(context),
                body: loginBidPage(),
                floatingActionButton: GlobalValues.selectedBidIndex == 0 &&
                        GlobalValues.loginEmployee.sphereTypeId == 2 &&
                        TabRights.tabListData.any((element) =>
                            element.tabTypeUrl == 'bidlist-bid-inquiry.htm')
                    ? FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: () {
                          Navigator.pushNamed(context, '/bidInquiry');
                        },
                        /*  child: Image.asset(
                          'asset/image/bidinquirybutton.png',
                          fit: BoxFit.contain,
                          width: 70,
                          height: 70,
                        ),*/
                        child: Icon(
                          Icons.add,
                          size: 34,
                          key: keyButton4,
                        ))
                    : Container(),
              )
            : Scaffold(
                body: Visible(isLoading: isLoading, message: ""),
              );
  }

  Widget loginBidPage() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: showList(),
        ),
      ),
    );
  }

  List<Widget> showList() {
    List<Widget> childs = [];
    if (GlobalValues.selectedBidIndex == 5) {
      childs.add(ProfilePage());
    } else
    /* if (GlobalValues.selectedBidIndex == 6) {
      childs.add(ChangePassword());
    }
    else*/
    if (GlobalValues.selectedBidIndex == 7) {
      childs.add(SettingPage()); //SecurityKey()
    } else if (GlobalValues.selectedBidIndex == 0) {
      childs.add(
        BiddingPage(
          isLogin: true,
        ),
      );
    } else if (GlobalValues.selectedBidIndex == 1) {
      childs.add(
        BidListPage(),
      );
    } else if (GlobalValues.selectedBidIndex == 2) {
      childs.add(
        PendingBidPage(),
      );
    } else if (GlobalValues.selectedBidIndex == 3) {
      //   childs.add(searchSort());
      childs.add(
        //  Expanded(child: child),
        ActiveProjectPage(),
      );
    } else if (GlobalValues.selectedBidIndex == 4) {
      childs.add(
        ArchivesProjectPage(),
      );
    }
    return childs;
  }

  Widget loginAppBar(BuildContext context) {
    // deepLink == null
    //   ? getLink()
    //   : "$deepLink";
    return AppBar(
      automaticallyImplyLeading: false,
      shadowColor: Colors.white,
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      title: Container(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 55,
                child: Image.asset(
                  "asset/image/tristate1.png",
                  height: 25,
                  fit: BoxFit.cover,
                  width: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 13),
                child: SizedBox(
                  height: 42,
                  width: 3,
                  child: Container(
                    color: Color(0xff252669),
                  ),
                ),
              ),
              Container(
                child: Image.asset(
                  BID_BOT_LOGO,
                  height: 45,
                  width: 80,
                ),
              ),
            ],
            key: keyButton,
          ),
          Row(
            children: [
              Text('Welcome',
                  style: TextStyle(color: Color(0xffCDD1DA), fontSize: 15)),
              SizedBox(
                width: 5,
              ),
              Text(
                '${GlobalValues.loginEmployee.name}',
                style: TextStyle(color: Color(0xff252669), fontSize: 16),
              ),
            ],
          ),
        ]),
      ),
      /*     flexibleSpace: Container(
          color: Colors.blueAccent,
          child: Text(
            GlobalValues.deepLink != null && GlobalValues.deepLink.isNotEmpty
                ? "${GlobalValues.deepLink.split("/")[4]}"
                : "        Blank link....... ",
            style: TextStyle(color: Colors.white),
          )),*/
      bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Container(
              height: 3,
              color: Color(0xff262769),
            ),
          ),
          preferredSize: Size.fromHeight(3.0)),
      centerTitle: true,
      actions: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: 15,
                top: 12,
                bottom: 4,
              ),
              alignment: Alignment.center,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: ColorConst.LoginButtonColor,
              ),
              width: 95,
              child: InkWell(
                onTap: () async {
                  if (_scaffoldKey.currentState.isEndDrawerOpen) {
                    _scaffoldKey.currentState.openDrawer();
                  } else {
                    _scaffoldKey.currentState.openEndDrawer();
                  }

                  //   setState(() {});
                  await Navigator.pushNamed(context, drawerPage, arguments: {
                    "empData": GlobalValues.loginEmployee,
                  }).then((value) => setState(() {
                        //    refreshData();
                      }));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.menu,
                    ),
                  ],
                ),
                key: keyButton1,
              ),
            ),
            GlobalValues.selectedBidIndex == 0
                ? Container(
                    margin: EdgeInsets.only(right: 15, bottom: 10, top: 4),
                    alignment: Alignment.center,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      // color: ColorConst.LoginButtonColor,
                    ),
                    width: 95,
                    child: InkWell(
                      onTap: () {
                        debugPrint(
                            "callender Chanhge ${GlobalValues.calenderView}");
                        setState(() {
                          GlobalValues.calenderView =
                              !GlobalValues.calenderView;
                        });
                      },
                      child: (GlobalValues.calenderView == true)
                          ? Image.asset(
                              "asset/image/calender_off.png",
                              height: 20,
                              width: 95,
                              fit: BoxFit.cover,
                              key: keyButton2,
                            )
                          : Image.asset(
                              "asset/image/calender_on.png",
                              height: 20,
                              width: 95,
                              fit: BoxFit.cover,
                              key: keyButton3,
                            ),
                    ),
                  )
                : Container(),
          ],
        ),
        // )
      ],
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
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
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
                      "Welcome to the Bid Bot App",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    /*     Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ascending and Descending list order Value Alphabetically.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),*/
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
                      "Menu",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Click on It and Show All Pages ..!",
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
                    "Calender On/Off",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    "Show the days, weeks ,Months and Hide Calender ..!",
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
                    "Calender On/Off",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Show the days, weeks ,Months and Hide Calender ..!",
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
                    "Bid Inquiry",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "You can create a new Bid Inquiry",
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

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool switchValue;

  @override
  void initState() {
    super.initState();
    changeBioStatus();
  }

  changeBioStatus() async {
    final preference = await SharedPreferences.getInstance();
    // preference.setBool("bioMetric", switchValue);
    setState(() {
      switchValue = preference.getBool("bioMetric");
      debugPrint("switch init value == $switchValue");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.lock_open),
              title: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/changePassword");
                },
                child: Text(
                  "Change Password",
                  style: TextStyle(
                      //fontSize: 21,
                      color: Color(0xff6D6C6C),
                      fontWeight: FontWeight.w400),
                ),
              ),
              // value: Text('English'),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.security),
              title: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/securityPage");
                },
                child: Text(
                  "Security",
                  style: TextStyle(
                      //fontSize: 21,
                      color: Color(0xff6D6C6C),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SettingsTile.switchTile(
              initialValue: switchValue,
              activeSwitchColor: Colors.blue,
              // enabled: GlobalValues.faceIdEnable,
              onToggle: (value) {
                setState(() {
                  if (switchValue == value) {
                    switchValue = !value;
                  } else {
                    switchValue = value;
                  }
                  debugPrint("switch tap value == $switchValue");
                  tapToChangeValue();
                });
              },
              leading: Icon(Icons.fingerprint),
              title: Text(
                'Face ID/ Finger Print',
                style: TextStyle(
                    //fontSize: 21,
                    color: Color(0xff6D6C6C),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }

  tapToChangeValue() async {
    final preference = await SharedPreferences.getInstance();
    preference.setBool("bioMetric", switchValue);
    debugPrint("switch change set value == $switchValue");
  }
}
