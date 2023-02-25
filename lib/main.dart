import 'dart:async';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/screen/active_and_archive_project/active_project/schedule_shipdate/scheduled_shipdate_page.dart';
import 'package:bidbot/screen/active_and_archive_project/iom/equipment_iom_page.dart';
import 'package:bidbot/screen/active_and_archive_project/service_request/add_service_request_page.dart';
import 'package:bidbot/screen/active_and_archive_project/service_request/equipment_view.dart';
import 'package:bidbot/screen/active_and_archive_project/service_request/service_request_page.dart';
import 'package:bidbot/screen/active_and_archive_project/startUp_date/startUp_date_page.dart';
import 'package:bidbot/screen/active_and_archive_project/submittals/add_submittals_page.dart';
import 'package:bidbot/screen/active_and_archive_project/submittals/submittals_page.dart';
import 'package:bidbot/screen/active_and_archive_project/warranty/warranty_details_page.dart';
import 'package:bidbot/screen/bidding_page/bid_inquiry/bid_inquiry.dart';
import 'package:bidbot/screen/bidding_page/bid_inquiry/create_new_project.dart';
import 'package:bidbot/screen/bidding_page/bid_inquiry/employ_bid.dart';
import 'package:bidbot/screen/bidding_page/bid_inquiry/manage_bid_request.dart';
import 'package:bidbot/screen/bidding_page/bidders/quick_bidders_page.dart';
import 'package:bidbot/screen/pending_bid/pending_bid_page.dart';
import 'package:bidbot/screen/profile/change_password.dart';
import 'package:bidbot/screen/profile/security_key.dart';
import 'package:bidbot/screen/signup_page/term_and_condition_screen.dart';
import 'package:bidbot/screen/splash_screen/home_splash_screen.dart';
import 'package:bidbot/screen/splash_screen/splash_screen.dart';
import 'package:bidbot/utils/pdf_view/pdf_view.dart';
import 'package:bidbot/screen/bidding_page/bidders/add_bidder_page.dart';
import 'package:bidbot/screen/bidding_page/bidders/bidder_page.dart';
import 'package:bidbot/screen/bidding_page/document/add_document.dart';
import 'package:bidbot/screen/bidding_page/document/document_page.dart';
import 'package:bidbot/screen/bidding_page/line_Items/line_items_page.dart';
import 'package:bidbot/screen/bidding_page/notes/add_notes_screen.dart';
import 'package:bidbot/screen/bidding_page/notes/notes_screen.dart';
import 'package:bidbot/screen/bidding_page/players/add_player_page.dart';
import 'package:bidbot/screen/bidding_page/players/player_page.dart';
import 'package:bidbot/screen/bidding_page/update_proposal/update_proposal.dart';
import 'package:bidbot/screen/demo_page/demo_page.dart';
import 'package:bidbot/screen/demo_page/home_page.dart';
import 'package:bidbot/screen/forgot_page/forgot_page.dart';
import 'package:bidbot/screen/login_page/login_page.dart';
import 'package:bidbot/screen/signup_page/signup_page.dart';
import 'package:bidbot/screen/active_and_archive_project/submittals/share_page.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bidbot/screen/drawer/drawer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/local_auth_api.dart';

const debug = true;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
  // await GetStorage.init();
  final newUserDefault = await SharedPreferences.getInstance();
  var email = newUserDefault.getStringList("credential");
  var bioMetric = newUserDefault.getBool("bioMetric");
  final isAuthenticated = await LocalAuthApi().hasBiometrics();
  debugPrint("auth status === $isAuthenticated");
  runApp(MyApp(
    email: email?.first != null ? email.first : null,
    bioMetric: bioMetric != null ? bioMetric : false,
    hasBioMetric: isAuthenticated,
  ));
}

class MyApp extends StatelessWidget {
  final String email;
  final bool bioMetric;
  final bool hasBioMetric;
  MyApp({
    this.email,
    this.bioMetric,
    this.hasBioMetric,
  });
  StreamSubscription<DataConnectionStatus> listener;
  var Internetstatus = "Unknown";
  bool connect;

