import 'package:bidbot/api/active_and_archive_project/service_request/add_service_request_api.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/model/active_and_archive_project/service_request/add_service_request_model.dart';
import 'package:bidbot/screen/active_and_archive_project/service_request/service_request_page.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../api/bidding/bidders/add_bidder_api.dart';
import '../../../const/color_const.dart';
import '../../../const/string_const.dart';
import '../../../const/widget.dart';
import '../../../model/bid_Inquiry/create_new_project_model.dart';
import '../../signup_page/signup_page.dart';

class AddServiceRequestPage extends StatefulWidget {
  const AddServiceRequestPage({Key key}) : super(key: key);

  @override
  _AddServiceRequestPageState createState() => _AddServiceRequestPageState();
}

class _AddServiceRequestPageState extends State<AddServiceRequestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final descriptionController = TextEditingController();
  final serialNumberController = TextEditingController();

  bool isLoading = false;
  List<DrawerData> subTypeList;
  DrawerData selectSubType;
  List<LineItemsEquipmentData> equipmentList = [];
  LineItemsEquipmentData equipmentData;
  List<DrawerData> contactList;
  DrawerData selectContact;
  List<Equipments> listEquipment = [];

  Equipments equipments;
  Submitservicerequest submitservicerequest;
  int selectionIndex = 0;

  bool isAddContact = false;
  String customerId = "${GlobalValues.loginEmployee.customerId}";
  String phoneNumber;
  String codeWithNumber;
  String projectId = " ";
  String checkboxindex;
  String arr;
  String equipmentid = " ";
  String serialnumber = " ";

  String _activity = '+1';
  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  bool _hasBeenPressedsubmit = false;
  bool _hasBeenPressedclose = false;
  List<String> tempArr = [];
  List<Equipments> equipmentarr = [];

  bool isChecked = false;
  void checkboxCallback(bool checkboxState) {
    setState(() {
      isChecked = checkboxState;
    });
  }

  void clearText() {
    nameController.clear();
    numberController.clear();
    emailController.clear();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 3) {
      projectId =
          "${ActiveProjectGlobalValue.activeProjectServiceRequestProjectId}";
    } else if (GlobalValues.selectedBidIndex == 4) {
      projectId =
          "${ActiveProjectGlobalValue.activeProjectServiceRequestProjectId}";
    }
    getLineItemDetails(projectId);
    getSubTypeDrawer();
    getContactData(customerId);
    //getServiceRequest();
  }

  /* validation() async {
    descriptionController.text.isEmpty ? _validate = true : _validate = false;
    nameController.text.isEmpty ? _validate = true : _validate = false;
    emailController.text.isEmpty;
    numberController.text.isEmpty ? _validate = true : _validate = false;
  }*/
  //final bool checkboxvalue = checkbox.singleWhere((element) => element.isDone == false,orElse: null);

  Future submitservicedata() async {
    print(equipmentList.length);

    equipmentList.forEach((element) {
      if (element.isDone) {
        equipmentarr.add(Equipments(
          equipmentId: element.equipmentId,
          serialNumber: element.serialNumber,
          /*serialNumberController
              .text, != null
                ? equipments.serialNumber
                : serialNumberController.text*/
        ));
        print("equipmentid: ${element.equipmentId}, isDone: ${element.isDone}");

        print("${equipmentarr.length}");
      }
      // print("equipmentid: ${element.equipmentId}, isDone: ${element.isDone}");
    });
    //print("${equipmentarr.first}");

    //  equipmentList.addAll();
    AddServiceRequestApi addServiceRequestApi = AddServiceRequestApi();

    submitservicerequest = Submitservicerequest(
        subTypeId: selectSubType.key,
        contactId: selectContact != null ? selectContact.key : "-1",
        customerId: customerId,
        equipments: equipmentarr,
        loginEmployeeId: "${GlobalValues.loginEmployee.employeeId}",
        name: nameController.text,
        phone: codeWithNumber,
        email: emailController.text,
        description: descriptionController.text,
        projectId: projectId,
        subscriptionId: "${GlobalValues.subscriptionId}",
        verticalId: "${GlobalValues.verticalId}");

    await addServiceRequestApi
        .submitservicerequestdata(submitservicerequest)
        .then((value) {
      var status = value.status;
      debugPrint("update Add Service Request status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("New Service Request Data Added"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        Navigator.popAndPushNamed(context, "/serviceRequest");
      } else {
        final snackBar = SnackBar(
          content: Text("Please Select Line Items!"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        //ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    equipmentarr.clear();
  }

  Future getLineItemDetails(String projectId) async {
    setState(() {
      isLoading = true;
    });
    AddServiceRequestApi addServiceRequestApi = AddServiceRequestApi();
    List<LineItemsEquipmentData> list = [];
    await addServiceRequestApi.getLineItemsEquipmentData().then((value) {
      var apiResponce = value.status;
      debugPrint("LineItems details == $apiResponce");
      value.data.forEach((element) {
        list.add(element);
      });
    });
    setState(() {
      isLoading = false;
      equipmentList.addAll(list);
    });
    debugPrint("list index === ${equipmentList.length}");
  }

  AddBidderApi addBidderApi = AddBidderApi();

  getSubTypeDrawer() async {
    setState(() {
      isLoading = true;
    });
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1349409/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}")
        .then((value) {
      setState(() {
        subTypeList = value.data;
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  getContactData(String customerId) async {
    setState(() {
      isLoading = true;
      // contactData.clear();
    });
    await addBidderApi
        .getAddBidderDropDownApi("${StringConst.API}m1344812/$customerId")
        .then((value) {
      setState(() {
        contactList = value.data;
      });
      debugPrint("select state === ${StringConst.API}m1344812/$customerId");
    });
    selectContact = contactList.singleWhere(
        (element) => element.key == GlobalValues.loginEmployee.contactId,
        orElse: () => null);
    // debugPrint(
    //     "${StringConst.API}m1344812/${GlobalValues.loginEmployee.contactId}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        Locale("zh")
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff252669),
          leading: Container(),
          titleSpacing: -30,
          title: Text('Add Service Requests'),
          actions: [
            //  PopBackAction(),
            Padding(
              padding: const EdgeInsets.only(right: 11),
              child: InkWell(
                child: Icon(
                  Icons.clear_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        body: isLoading != true
            ? SafeArea(
                child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ListView(children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sub Type",
                                  style: TextstyleConst.addSubmittalsBoldText,
                                ),
                                buildDropdownButton(
                                    "Select Sub Type",
                                    "",
                                    subTypeList,
                                    selectSubType,
                                    dropdownValueChanged,
                                    1),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Contact On-Site ",
                                    style: TextstyleConst.addSubmittalsBoldText,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        //color: Colors.black26,
                                        child: AbsorbPointer(
                                          absorbing: isAddContact,
                                          child: buildDropdownButton(
                                              "Select Contact",
                                              "Contact is required",
                                              contactList,
                                              selectContact,
                                              dropdownValueChanged,
                                              2),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // isLoading = false;
                                        setState(() {
                                          isAddContact = !isAddContact;
                                          //contactList.clear();
                                          selectContact = null;
                                          clearText();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 4),
                                        child: Container(
                                          height: 42,
                                          width: 42,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Color(0xff4381b7),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Icon(Icons.add,
                                              color: Color(0xff4381b7)),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                isAddContact == true
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 8),
                                        child: Container(
                                          height: 45,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                final snacbar = SnackBar(
                                                  content:
                                                      Text('Please Enter Name'),
                                                  backgroundColor: ColorConst
                                                      .failedSnackBarColor,
                                                );

                                                scaffoldMessengerKey
                                                    .currentState
                                                    .showSnackBar(snacbar);
                                                // ScaffoldMessenger.of(context).showSnackBar(snacbar);
                                              }
                                              return null;
                                            },
                                            onSaved: (nameSave) {
                                              // signUpRequest.name = nameSave;
                                            },
                                            cursorColor: Colors.black,
                                            controller: nameController,
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              hintText: 'Name',

                                              /* errorText: _validate
                                                    ? 'Please Enter Valid Field'
                                                    : null,*/
                                              errorStyle: TextStyle(
                                                height: 0.4,
                                                fontSize: 11,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10, 20, 10, 0),
                                              //padding according to your need
                                              hintStyle: TextstyleConst
                                                  .addSubmittalsTextFieldStyle,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide:
                                                    BorderSide(width: 1),
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
                                                        .InputEnableBorderColor,
                                                    width: 1),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Color(0xff4381b7),
                                                    width: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                isAddContact == true
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Container(
                                          height: 45,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                final snackbar = SnackBar(
                                                  content: Text(
                                                      'Please Enter Email'),
                                                  backgroundColor: ColorConst
                                                      .failedSnackBarColor,
                                                );
                                                scaffoldMessengerKey
                                                    .currentState
                                                    .showSnackBar(snackbar);

                                                // ScaffoldMessenger.of(context).showSnackBar(snacbar);
                                              }
                                              return null;
                                            },
                                            onSaved: (emailSave) {
                                              // signUpRequest.email = emailSave;
                                              debugPrint(
                                                  'email Address----$emailSave');
                                            },
                                            controller: emailController,
                                            cursorColor: Colors.black,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              hintText: 'Email',
                                              /* errorText: _validate
                                                    ? 'Please Enter Valid Field'
                                                    : null,*/
                                              errorStyle: TextStyle(
                                                height: 0.5,
                                                fontSize: 11,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10, 20, 10, 0),
                                              hintStyle: TextstyleConst
                                                  .addSubmittalsTextFieldStyle,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide:
                                                    BorderSide(width: 1),
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
                                                        .InputEnableBorderColor,
                                                    width: 1),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Color(0xff4381b7),
                                                    width: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                isAddContact == true
                                    ? Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: ColorConst
                                                  .InputEnableBorderColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            CountryCodePicker(
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
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    final snackbar = SnackBar(
                                                      content: Text(
                                                          'Please Enter ContactNo'),
                                                      backgroundColor: ColorConst
                                                          .failedSnackBarColor,
                                                    );

                                                    scaffoldMessengerKey
                                                        .currentState
                                                        .showSnackBar(snackbar);
                                                    //ScaffoldMessenger.of(context).showSnackBar(snacbar);
                                                  }
                                                  return null;
                                                },
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                onChanged: (value) {
                                                  setState(() {
                                                    phoneNumber = value;
                                                    codeWithNumber =
                                                        "$_activity${phoneNumber.split("(").join("").split(")").join().split(" ").join("").split("-").join(""
                                                            "")}";
                                                    debugPrint(
                                                        "phone number value === $_activity$phoneNumber"
                                                            .replaceAll(
                                                                "[(\)\\s-]+",
                                                                "")
                                                            .trim());
                                                    debugPrint(
                                                        "phone number value === $_activity${phoneNumber.replaceAll("[\\s\\-()]", "").trim()}");
                                                    debugPrint(
                                                        "phone number value === $_activity${phoneNumber.split("(").join("").split(")").join().split(" ").join("").split("-").join(""
                                                            "")}");
                                                    debugPrint(
                                                        "final number formate ===$codeWithNumber");
                                                    // debugPrint("phone number value -- ${phoneNumberController.text}".gsub(/\[.*?\]/, "");
                                                  });
                                                },
                                                controller: numberController,
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
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: 'Phone',
                                                  errorStyle: TextStyle(
                                                    height: 0.5,
                                                    fontSize: 11,
                                                  ),
                                                  hintStyle: TextstyleConst
                                                      .addSubmittalsTextFieldStyle,
                                                  alignLabelWithHint: true,
                                                  border: UnderlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    // height: 45,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          final snackbar = SnackBar(
                                            content: Text(
                                                'Please Enter Description'),
                                            backgroundColor:
                                                ColorConst.failedSnackBarColor,
                                          );
                                          scaffoldMessengerKey.currentState
                                              .showSnackBar(snackbar);

                                          //ScaffoldMessenger.of(context).showSnackBar(snacbar);
                                        }
                                        return null;
                                      },
                                      controller: descriptionController,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: "Description",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Line Items",
                                style: TextstyleConst.addSubmittalsLineItemText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final equipment = equipmentList[index];
                            return TaskTile(
                              equipmentId: equipment.equipmentId,
                              manufacturerName: equipment.manufacturer,
                              productName: equipment.product,
                              tag: equipment.tag,
                              terms: equipment.terms,
                              warranty: equipment.warranty,
                              startup: equipment,
                              isChecked: equipment.isDone,
                              serialNo: equipment.serialNumber,
                              checkboxCallback: (checkboxState) {
                                //   equipmentList.add(equipmentarray);
                                print(equipment.isDone);
                                setState(() {
                                  equipment.toggleDone();
                                  if (isChecked == null) {
                                    print("select checkbox");
                                  }
                                });
                              },
                              textfieldOnChange: (name) {
                                setState(() {
                                  equipment.setSerialNo(name);
                                });
                              },
                            );
                          },
                          itemCount: equipmentList.length,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    child: TransparentButton(
                                        colorCode: 0xff0098D4,
                                        buttonName: "Submit"),
                                    onTap: () {
                                      setState(() {
                                        if (buttonPress() == true) {
                                          setState(() {
                                            submitservicedata();
                                            /* debugPrint(
                                                "buttonPress Action === ${buttonPress()}");*/
                                          });
                                          debugPrint(
                                              "buttonPress Action === true");
                                          debugPrint(
                                              "first name ===  ${nameController.text}");
                                          debugPrint(
                                              "email name ===  ${emailController.text}");
                                          debugPrint(
                                              "number name ===  ${numberController.text}");
                                        } else {
                                          debugPrint(
                                              "buttonPress Action === false");
                                        }
                                      });
                                    }),
                                InkWell(
                                  child: TransparentButton(
                                      colorCode: 0xffEE3737,
                                      buttonName: "Close"),
                                  onTap: () {
                                    setState(() {
                                      Navigator.pop(context);
                                      debugPrint("");
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            : Visible(isLoading: isLoading, message: ""),
      ),
    );
  }

  bool buttonPress() {
    /* if (_formKey.currentState.validate()) {
      */ /*  ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('')),
                                      );*/ /*
    }
    final form = _formKey.currentState;
    if (form.validate()) {
      form?.save();
i    }*/

    if (selectSubType == null) {
      final snackbar = SnackBar(
        content: Text('Please Select SubType'),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      scaffoldMessengerKey.currentState.showSnackBar(snackbar);
      //ScaffoldMessenger.of(context).showSnackBar(snacbar);
      return false;
    } else if (selectContact == null &&
        numberController.text.isEmpty &&
        nameController.text.isEmpty &&
        emailController.text.isEmpty) {
      //  print("selected id: ${selectContact}");
      final snackbar = SnackBar(
        content:
            Text('Please Select either contact or Add new contact details'),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      scaffoldMessengerKey.currentState.showSnackBar(snackbar);
      //  ScaffoldMessenger.of(context).showSnackBar(snacbar);
      return false;
    } /*else if (isChecked == null) {
      final snackbar = SnackBar(
        content: Text('Select Line Items '),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      scaffoldMessengerKey.currentState.showSnackBar(snackbar);
      //ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return false;
    }*/
    else if (_formKey.currentState.validate()) {
      return true;
    } else {
      // return true;
    }
  }

  dropdownValueChanged(DrawerData value, int fieldId) {
    if (fieldId == 1) {
      setState(() {
        selectSubType = value;
      });
    }

    if (fieldId == 2) {
      setState(() {
        selectContact = value;
      });
    }
  }

  DropdownButtonFormField buildDropdownButton(
      String hintText,
      String errorText,
      List<DrawerData> listOfData,
      DrawerData selectList,
      Function(DrawerData value, int fieldId) dropdownValueChanged,
      int fieldId) {
    return DropdownButtonFormField(
      hint: Text(hintText),
      dropdownColor: Colors.white,
      isDense: true,
      isExpanded: true,
      elevation: 6,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 11,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xff4381b7), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff4381b7),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: ColorConst.InputFocusedBorderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: ColorConst.InputEnableBorderColor, width: 1),
        ),
        filled: true,

        contentPadding: EdgeInsets.fromLTRB(8, 0, 10, 0),
        //padding according to your need
        hintStyle: TextStyle(color: Colors.grey, fontSize: 9),
        // fillColor: Colors.white,
        fillColor: isAddContact == true && fieldId == 2
            ? Color(0xffCCCCCC)
            : Colors.white,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
      ),
      items: listOfData?.map((items) {
            return DropdownMenuItem(
              child: Text(items.value),
              value: items,
            );
          })?.toList() ??
          [],
      onChanged: (newValue) {
        dropdownValueChanged.call(newValue, fieldId);
      },
      value: selectList,
    );
  }
}

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String equipmentId;
  final String manufacturerName;
  final String productName;
  final String tag;
  final String terms;
  final String warranty;
  final String serialNo;
  final LineItemsEquipmentData startup;
  final TextEditingController serialNumberController;
  final Function checkboxCallback;
  final Function textfieldOnChange;

  TaskTile(
      {this.isChecked,
      this.equipmentId,
      this.manufacturerName,
      this.productName,
      this.tag,
      this.terms,
      this.warranty,
      this.serialNo,
      this.checkboxCallback,
      this.startup,
      this.serialNumberController,
      this.textfieldOnChange
      //serialNumberController.text = test();
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(manufacturerName),
            Text(productName),
          ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tag : $tag'),
          Text('Warranty : '),
          Text('Terms : $terms'),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "Start Up Required : ",
                style: TextStyle(
                  color: Color(0xff757575),
                  // color: Colors.grey,
                  fontSize: 14,
                  fontFamily: StringConst.FONT_FAMILY,
                ),
              ),
              WidgetSpan(
                child: InkWell(
                    child: startup.isStartUpRequired == "1"
                        ? Icon(
                            Icons.check_circle,
                            size: 17,
                            color: Colors.greenAccent,
                          )
                        : Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                            size: 17,
                          )),
              ),
            ]),
          ),
          Row(children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    text: "Serial Number : ",
                    style: TextStyle(
                      color: Color(0xff757575),
                      // color: Colors.grey,
                      fontSize: 14,
                      fontFamily: StringConst.FONT_FAMILY,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Container(
                  // width: 200,
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    //maxLines: 100,
                    // cursorHeight: 17,
                    cursorColor: Colors.black,
                    controller: serialNumberController,
                    keyboardType: TextInputType.multiline,
                    onChanged: textfieldOnChange,

                    /* decoration: InputDecoration(
                    //counterText: " ",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),*/
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
