import 'dart:convert';
import 'dart:io';

import 'package:bidbot/api/profile_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../signup_page/signup_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool newValue = false;
  bool isLoading = true, isEdit = false;
  String userName = "";
  String phoneNumber;
  String codeWithNumber;
  ProfileUpdateRequest profileRequest;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final phoneNumberController = TextEditingController();
  String _activity = '+1';
  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  final nameControl = TextEditingController();
  final emailControl = TextEditingController();
  final phoneControl = TextEditingController();
  final companyControl = TextEditingController();
  String profileFile;
  String companyProfileLogo;
  File companyLogo;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String isCopyToMe = "0";
  bool isDeleteEmpPhoto = false;
  String isDeletePhoto = "0";
  bool isCompanyLogoDelete = false;
  String isCompanyLogo = "0";
  Future<ProfileResponse> futureProfile;
  DateTime now = DateTime.now();

  void checkBox(bool value) {
    setState(() {
      newValue = value;
      if (newValue == true) {
        isCopyToMe = "1";
      } else {
        isCopyToMe = "0";
      }
      // debugPrint("is CheckBox Value == $newValue");
      debugPrint("is CopyTome Value == $isCopyToMe");
    });
  }

  @override
  void initState() {
    super.initState();
    futureProfile = getProfileData();
    userName = "";
  }

  Future<ProfileResponse> getProfileData() async {
    setState(() {
      isLoading = true;
    });

    ProfileApi profileApi = ProfileApi();

    var data = await profileApi.getProfileApiData();
    setState(() {
      isLoading = false;
    });
    nameControl.text = data.data.name;
    phoneControl.text = data.data.phone;
    companyControl.text = data.data.companyName;
    GlobalValues.loginEmployee.name = nameControl.text;
    return Future.value(data);
  }

  Future updateProfile(ProfileResponse profileData) async {
    isLoading = true;
    profileRequest = ProfileUpdateRequest(
      name: nameControl.text.isEmpty ? profileData.data.name : nameControl.text,
      phone:
          phoneControl.text.isEmpty ? profileData.data.phone : codeWithNumber,
      companyName: (GlobalValues.loginEmployee.sphereTypeId == 2)
          ? companyControl.text.isEmpty
              ? profileData.data.companyName
              : companyControl.text
          : null,
      companyId: profileData.data.companyId.toString(),
      isCopyToMe: isCopyToMe,
      isDeletePhoto: isDeletePhoto,
      isDeleteCompanyLogo: isCompanyLogo,
      photo: profileFile == null
          ? null
          : base64Encode(File(profileFile).readAsBytesSync()),
      companyLogo: companyProfileLogo == null
          ? null
          : base64Encode(File(companyProfileLogo).readAsBytesSync()),
    );

    ProfileApi profileApi = ProfileApi();
    await profileApi.updateProfile(profileRequest).then((value) {
      var result = value.status;
      debugPrint("Profile Api Update Status===$result");
      if (result == true) {
        final snacbar = SnackBar(
          content: Text(value.message),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
        // Navigator.pop(context);
        setState(() {
          getProfileData();
        });
      } else {
        final snacbar = SnackBar(
          content: Text(value.message),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void employeePhoto() async {
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // final file = File(result.files.single.path).readAsBytesSync();
      // uploadImage(fileConvert)
      setState(() {
        profileFile = result.files.single.path;
      });
    } else {}
  }

  Future<void> uploadCompanyLogo() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        companyProfileLogo = result.files.single.path;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/image/animation/bid-bot-loader-2.gif',
              height: 150,
              width: 150,
            ),
            Text('Loading Profile Data'),
          ],
        ),
      );
    } else {
      return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
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
          Locale("zh"),
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: FutureBuilder<ProfileResponse>(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                    ),
                    child: ListView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                            key: formState,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Basic Information',
                                      style: TextstyleConst.HeaderTitlePage,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 110,
                                      width: 110,
                                      // alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 12, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: profileFile != null
                                          ? Image.file(File(profileFile))
                                          : Image.network(
                                              'https://www.myciright.com/Ciright/ajaxCall-photo.htm?flag=employeePhoto&compress=0&id=${GlobalValues.loginEmployee.employeeId}',
                                            ),
                                    ),
                                    Visibility(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red[800],
                                              size: 30,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                profileFile = null;
                                                // File(profileFile)
                                                //     .delete(recursive: true);
                                                isDeletePhoto =
                                                    isDeleteEmpPhoto == true
                                                        ? "0"
                                                        : "1";
                                                debugPrint(
                                                    "isDelete Employ Photo ===== $isDeletePhoto");
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              employeePhoto();
                                            },
                                            child: Icon(
                                              Icons.file_upload,
                                              color: Colors.blue[800],
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      visible: isEdit,
                                    ),
                                  ],
                                ),
                                // Form(child: child)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style:
                                          TextStyle(color: Color(0xff4F4F4F)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 10),
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      onSaved: (nameSave) {
                                        // profileRequest.name = nameSave;
                                      },
                                      cursorColor: Colors.black,
                                      controller: nameControl,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Name is Required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      enabled: isEdit,
                                      decoration: InputDecoration(
                                        hintText: snapshot.data.data.name,
                                        // GlobalValues.profileData.name.isNotEmpty
                                        //     ? GlobalValues.profileData.name
                                        //     : userName,
                                        errorStyle: TextStyle(
                                          height: 0.4,
                                          fontSize: 11,
                                        ),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 20, 10, 0),
                                        //padding according to your need
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: ColorConst
                                                  .InputFocusedBorderColor,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: ColorConst
                                                  .InputEnableProfileBorderColor,
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Color(0xff4381b7),
                                              width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style:
                                          TextStyle(color: Color(0xff4F4F4F)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 10),
                                  child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      /*  onSaved: (nameSave) {
                                   //    profileRequest = nameSave;
                                    },*/
                                      cursorColor: Colors.black,
                                      controller: emailControl,
                                      keyboardType: TextInputType.name,
                                      /*   validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Email is Required';
                                      } else {
                                        return null;
                                      }
                                    },*/
                                      // initialValue: emailControl != null ? emailControl.text : (GlobalValues.profileData?.email),
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: snapshot.data.data.email,
                                        //  GlobalValues.profileData.email,
                                        errorStyle: TextStyle(
                                          height: 0.4,
                                          fontSize: 11,
                                        ),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 20, 10, 0),
                                        //padding according to your need
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: ColorConst
                                                  .InputFocusedBorderColor,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: ColorConst
                                                  .InputEnableProfileBorderColor,
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Color(0xff4381b7),
                                              width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone',
                                      style:
                                          TextStyle(color: Color(0xff4F4F4F)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: ColorConst
                                              .InputEnableBorderColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        isEdit == true
                                            ? CountryCodePicker(
                                                flagWidth: 20,
                                                initialSelection: 'US',
                                                favorite: ['+1', 'US'],
                                                // countryFilter: ['US','IN'],
                                                /* onInit: (call){
                            debugPrint('fsdfs ${call.}');
                          },*/
                                                showOnlyCountryWhenClosed:
                                                    false,
                                                showCountryOnly: false,
                                                showDropDownButton: true,
                                                padding: EdgeInsets.all(0),
                                                alignLeft: false,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    debugPrint(
                                                        "print Country Code=== ${newValue.dialCode}");
                                                    _activity =
                                                        newValue.dialCode;
                                                    switch (newValue.dialCode) {
                                                      case '+1':
                                                        _phoneNumberFormatter =
                                                            NumberTextInputFormatter(
                                                                1);
                                                        break;
                                                      case '+91':
                                                        _phoneNumberFormatter =
                                                            NumberTextInputFormatter(
                                                                91);
                                                        break;
                                                    }
                                                  });
                                                },
                                              )
                                            : Container(),
                                        Expanded(
                                          child: TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            onChanged: (value) {
                                              setState(() {
                                                phoneNumber = value;
                                                codeWithNumber =
                                                    "$_activity${phoneNumber.split("(").join("").split(")").join().split(" ").join("").split("-").join(""
                                                        "")}";
                                                debugPrint(
                                                    "final number formate ===$codeWithNumber");
                                              });
                                            },
                                            controller: phoneControl,
                                            enabled: isEdit,
                                            inputFormatters: [
                                              (_phoneNumberFormatter
                                                          .whichNumber ==
                                                      1)
                                                  ? LengthLimitingTextInputFormatter(
                                                      14)
                                                  : LengthLimitingTextInputFormatter(
                                                      11),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              // Fit the validating format.s
                                              _phoneNumberFormatter,
                                            ],
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Phone',
                                              errorStyle: TextStyle(
                                                height: 0.5,
                                                fontSize: 11,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 0, 12),
                                              hintStyle: TextstyleConst
                                                  .addSubmittalsTextFieldStyle,
                                              alignLabelWithHint: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                (GlobalValues.loginEmployee.sphereTypeId == 1)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: newValue,
                                            onChanged: checkBox,
                                          ),
                                          Text(
                                            'Copy to me',
                                            style: TextStyle(
                                              color: Color(0xff4F4F4F),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Text(
                                  'Company Information',
                                  style: TextstyleConst.HeaderTitlePage,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Company Name',
                                        style:
                                            TextStyle(color: Color(0xff4F4F4F)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 10),
                                  child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      onSaved: (nameSave) {
                                        // profileRequest.companyName = nameSave;
                                      },
                                      cursorColor: Colors.black,
                                      controller: companyControl,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Company Name is Required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            snapshot.data.data.companyName,
                                        // GlobalValues.profileData.companyName,
                                        errorStyle: TextStyle(
                                          height: 0.4,
                                          fontSize: 11,
                                        ),
                                        enabled: isEdit,
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 20, 10, 0),
                                        //padding according to your need
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: ColorConst
                                                  .InputFocusedBorderColor,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: ColorConst
                                                  .InputEnableProfileBorderColor,
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Color(0xff4381b7),
                                              width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Company Logo',
                                      style:
                                          TextStyle(color: Color(0xff4F4F4F)),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (companyProfileLogo != null)
                                      Container(
                                        child: Image.file(
                                          File(companyProfileLogo),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    else
                                      Image.network(
                                        "https://www.myciright.com/Ciright/ajaxCall-photo.htm?flag=customerCompanyLogo&compress=0&id=${snapshot.data.data.companyId}&random=$now",
                                        //File(companyProfileLogo).readAsBytesSync(),
                                        height: 60,
                                        width: 60,
                                      ),
                                    Visibility(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red[800],
                                              size: 30,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                companyProfileLogo = null;
                                                // File(companyProfileLogo)
                                                //     .delete(recursive: false);
                                                isCompanyLogoDelete == true
                                                    ? isCompanyLogo = "0"
                                                    : isCompanyLogo = "1";
                                                debugPrint(
                                                    "isDelete Company Photo ===== $isCompanyLogo");
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await uploadCompanyLogo();
                                            },
                                            child: Icon(
                                              Icons.file_upload,
                                              color: Colors.blue[800],
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      visible: isEdit,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isEdit = true;
                                        });
                                      },
                                      child: (isEdit == false)
                                          ? Container(
                                              margin: EdgeInsets.only(top: 12),
                                              height: 36,
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  120,
                                              decoration: BoxDecoration(
                                                color: Color(0xff252669),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      submitButtonTap(
                                                          snapshot.data);
                                                      isEdit = !isEdit;
                                                    });
                                                  },
                                                  child: ColorFullButton(
                                                      buttonName: "Submit",
                                                      buttonColor:
                                                          submitButtonColor),
                                                ),
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isEdit = !isEdit;
                                                    });
                                                  },
                                                  child: ColorFullButton(
                                                    buttonName: 'Cancel',
                                                    buttonColor:
                                                        cancelButtonColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ]);
              } else {
                return Visibility(
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
                );
              }
            },
          ),
        ),
      );
    }
  }

  void submitButtonTap(ProfileResponse getData) async {
    if (buttonPress() == true) {
      updateProfile(getData);
    } else {
      debugPrint("Profile Update Validation Failed");
    }
  }

  bool buttonPress() {
    final form = formState.currentState;
    if (form.validate()) {
      form?.save();
      return true;
    }
    return false;
  }
}

