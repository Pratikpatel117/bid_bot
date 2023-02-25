import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/function_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/login_and_signUp/login_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/bid_inquiry/manage_bid_inquiry_api.dart';
import '../../api/drawer_api.dart';
import '../../api/login_and_signUp/local_auth_api.dart';
import '../../api/login_and_signUp/login_api.dart';
import '../../const/string_const.dart';
import '../../model/drawer_model.dart';
import '../login_page/login_activity.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;
  Future<List> credentialList;
  final globalKey = GlobalKey<ScaffoldState>();
  LoginRequest loginRequest;
  String userName;
  String password;

  @override
  void initState() {
    FunctionConst().sharedPreference().then((value) {
      userName = value.first;
      password = value.last;
      debugPrint("login credential == ${value.first}");
      debugPrint("login credential == ${value.last}");
    });
    super.initState();
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
              GlobalValues.loginEmployee = employees[i];
              GlobalValues.personaIndex = i;
              debugPrint("person index ==> ${GlobalValues.personaIndex}");
              debugPrint(
                  "Login SphereTypeId ===== ${GlobalValues.loginEmployee.sphereTypeId} ");
              debugPrint(
                  "Login user Name ===== ${GlobalValues.loginEmployee.name} ");
              debugPrint(
                  "Login contactId ===== ${GlobalValues.loginEmployee.contactId} ");
              drawerRequest = DrawerRequest(
                  employeeId: GlobalValues.loginEmployee.employeeId.toString());
              getTabRights();
              getCreateNewProjectData();
              Navigator.pop(context);
            }),
      ));
      count++;
    }
    return list;
  }

  Future getLogin() async {
    setState(() {
      isLoading = true;
    });
    // WidgetsFlutterBinding.ensureInitialized();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('username', "${username.text}");
    // var username = prefs.getString("username");
    // var password = prefs.getString("password");
    // prefs.setString('password', "${password.text}");
    loginRequest = LoginRequest(
      password: password,
      username: userName,
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      appId: '${GlobalValues.appId}',
      sphereUrl: "${GlobalValues.sphereUrl}",
    );

    LoginApi loginApi = LoginApi();
    await loginApi.getLogin(loginRequest).then((value) {
      debugPrint("login home page response == ${value.status}");
      var statusCheck = value.status;
      if (statusCheck == true) {
        //   var message = value.message;
        if (value.data.length > 0) {
          var tokenValue = value.data[0].token;
          GlobalValues.userToken = value.data[0].userToken;
          GlobalValues.token = value.data[0].token;
          GlobalValues.mfa = value.data[0].mfa;
          // GlobalValues.Token
          GlobalValues.listOfLoginPersona = value.data[0].employees;
          debugPrint("tokenValue --->  ${value.data[0].userToken}");
          if (value.data[0].employees.length > 1) {
            _onLoading(value.data[0].employees);
          } else if (tokenValue.isNotEmpty) {
            GlobalValues.loginEmployee = value.data[0].employees[0];
            debugPrint(
                "Login SphereTypeId ===== ${GlobalValues.loginEmployee.sphereTypeId} ");
            debugPrint(
                "Login contactId ===== ${GlobalValues.loginEmployee.contactId} ");
            drawerRequest = DrawerRequest(
                employeeId: GlobalValues.loginEmployee.employeeId.toString());
            getTabRights();
            getCreateNewProjectData();
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
        Navigator.pop(context);
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
        goToHomeAfterLogin();
      }
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

  void goToHomeAfterLogin() {
    final snackBar = SnackBar(
      content: Text('Welcome !'),
      backgroundColor: ColorConst.successSnackBarColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // showAlertDialog(context);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homePage',
      (route) => false,
      arguments: {
        "isLogin": true,
        //  "cust": dropValue,
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: isLoading != true
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('asset/image/tristate1.png'),
                        Image.asset('asset/image/bid-bot-logo.png'),
                      ],
                    ),
                  ),
                  Text("Face Id",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: StringConst.FONT_FAMILY)),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, right: 40, left: 40, bottom: 40),
                    child: Text(
                        "Allow Face Id to will enable faster and more secure login",
                        style: TextStyle(color: Colors.black45, fontSize: 16)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Image.asset(
                      "asset/image/faceid.png",
                      height: 60,
                      width: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            final preference =
                                await SharedPreferences.getInstance();
                            preference.setBool("bioMetric", false);
                            // GlobalValues.faceIdEnable = false;
                            // getLogin();
                            Navigator.popAndPushNamed(context, '/homePage',
                                arguments: {
                                  "isLogin": true,
                                  //  "crust": dropValue,
                                },
                                result: false);
                            /*  setState(() {
                        isLoading = true;
                      });
                      LoginAction().getLogin(isLoading, false, setState,
                          userName, password, context);*/
                          },
                          child: ColorFullButton(
                            buttonName: "Don't use Face Id",
                            buttonColor: notUseFaceIdColor,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            // authenticateUser();
                            final isAuthenticated =
                                await LocalAuthApi.authenticate();
                            debugPrint("auth status === $isAuthenticated");
                            final preference =
                                await SharedPreferences.getInstance();
                            setState(() {
                              // GlobalValues.faceIdEnable = isAuthenticated;
                              if (isAuthenticated == true) {
                                // _isUserAuthorized = isAuthorized;
                                // GlobalValues.faceIdEnable = isAuthenticated;
                                preference.setBool("bioMetric", true);
                                debugPrint(
                                    "After Authenticate -- ${GlobalValues.faceIdEnable}"); // "SuccessFully Authenticate";

                                getLogin();

                                // getLogin();
                                Navigator.popAndPushNamed(context, '/homePage',
                                    arguments: {
                                      "isLogin": true,
                                      //  "crust": dropValue,
                                    },
                                    result: false);
                              } else {
                                preference.setBool("bioMetric", false);
                                GlobalValues.faceIdEnable =
                                    isAuthenticated; //"Not authorised";
                              }
                            });
                          },
                          child: ColorFullButton(
                            buttonName: "Enable Face Id",
                            buttonColor: useFaceIdColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }
}
