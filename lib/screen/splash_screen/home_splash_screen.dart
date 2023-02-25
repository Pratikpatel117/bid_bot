import 'package:bidbot/const/function_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import '../../api/bidding/add_me_as_bidder_api.dart';
import '../../const/color_const.dart';
import '../../model/bidding/add_me_as_bidder_model.dart';

class HomeSplashScreen extends StatefulWidget {
  const HomeSplashScreen({Key key}) : super(key: key);

  @override
  State<HomeSplashScreen> createState() => _HomeSplashScreenState();
}

class _HomeSplashScreenState
    extends State<HomeSplashScreen> /* with WidgetsBindingObserver*/ {
  bool authenticatePermission;
  bool isLoading = false;
  AddMeAsBidderRequest addMeAsBidderRequest;

  @override
  void initState() {
    super.initState();
    bioMetricAuth();
    // WidgetsBinding.instance.addObserver(this);
    // GlobalValues.faceIdEnable == true ? homeAuthFunction() : null;
    //   getLink();
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

  String deepLinkURL = "";

  Future dirrectLogin() {
    Navigator.popAndPushNamed(context, "/homePage",
        arguments: {"isLogin": false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visible(isLoading: false, message: ""),
    );
  }
}

/* @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GlobalValues.deepLink = "";
    super.dispose();
  }*/
/*
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('MyApp state = $state');
    if (state == AppLifecycleState.inactive) {
      // app transitioning to other state.
    } else if (state == AppLifecycleState.paused) {
      // app is on the background.
    } else if (state == AppLifecycleState.detached) {
      // flutter engine is running but detached from views
    } else if (state == AppLifecycleState.resumed) {
      // app is visible and running.
      // getLink();
      debugPrint("route method call");
      // HomePage(isLoggedIn: true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(isLoggedIn: true)));
      // Navigator.pushNamed(context, homePage,arguments: {"isLogin" : true},);
      // runApp(MediaQuery(child: MaterialApp(home : HomePage(isLoggedIn: true)),data: MediaQueryData(),)); // run your App class again
    }
  }*/
/*

  getLink() {
    setState(() {
      isLoading = true;
    });
    initialGlobalLink().then((value) {
      var linkResponse = value.toString();
      debugPrint("link response ==>> $linkResponse");
      setState(() {
        GlobalValues.deepLink = value;
      });
    });
    debugPrint("deeplink text == ${GlobalValues.deepLink}");
    GlobalValues.deepLink != null && GlobalValues.deepLink.isNotEmpty
        ? addMeAsBidderTap(GlobalValues.deepLink.split("/")[4])
        : null;
    addMeAsBidderTap(GlobalValues.deepLink.split("/")[4]);
    setState(() {
      isLoading = false;
    });
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

  Future initialGlobalLink() async {
    try {
      final initialLink = getInitialLink();
      return initialLink;
    } on PlatformException catch (e) {
      debugPrint("exception error == $e");
      // log(e.message);
    }
  }
*/