/*ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Basic Information',
                  style: TextstyleConst.HeaderTitlePage,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  // alignment: Alignment.center,
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 12, right: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: profileFile != null
                      ? Image.file(profileFile)
                      : Image.network(
                          'https://www.myciright.com/Ciright/ajaxCall-photo.htm?flag=employeePhoto&compress=0&id=${GlobalValues.loginEmployee.employeeId}',
                        ),
                ),
                Visibility(
                  child: Row(
                    children: [
                      InkWell(
                        child: Image.asset("asset/image/delete.png"),
                        onTap: () {
                          setState(() {
                            profileFile = null;
                            isDeletePhoto = isDeleteEmpPhoto == true ? "0" : "1";
                            debugPrint("isDelete Employ Photo ===== $isDeletePhoto");
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          employeePhoto();
                        },
                        child: Image.asset("asset/image/uploade.png"),
                      ),
                    ],
                  ),
                  visible: isEdit,
                ),
              ],
            ),
            // Form(child: child)
            Text(
              'Name',
              style: TextStyle(color: Color(0xff4F4F4F)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  onSaved: (nameSave) {
                    // profileRequest.name = nameSave;
                  },
                  cursorColor: Colors.black,
                  controller: nameControl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name is Required';
                    } else {
                      return null;
                    }
                  },
                  enabled: isEdit,
                  decoration: InputDecoration(
                    hintText: GlobalValues.profileData.name.isNotEmpty
                        ? GlobalValues.profileData.name
                        : userName,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorConst.InputFocusedBorderColor,
                          width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorConst.InputEnableProfileBorderColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: TextStyle(color: Color(0xff4F4F4F)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Container(
                height: 40,
                child: TextFormField(
                  onSaved: (nameSave) {
                    // profileRequest = nameSave;
                  },
                  cursorColor: Colors.black,
                  controller: emailControl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email is Required';
                    } else {
                      return null;
                    }
                  },
                  // initialValue: emailControl != null ? emailControl.text : (GlobalValues.profileData?.email),
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: GlobalValues.profileData.email,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorConst.InputFocusedBorderColor,
                          width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorConst.InputEnableProfileBorderColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Phone',
                  style: TextStyle(color: Color(0xff4F4F4F)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                height: 40,
                child: TextFormField(
                  onSaved: (nameSave) {
                    // profileRequest.phone = nameSave;
                  },
                  cursorColor: Colors.black,
                  controller: phoneControl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Number is Required';
                    } else {
                      return null;
                    }
                  },
                  enabled: isEdit,
                  decoration: InputDecoration(
                    hintText: GlobalValues.profileData.phone,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorConst.InputFocusedBorderColor,
                          width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorConst.InputEnableProfileBorderColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: newValue,
                  onChanged: checkBox,
                ),
                Text(
                  'Copy to me',
                  style: TextStyle(
                    color: Color(0xff4F4F4F),
                  ),
                ),
              ],
            ),
            Text(
              'Company Information',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: StringConst.FONT_FAMILY),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: Text(
                'Company Name',
                style: TextStyle(color: Color(0xff4F4F4F)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Container(
                height: 40,
                child: TextFormField(
                  onSaved: (nameSave) {
                    // profileRequest.companyName = nameSave;
                  },
                  cursorColor: Colors.black,
                  controller: companyControl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Company Name is Required';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: GlobalValues.profileData.companyName,
                    errorStyle: TextStyle(
                      height: 0.4,
                      fontSize: 11,
                    ),
                    enabled: isEdit,
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    //padding according to your need
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
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
                          color: ColorConst.InputEnableProfileBorderColor,
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
            Text(
              'Company Logo',
              style: TextStyle(color: Color(0xff4F4F4F)),
            ),
            companyLogo != null
                ? Container(
                    child: Image.file(
                      companyLogo,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(),
            Visibility(
              child: Row(
                children: [
                  InkWell(
                    child: Image.asset("asset/image/delete.png"),
                    onTap: () {
                      setState(() {
                        companyLogo = null;
                        isCompanyLogoDelete == true ? isCompanyLogo = "0" :  isCompanyLogo = "1";
                        debugPrint("isDelete Company Photo ===== $isCompanyLogo");

                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        File file = File(result.files.single.path);
                        setState(() {
                          companyLogo = file;
                        });
                      } else {}
                    },
                    child: Image.asset("asset/image/uploade.png"),
                  ),
                ],
              ),
              visible: isEdit,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isEdit = true;
                    });
                  },
                  child: (isEdit == false)
                      ? Container(
                          margin: EdgeInsets.only(top: 12),
                          height: 36,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 120,
                          decoration: BoxDecoration(
                            color: Color(0xff252669),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Row(
                          children: [
                            InkWell(
                              onTap: () {
                                submitButtonTap();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 12),
                                height: 36,
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                  color: Color(0xff228A11),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isEdit = !isEdit;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 12),
                                height: 36,
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                  color: Color(0xffEE3737),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),*/