  CheckInternet() async {
    // Simple check to see if we have internet
    connect = await DataConnectionChecker().hasConnection;
    GlobalValues.checkconection = connect;
    print("conection =${GlobalValues.checkconection}");
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          Internetstatus = "Connected To The Internet";
          print('Data connection is available.$Internetstatus');
          /*setState(() {});*/
          break;
        case DataConnectionStatus.disconnected:
          Internetstatus = "No Internet Connection";
          /*  print('You are disconnected from the internet.$Internetstatus');
        setState(() {});*/
          break;
      }
    });
    return await await DataConnectionChecker().connectionStatus;
  }

  @override
  Widget build(BuildContext context) {
    CheckInternet();
    GlobalValues.platform = Theme.of(context).platform;
    debugPrint("bio metric == $bioMetric && has biometric == $hasBioMetric");
    debugPrint("Main connection value =  ${GlobalValues.checkconection}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bid Bot',
      theme: ThemeData(
        fontFamily: StringConst.FONT_FAMILY,
        primarySwatch: Colors.blue,
      ),
      initialRoute: email != null
          ? (bioMetric == true //&& hasBioMetric != true
              ? "/homeSplashScreen"
              : "/homePage")
          : ("/demo"),
      routes: {
        '/demo': (context) => DemoPage(),
        '/homeSplashScreen': (context) => HomeSplashScreen(),
        '/homePage':
            (BuildContext context) => /*GlobalValues.checkconection ==true?*/
                HomePage(
                  isLoggedIn:
                      (ModalRoute.of(context).settings.arguments as Map) != null
                          ? (ModalRoute.of(context).settings.arguments
                              as Map)["isLogin"]
                          : false,
                  //     customer: (ModalRoute.of(context).settings.arguments as Map)["cust"],
                ),
        /*     : Center(
                child: CupertinoAlertDialog(
                  title: const Icon(
                    Icons.wifi_off_outlined,
                    color: Colors.black,
                    size: 50,
                  ),
                  content: const Text('No Internet Connection!'),
                ),
              ),*/
        '/login': (BuildContext context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgot': (context) => ForgotPage(),
        '/drawer': (context) => DrawerPage(
              employData:
                  (ModalRoute.of(context).settings.arguments as Map)["empData"],
            ),
        '/bidInquiry': (context) => BidInquiry(),
        '/createNewProject': (context) => CreateNewProject(
              projectId:
                  (ModalRoute.of(context).settings.arguments as Map) != null
                      ? (ModalRoute.of(context).settings.arguments
                          as Map)["projectId"]
                      : false,
            ),
        '/employeeBid': (context) => EmployeeBids(),
        '/managBidRequest': (context) => ManageBidRequest(),
        "/pdfView": (context) => PdfView(),
        '/notes': (context) => NotesScreen(),
        "/addNotes": (context) => AddNotes(
              editNote:
                  (ModalRoute.of(context).settings.arguments as Map) != null
                      ? (ModalRoute.of(context).settings.arguments
                          as Map)["editNote"]
                      : false,
            ),
        "/lineItems": (context) => LineItems(),
        "/bidder": (context) => BiddersPage(),
        "/addBidder": (context) => AddBidderPage(),
        "/player": (context) => PlayerPage(),
        "/addPlayer": (context) => AddPlayerPage(),
        "/document": (context) => DocumentPage(),
        "/addDocument": (context) => AddDocument(),
        "/updateProposal": (context) => UpdateProposal(),
        "/warrantyDetails": (context) => WarrantyDetailsPage(),
        "/scheduledShipdate": (context) => ScheduledShipDatePage(),
        "/startUpDate": (context) => StartUpDatePage(),
        "/equipmentIOM": (context) => EquipmentIOMPage(),
        "/submittals": (context) => SubmittalsPage(),
        "/addSubmittals": (context) => AddSubmittalsPage(),
        "/serviceRequest": (context) => ServiceRequestPage(),
        "/equipmentView": (context) => EquipmentView(),
        "/addServiceRequest": (context) => AddServiceRequestPage(),
        "/securityPage": (context) => SecurityKey(),
        "/changePassword": (context) => ChangePassword(),
        "/pendingBidPage": (context) => PendingBidPage(),
        "/splashScreen": (context) => SplashScreen(),
        "/QABPage": (context) => QuickBidders(),
        "/shareDocument": (context) => ShareDocumentPage(),
        "/termAndCondition" : (context) => TermAndCondition(),
      },
    );
  }
}
