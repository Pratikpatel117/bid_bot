import 'package:bidbot/api/login_and_signUp/forgot_api.dart';
import 'package:bidbot/model/login_and_signUp/forgot_model.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final username = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool forgot = false;
  ForgotRequest forgotRequest;
  showAlertDialog(BuildContext context) {
    // set up the button

    //   Widget okButton = TextButton(
    //   child: Text("OK"),
    //   onPressed: () {},
    // );

    // Widget okButton = TextButton(
    //   child: Text("OK"),
    //   onPressed: () {},
    // );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Forgot Successfully"),
      content: //(forgot == true)?
          Image.asset('asset/image/loginstoast.png'),
      //   : Image.asset('asset/image/loginfailtoast.png'),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getForgotEmail() async {
    ForgotApi forgotApi = ForgotApi();
    await forgotApi.getForgot(forgotRequest).then((value) {
      var result = value.status;
      debugPrint("forgot Api Status===$result");
      if (result == true) {
        final snacbar = SnackBar(
          content: Text("Successfully forgot"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
        showAlertDialog(context);
        Navigator.pop(context);
      } else {
        final snacbar = SnackBar(
          content: Text(value.message),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
      }
    });
  }

  bool forgotValid() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    forgotRequest = ForgotRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffffffff),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 6),
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('asset/image/tristate1.png'),
                    Image.asset('asset/image/bid-bot-logo.png'),
                  ],
                ),
              ),
              Container(
                child: Image.asset(
                  'asset/image/background_image.png',
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: [
                    Text(
                      'FORGOT PASSWORD',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: username,
                            onSaved: (forgotEmail) {
                              forgotRequest.emailAddress = forgotEmail;
                            },
                            validator: (value) {
                              // setState(() {
                              return !isEmail(value)
                                  ? "Email is required"
                                  : null;
                              // });
                              // return null;
                              // (save.contains('@')) ? null : 'Enter required Id';
                              // if (save.contains('@')) {
                              //   return null;
                              // }
                              // return 'Email is Required';
                            },
                            decoration: new InputDecoration(
                                /*enabledBorder: OutlineInputBorder(                     //change border of enable textfield
                                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                  borderSide: BorderSide(color: colorValue),),
                                   focusedBorder: OutlineInputBorder(        //focus boarder
                                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                  borderSide: BorderSide(color: colorValue),
                                ),*/
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff4381b7),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xffececec),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                    //error boarder
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.red)),
                                isDense: true,
                                counterText: "",
                                // errorText: 'sdhf',
                                errorStyle: TextStyle(
                                    height: 0,
                                    decoration: TextDecoration.underline),
                                contentPadding: EdgeInsets.fromLTRB(10, 20, 10,
                                    0), //padding according to your need
                                hintText: "Email *",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        if (forgotValid() == true) {
                          setState(() {
                            getForgotEmail();
                          });
                        } else {
                          setState(() {
                            forgot = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xff58bee9),
                        ),
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /* onSaved: (submit) {
                      request.username = submit;
                    },*/
              /*
                    validator: (save) {
                      // (save.contains('@')) ? null : 'Enter required Id';
                      if (save.contains('@')) {
                        return null;
                      }
                      return 'Enter required Id';
                    },
                    controller: username,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black12,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter Id',
                      hintStyle: TextStyle(
                        color: Colors.black87,
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue,
                  ),
                  alignment: Alignment.center,
                  height: 55,
                  width: 100,
                  child: Text(
                    'SignIn',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
