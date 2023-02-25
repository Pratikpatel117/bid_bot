import 'package:bidbot/api/bid_inquiry/manage_bid_inquiry_api.dart';
import 'package:bidbot/api/drawer_api.dart';
import 'package:bidbot/api/login_and_signUp/login_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:bidbot/model/login_and_signUp/login_model.dart';
import 'package:bidbot/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

import '../../const/string_const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  CustomerModel dropValue;
  bool passwordview = true;
  DrawerRequest drawerRequest;
  LoginRequest request;
  bool loginVerify = true;
  bool isLoading = false;
  bool rememberMe = false;
  final scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String emailValue = "";
  String passValue = "";
  String _authorised = "Not Authorised";

  @override
  void dispose() {
    // TODO: implement dispose
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // emailValue = Preference.getUsername();
    // passValue = Preference.getPassword();
    print("deep link in login page == ${GlobalValues.deepLink}");
    dropValue = CustomerModel(
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
    );
  }

  final _localAuthentication = LocalAuthentication();
  bool _isUserAuthorized = false;

/*
  Future<void> authenticateUser() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticate(
        localizedReason: "Please authenticate to see account balance",
        useErrorDialogs: true,
        stickyAuth: true,
      );
      debugPrint("print == $isAuthorized");
    } on PlatformException catch (exception) {
      if (exception.code == local_auth_error.notAvailable ||
          exception.code == local_auth_error.passcodeNotSet ||
          exception.code == local_auth_error.notEnrolled) {
        // Handle this exception here.
      }
      debugPrint("print == $isAuthorized");
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        // _isUserAuthorized = isAuthorized;
        _authorised = "SuccessFully Authenticate";
      } else {
        _authorised = "Not authorised";
      }
    });
  }
*/

  /* @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  setState(() {
    loaging = false;
    username.dispose();
    password.dispose();
  });

  }*/

  List<CustomerModel> customers = [
    CustomerModel(
        name: "Ciright",
        appId: "2421",
        sphereUrl: "bidlist-app.htm",
        subscriptionId: "9329",
        verticalId: "18"),
    CustomerModel(
        name: "Tri state",
        appId: "2421",
        sphereUrl: "bidlist-app.htm",
        subscriptionId: "7686051",
        verticalId: "324"),
  ];

  /* void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Image.asset(
                'asset/image/animation/bid-bot-loader-2.gif',
                height: 100,
                width: 100,
              ),
              // new Text("Loading"),
            ],
          ),
        );
      },
    );
    // Navigator.of(context,rootNavigator: true).pop();
  }*/

  bool buttonPress() {
    final form = formState.currentState;
    if (form.validate()) {
      form?.save();
      return true;
    }
    return false;
  }

  void passwordView() {
    setState(() {
      passwordview = !passwordview;
    });
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
    // _onLoading();
    // WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', "${usernameController.text}");
    prefs.setString('password', "${passwordController.text}");

    request = LoginRequest(
      appId: "${GlobalValues.appId}",
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      sphereUrl: "${GlobalValues.sphereUrl}",
      password: passwordController.text,
      username: usernameController.text,
    );

    LoginApi loginApi = LoginApi();
    await loginApi.getLogin(request).then((value) {
      new Future.delayed(new Duration(seconds: 0), () {
        //  Navigator.pop(context); //pop dialog
      });

      var statusCheck = value.status;
      if (statusCheck == true) {
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
        setState(() {
          isLoading = false;
        });
      }
    });
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
      var responce = value.status;
      if (responce == true) {
        GlobalValues.manageBidData = value.data;
      }
    });
  }

  void goToHomeAfterLogin() {
    final snacbar = SnackBar(
      content: Text('Welcome !'),
      backgroundColor: ColorConst.successSnackBarColor,
    );
    // ScaffoldMessenger.of(context).showSnackBar(snacbar);
    getCredentialStore();
    Navigator.pushNamed(
      context,
      splashScreen,
    );
  /*  Navigator.popAndPushNamed(context, '/homePage',
        arguments: {
          "isLogin": true,
          //  "crust": dropValue,
        },
        result: false);*/
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldkey,
        body: isLoading != true
            ? Container(
                // color: Color(0xfffbfbfb),
                margin: EdgeInsets.only(top: 20, right: 8, left: 8),
                child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 20, bottom: 40, left: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('asset/image/tristate1.png'),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 8.5,
                              width: MediaQuery.of(context).size.width / 3,
                              // color: Colors.greenAccent,
                              child: Image.asset(
                                'asset/image/2.0x/bidbotlogo@2x.png',
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            ),
/*
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60, bottom: 30),
                                  child: Text('SIGN IN',
                                      style: TextstyleConst.SignUpTitle),
                                ),
                              ],
                            ),
*/
                            Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 13, bottom: 20),
                                      child: Container(
                                        // height: 45,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextFormField(
                                          validator: (value) {
                                            // setState(() {
                                            return !isEmail(value)
                                                ? "email is required"
                                                : null;
                                            // });
                                            // return null;
                                            // (save.contains('@')) ? null : 'Enter required Id';
                                            // if (save.contains('@')) {
                                            //   return null;
                                            // }
                                            // return 'Email is Required';
                                          },
                                          controller: usernameController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor: Colors.black12,
                                          decoration: loginFieldInputDecoration(
                                            'Username *',
                                            Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                          obscureText: passwordview,
                                          controller: passwordController,
                                          validator: (save) {
                                            //   (save.length < 5) ? 'Enter Required password' : null;
                                            if (save.length < 1) {
                                              return 'Password is Required';
                                            }
                                            return null;
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor: Colors.black12,
                                          decoration: loginFieldInputDecoration(
                                            "Password *",
                                            InkWell(
                                                onTap: passwordView,
                                                child: Icon(
                                                  passwordview
                                                      ? Icons.remove_red_eye
                                                      : Icons
                                                          .remove_red_eye_outlined,
                                                  color: Colors.grey,
                                                )),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.only(left: 0),
                                              // tileColor: Colors.greenAccent,
                                              /*       leading: Checkbox(
                                                  value: rememberMe,
                                                  side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2,
                                                      style: BorderStyle.solid),
                                                  shape: CircleBorder(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      rememberMe = value;
                                                    });
                                                  }),*/
                                              /* title: Text("Remember Me",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14)),*/
                                              horizontalTitleGap: -8,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, forgotPage);
                                            },
                                            child: Text(
                                              'Forgot password?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff48C6F4),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 40),
                                      child: InkWell(
                                        onTap: () {
                                          if (buttonPress() == true) {
                                            getLogin();

                                          } else {
                                            debugPrint("Login invalid");
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: useFaceIdColor,
                                          ),
                                          alignment: Alignment.center,
                                          height: 40,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Log in',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Don't have an Account?",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        SizedBox(width: 4),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              signUpPage,
                                            );
                                            debugPrint(
                                                'SignUp value===$dropValue');
                                            debugPrint(
                                                'SignUp value===$dropValue');
                                          },
                                          child: Text(
                                            "Register here",
                                            style: TextStyle(
                                                color: Color(0xff48C6F4),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    /*  InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          signUpPage, /* arguments: {
                          "cust": dropValue,
                        }*/
                                        );
                                        debugPrint('SignUp value===$dropValue');
                                        /* arguments: {
                          "cust": dropValue,
                        }*/
                                        debugPrint('SignUp value===$dropValue');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xff366690)),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xffffffff),
                                        ),
                                        alignment: Alignment.center,
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          'Sign Up',
                                          style:
                                              TextstyleConst.SignUpButtonText,
                                        ),
                                      ),
                                    ),*/
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Visible(isLoading: isLoading, message: ""));
  }

  InputDecoration loginFieldInputDecoration(
      String hintName, Widget preFixIcon) {
    return InputDecoration(
      prefixIcon: preFixIcon,
      errorStyle: TextStyle(
        height: 0.5,
        fontSize: 11,
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorConst.InputFocusedBorderColor,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      /* border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red,width: 10),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),*/
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorConst.InputFocusedBorderColor,
        ),
      ),
      /*focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: ColorConst
                                                    .InputFocusedBorderColor,
                                                width: 1),
                                          ),*/
      /* enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: ColorConst
                                                    .InputEnableBorderColor,
                                                width: 1),
                                          ),*/
      filled: true,
      hintText: hintName,
      contentPadding: EdgeInsets.fromLTRB(10, 13, 10, 0),
      //padding according to your need
      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
      fillColor: Colors.transparent,
    );
  }

  Future getCredentialStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(
        "credential", [usernameController.text, passwordController.text]);
  }

  Widget buildText(String text, bool checked) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Colors.green, size: 24)
                : Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 24)),
          ],
        ),
      );
}
/* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 35, bottom: 25),
                                  child: Text('SIGN IN',
                                      style: TextstyleConst.SignUpTitle),
                                ),
                              ],
                            ),*/
/* Container(
                      child: Image.asset(
                        'asset/image/background_image.png',
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),*/
/* Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Image.asset(
                          'asset/image/hands-combine.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
