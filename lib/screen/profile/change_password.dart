import 'package:bidbot/api/login_and_signUp/change_password_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/login_and_signUp/change_password_model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/routes.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false;
  bool passwordview = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final currentPass = TextEditingController();
  final newPass = TextEditingController();
  final reNewPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ChangePasswordRequest changePasswordRequest;
  ProfileData profileData;
  String isEmail = "1";
  /*= ChangePasswordRequest(
      isEmail: GlobalValues.profileData.email,
      userId: GlobalValues.loginEmployee.employeeId.toString(),
  );*/

  @override
  void initState() {
    debugPrint("Change Call InitState Call");
    //  getChangePassword();
    changePasswordRequest = ChangePasswordRequest();
    debugPrint("api token value === ${GlobalValues.apiHeaders}");

    /*  changePasswordRequest = ChangePasswordRequest(
      isEmail: GlobalValues.profileData.email,
      // oldPassword: currentPass.text.toString(),
      // newPassword: newPass.text.toString(),
      userId: GlobalValues.loginEmployee.employeeId.toString(),
    );*/
    super.initState();
  }

  void clearText() {
    currentPass.clear();
    newPass.clear();
    reNewPass.clear();
  }

  void passwordView() {
    setState(() {
      passwordview = !passwordview;
    });
  }

  Future getChangePassword() async {
    setState(() {
      isLoading = true;
    });
    changePasswordRequest = ChangePasswordRequest(
      isEmail: isEmail,
      oldPassword: currentPass.text.toString(),
      newPassword: newPass.text.toString(),
      userId: GlobalValues.loginEmployee.employeeId.toString(),
    );

    ChangePasswordApi changePassword = ChangePasswordApi();
    await changePassword.getChangePass(changePasswordRequest).then((value) {
      var result = value.status;
      debugPrint("forgot Api Status===$result");
      debugPrint("forgot Api Message ===${value.message}");
      debugPrint("forgot Api Data ===${value.data}");
      if (result == true) {
        final snacbar = SnackBar(
          content: Text("Password Updated Successfully"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
        // BiddingPage();
        // Navigator.pop(context);
        // logout();
      } else {
        final snacbar = SnackBar(
          content: Text("Password Not Updated"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  bool changeValid() {
    final form = _formKey.currentState;
    if (newPass.text != reNewPass.text) {
      final snackbar = SnackBar(
        content: Text("Password Not Matched"),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    if (form.validate() && newPass.text == reNewPass.text) {
      form.save();
      // newPass = reNewPass;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Change Password'),
        actions: [
          /* InkWell(
              onTap: () {
                  Navigator.popAndPushNamed(context, "/addServiceRequest");},
              child: Icon(
                Icons.add_outlined,
                size: 32,
              ),
            ),*/
          PopBackAction(),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 12, right: 12),
                    child: Column(
                      children: [
                        /*   Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Change Password',
                              style: TextstyleConst.HeaderTitlePage,
                            ),
                          ],
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Current Password',
                                style: TextStyle(color: Color(0xff4F4F4F)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              onSaved: (nameSave) {
                                changePasswordRequest.oldPassword = nameSave;
                              },
                              cursorColor: Colors.black,
                              controller: currentPass,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'password is Required';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "current Password",
                                // GlobalValues.profileData.name.isEmpty ? "" : GlobalValues.profileData.name,
                                errorStyle: TextStyle(
                                  height: 0.4,
                                  fontSize: 11,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 20, 10, 0),
                                //padding according to your need
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: ColorConst.InputFocusedBorderColor,
                                      width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: ColorConst
                                          .InputEnableProfileBorderColor,
                                      width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Color(0xff4381b7), width: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'New Password',
                              style: TextStyle(color: Color(0xff4F4F4F)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              onSaved: (nameSave) {
                                changePasswordRequest.newPassword = nameSave;
                              },
                              cursorColor: Colors.black,
                              obscureText: passwordview,
                              controller: newPass,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'New Password is Required';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: passwordView,
                                    child: Icon(
                                      passwordview
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    )),
                                hintText: "New Password",
                                //GlobalValues.profileData.email,
                                errorStyle: TextStyle(
                                  height: 0.4,
                                  fontSize: 11,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 20, 10, 0),
                                //padding according to your need
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: ColorConst.InputFocusedBorderColor,
                                      width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: ColorConst
                                          .InputEnableProfileBorderColor,
                                      width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Color(0xff4381b7), width: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Re-enter Password',
                              style: TextStyle(color: Color(0xff4F4F4F)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              onSaved: (nameSave) {
                                changePasswordRequest.newPassword = nameSave;
                              },
                              cursorColor: Colors.black,
                              obscureText: passwordview,
                              controller: reNewPass,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Confirmed Password is Required';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: passwordView,
                                    child: Icon(
                                      passwordview
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    )),
                                hintText: 'Re-enter Password',
                                errorStyle: TextStyle(
                                  height: 0.4,
                                  fontSize: 11,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 20, 10, 0),
                                //padding according to your need
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: ColorConst.InputFocusedBorderColor,
                                      width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: ColorConst
                                          .InputEnableProfileBorderColor,
                                      width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Color(0xff4381b7), width: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (changeValid() == true) {
                                  setState(() {
                                    getChangePassword();
                                    clearText();
                                    debugPrint(
                                        "  Current & New Password ---- ${currentPass.text}  &&  ${newPass.text}  ");
                                    // Navigator.pop(context);
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                height: 36,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width - 160,
                                decoration: BoxDecoration(
                                  color: Color(0xff228A11),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Color(0xfff5f5f5)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
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
                  Text('Loading List'),
                ],
              ),
            ),
            visible: isLoading,
          ),
        ],
      ),
    );
  }

  /*void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("username");
    Navigator.pushNamedAndRemoveUntil(context, loginPage, (route) => false);
    GlobalValues.userToken = null;
    GlobalValues.loginEmployee = null;
    GlobalValues.selectedBidIndex = 0;
    GlobalValues.calenderView = true;
    GlobalValues.drawerListData.clear();
    TabRights.tabListData.clear();
    TabRights.sideMenuBidding.clear();
    TabRights.iconsBidding.clear();
    GlobalValues.manageBidData?.clear();
  }*/
}
