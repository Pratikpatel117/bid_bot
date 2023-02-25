import 'package:bidbot/api/login_and_signUp/signup_api.dart';
import 'package:bidbot/api/login_and_signUp/term_and_condition_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/model/login_and_signUp/signup_model.dart';
import 'package:bidbot/model/login_and_signUp/term_and_condition_model.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:validators/validators.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    Key key,
    /*@required this.loginDropValue*/
  }) : super(key: key);

//final LoginSignUpValue loginDropValue;
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameControl = TextEditingController();
  final phoneControl = TextEditingController();
  final emailControl = TextEditingController();
  final passwordControl = TextEditingController();
  final companyControl = TextEditingController();
  bool newValue = false;
  bool password = true;

  SignUpRequest signUpRequest;
  bool verify = true;
  final List _allActivities = ['+1', '+91'];
  String _activity = '+1';
  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);
  List<TermAndConditionData> listOfTermAndCondition = [];

  Future getTermAndConditionData() async {
    TermAndConditionAPi termAndConditionAPi = TermAndConditionAPi();
    await termAndConditionAPi.getTermAndConditionApi().then((value) {
      var status = value.status;
      if (status == true) {
        listOfTermAndCondition = value.data;
      }
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Login Successfully"),
      content: Container(
          child: Expanded(
              child: Html(data: listOfTermAndCondition.first.content))),
/*ListView.builder(
        itemCount: listOfTermAndCondition.length,
        itemBuilder: (context , i){
          return Column(
            children: [
              Html(data: listOfTermAndCondition[i].content),
              // Text("${listOfTermAndCondition.last}"),
            ],
          );
        },
      ),*/
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        debugPrint(
            "term & condition == ${listOfTermAndCondition.first.content}");
        return alert;
      },
    );
    Navigator.pop(context);
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Image.asset(
                'asset/image/animation/bid-bot-loader-2.gif',
                height: 100,
                width: 100,
              ),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
  }

  Future getSignupData() async {
    _onLoading();
    SignUpApi signUpApi = SignUpApi();
    await signUpApi.getSignUp(signUpRequest).then((value) {
      bool signData = value.status;
      debugPrint('SignUp Response ===$signData');
      if (signData == true) {
        final snackBar = SnackBar(
          content: Text('Registration Successfully'),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        showAlertDialog(context);
        Navigator.pushReplacementNamed(
          context,
          '/login',
          /*(route) => false*/
          /* arguments: {
              "isLogin": value.status,
              "emp": value.data,
              //  "cust": dropValue,
            }*/
        );
        /*    Navigator.popAndPushNamed(context, '/home');
        Navigator.popAndPushNamed(context, '/home',
            (route) => false
            arguments: {
              "emp": value.data[0].employees[0],
          //    "cust": dropValue,
            });*/
      } else {
        new Future.delayed(new Duration(seconds: 0), () {
          Navigator.pop(context); //pop dialog
        });
        var message = value.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
  }

  void checkBox(bool value) {
    setState(() {
      newValue = value;
    });
  }

  bool signUpPage() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      checkBox(false);
      // checkBox(false) ? null : checkBox(true);
      return true;
    } else {
      return false;
    }
  }

  void passwordView() {
    setState(() {
      password = !password;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    signUpRequest = SignUpRequest(
        /*subscriptionId: widget.loginDropValue.subscriptionId,verticalId: widget.loginDropValue.verticalId,*/);
    // getTermAndConditionData();
    super.initState();
  }

  // signUpRequest = SignUpRequest(subscriptionId: widget.loginDropValue.subscriptionId,verticalId: widget.loginDropValue.verticalId,);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale("af"),
        Locale("am"),
        Locale("ar"),
        Locale("az"),
        Locale("be"),
        Locale("bg"),
        Locale("bn"),
        Locale("bs"),
        Locale("ca"),
        Locale("cs"),
        Locale("da"),
        Locale("de"),
        Locale("el"),
        Locale("en"),
        Locale("es"),
        Locale("et"),
        Locale("fa"),
        Locale("fi"),
        Locale("fr"),
        Locale("gl"),
        Locale("ha"),
        Locale("he"),
        Locale("hi"),
        Locale("hr"),
        Locale("hu"),
        Locale("hy"),
        Locale("id"),
        Locale("is"),
        Locale("it"),
        Locale("ja"),
        Locale("ka"),
        Locale("kk"),
        Locale("km"),
        Locale("ko"),
        Locale("ku"),
        Locale("ky"),
        Locale("lt"),
        Locale("lv"),
        Locale("mk"),
        Locale("ml"),
        Locale("mn"),
        Locale("ms"),
        Locale("nb"),
        Locale("nl"),
        Locale("nn"),
        Locale("no"),
        Locale("pl"),
        Locale("ps"),
        Locale("pt"),
        Locale("ro"),
        Locale("ru"),
        Locale("sd"),
        Locale("sk"),
        Locale("sl"),
        Locale("so"),
        Locale("sq"),
        Locale("sr"),
        Locale("sv"),
        Locale("ta"),
        Locale("tg"),
        Locale("th"),
        Locale("tk"),
        Locale("tr"),
        Locale("tt"),
        Locale("uk"),
        Locale("ug"),
        Locale("ur"),
        Locale("uz"),
        Locale("vi"),
        Locale("zh")
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      home: new Scaffold(
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('asset/image/tristate1.png'),
                Image.asset('asset/image/bid-bot-logo.png'),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('SIGN UP', style: TextstyleConst.SignUpTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 45,
                      child: BuildsTextEditingField(
                        onSaveMessage: signUpRequest.name,
                        nameControl: nameControl,
                        validateError: 'Name is Required',
                        hintText: 'Name *',
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: ColorConst.InputEnableBorderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CountryCodePicker(
                          // showFlag: true,
                          flagWidth: 20,
                          initialSelection: 'US',
                          favorite: ['+1', 'US'],
                          // countryFilter: ['US','IN'],
                          /* onInit: (call){
                          debugPrint('fsdfs ${call.}');
                        },*/
                          showOnlyCountryWhenClosed: false,
                          showCountryOnly: false,
                          showDropDownButton: true,
                          padding: EdgeInsets.all(0),
                          alignLeft: false,

                          onChanged: (newValue) {
                            setState(() {
                              debugPrint(
                                  "print Country Code=== ${newValue.dialCode}");
                              _activity = newValue.dialCode;
                              switch (newValue.dialCode) {
                                case '+1':
                                  _phoneNumberFormatter =
                                      NumberTextInputFormatter(1);
                                  break;
                                case '+91':
                                  _phoneNumberFormatter =
                                      NumberTextInputFormatter(91);
                                  break;
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (numberSave) {
                              signUpRequest.phone = numberSave;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Number is Required';
                              } else
                                return null;
                            },
                            controller: phoneControl,
                            //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            inputFormatters: [
                              (_phoneNumberFormatter.whichNumber == 1)
                                  ? LengthLimitingTextInputFormatter(14)
                                  : LengthLimitingTextInputFormatter(11),

                              // if(_phoneNumberFormatter._whichNumber == 1)
                              // LengthLimitingTextInputFormatter(11),
                              FilteringTextInputFormatter
                                  .digitsOnly, // Fit the validating format.
                              _phoneNumberFormatter,
                            ],
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Phone *',
                              errorStyle: TextStyle(
                                height: 0.5,
                                fontSize: 11,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              alignLabelWithHint: true,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              /* border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide( width: 1),
                            ),*/
                              /*focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: ColorConst.InputFocusedBorderColor, width: 1),
                            ),*/
                              /* enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: ColorConst.InputEnableBorderColor, width: 1),
                            ),*/
                              /*errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.red, width: 1),
                            ),*/
                              /*focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color:  ColorConst.InputEnableBorderColor, width: 1),
                            ),*/
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        onSaved: (emaiSave) {
                          signUpRequest.email = emaiSave;
                          debugPrint('email Address----$emaiSave');
                        },
                        controller: emailControl,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        // inputFormatters: [
                        //  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                        // ],
                        validator: (value) {
                          // (value.contains('@'))
                          return !isEmail(value) ? "email is required" : null;
                          // if (value.contains('@')) {
                          //   return null;
                          // }
                          // return 'Email is Required';
                        },
                        decoration: InputDecoration(
                          hintText: 'Email *',
                          errorStyle: TextStyle(
                            height: 0.5,
                            fontSize: 11,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                                color: ColorConst.InputEnableBorderColor,
                                width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Color(0xff4381b7), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    child: BuildsTextEditingField(
                        onSaveMessage: signUpRequest.password,
                        nameControl: passwordControl,
                        hintText: "Password *",
                        validateError: 'Password is Required'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 45,
                      child: BuildsTextEditingField(
                        nameControl: companyControl,
                        hintText: "Company *",
                        validateError: 'Company Name is Required',
                        onSaveMessage: signUpRequest.company,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: newValue,
                        onChanged: checkBox,
                      ),
                      Row(
                        children: [
                          Text(
                            'I agree to',
                            style: TextStyle(
                                fontFamily: StringConst.FONT_FAMILY,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/termAndCondition");
                              // debugPrint(
                              //     "term & condition == ${listOfTermAndCondition.first.content}");
                              // showAlertDialog(context);
                            },
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: StringConst.FONT_FAMILY,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      // setState(() {});
                      if (signUpPage() == true) {
                        getSignupData();
                        // signUpPage();
                        //    return Navigator.pushReplacementNamed(context, HOME_PAGE);
                      } else {
                        debugPrint('User Not SignUp');
                      }
                    },
                    child: Container(
                      height: 36,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xff58bee9),
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: StringConst.FONT_FAMILY,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              fontFamily: StringConst.FONT_FAMILY,
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontFamily: StringConst.FONT_FAMILY,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class BuildsTextEditingField extends StatelessWidget {
  BuildsTextEditingField({
    Key key,
    this.onSaveMessage,
    @required this.nameControl,
    @required this.hintText,
    this.validateError,
  }) : super(key: key);

  String onSaveMessage;
  final TextEditingController nameControl;
  final String validateError;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (nameSave) {
        // signUpRequest.name = nameSave;
        onSaveMessage = nameSave;
      },
      cursorColor: Colors.black,
      controller: nameControl,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value.isEmpty) {
          return validateError;
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        errorStyle: TextStyle(
          height: 0.4,
          fontSize: 11,
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        //padding according to your need
        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder:
            buildOutlineInputBorder(ColorConst.InputFocusedBorderColor),
        enabledBorder:
            buildOutlineInputBorder(ColorConst.InputEnableBorderColor),
        errorBorder: buildOutlineInputBorder(Colors.red),
        focusedErrorBorder: buildOutlineInputBorder(Color(0xff4381b7)),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(Color borderSideColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderSideColor, width: 1),
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  int whichNumber;

  NumberTextInputFormatter(this.whichNumber);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    switch (whichNumber) {
      case 1:
        {
          if (newTextLength >= 1) {
            newText.write('(');
            if (newValue.selection.end >= 1) selectionIndex++;
          }
          if (newTextLength >= 4) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
            if (newValue.selection.end >= 3) selectionIndex += 2;
          }
          if (newTextLength >= 7) {
            newText.write(
                newValue.text.substring(3, usedSubstringIndex = 6) + '-');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          if (newTextLength >= 11) {
            newText.write(
                newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
            if (newValue.selection.end >= 10) selectionIndex++;
          }
          break;
        }
      case 91:
        {
          if (newTextLength >= 5) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 5) + ' ');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          break;
        }
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
