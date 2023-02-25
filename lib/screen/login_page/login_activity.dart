import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/bid_inquiry/manage_bid_inquiry_api.dart';
import '../../api/drawer_api.dart';
import '../../api/login_and_signUp/login_api.dart';
import '../../const/color_const.dart';
import '../../const/string_const.dart';
import '../../const/widget.dart';
import '../../model/drawer_model.dart';
import '../../model/login_and_signUp/login_model.dart';

LoginRequest request;
DrawerRequest drawerRequest;

class LoginAction {
  _onLoading(List<Employees> employeeData, BuildContext context, bool isLoading,
      Function setState, bool isLoggedIn) {
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
                      ? listOfPersona(employeeData, context, isLoading,
                          setState, isLoggedIn)
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

  List<Widget> listOfPersona(List<Employees> employees, BuildContext context,
      bool isLoading, Function setState, bool isLoggedIn) {
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
              getTabRights(context, isLoading, setState, isLoggedIn);
              getCreateNewProjectData();
              Navigator.pop(context);
            }),
      ));
      count++;
    }
    return list;
  }

  Future getLogin(
    bool isLoading,
    bool isLoggedIn,
    Function setState,
    String userName,
    String password,
    BuildContext context,
  ) async {
    // setState(() {
    //   isLoading = true;
    // });
    // _onLoading();
    // WidgetsFlutterBinding.ensureInitialized();
    // var userName ;
    // var password;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn != true
        ? prefs.setString('username', "$userName")
        : userName = prefs.getString("username");
    isLoggedIn != true
        ? prefs.setString('password', "$password")
        : password = prefs.getString("password");

    request = LoginRequest(
      appId: "${GlobalValues.appId}",
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      sphereUrl: "${GlobalValues.sphereUrl}",
      password: password,
      username: userName,
    );

    LoginApi loginApi = LoginApi();
    await loginApi.getLogin(request).then((value) {
      // new Future.delayed(new Duration(seconds: 0), () {
      //  Navigator.pop(context); //pop dialog
      // });

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
          // debugPrint("tokenValue --->  ${value.data[0].userToken}");
          if (value.data[0].employees.length > 1) {
            _onLoading(value.data[0].employees, context, isLoading, setState,
                isLoggedIn);
          } else if (tokenValue.isNotEmpty) {
            GlobalValues.loginEmployee = value.data[0].employees[0];
            debugPrint(
                "Login SphereTypeId ===== ${GlobalValues.loginEmployee.sphereTypeId} ");
            debugPrint(
                "Login contactId ===== ${GlobalValues.loginEmployee.contactId} ");
            drawerRequest = DrawerRequest(
                employeeId: GlobalValues.loginEmployee.employeeId.toString());
            getTabRights(context, isLoading, setState, isLoggedIn);
            getCreateNewProjectData();
            //  goToHomeAfterLogin();
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

  Future getTabRights(BuildContext context, bool isLoading, Function setState,
      bool isLoggedIn) async {
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
        isLoggedIn != true
            ? goToHomeAfterLogin(context, isLoading, setState)
            : null;
        setState(() {
          isLoading = false;
        });
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

  Future goToHomeAfterLogin(
      BuildContext context, bool isLoading, Function setState) {
    /*  final snackBar = SnackBar(
      content: Text('Welcome !'),
      backgroundColor: ColorConst.successSnackBarColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
    // showAlertDialog(context);
    /*  Navigator
        .of(context)
        .pushReplacementNamed(
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(isLoggedIn: true)
        )
    );*/

    Navigator.popAndPushNamed(context, '/homePage',
        arguments: {
          "isLogin": true,
          //  "cust": dropValue,
        },
        result: false);
  }
}
