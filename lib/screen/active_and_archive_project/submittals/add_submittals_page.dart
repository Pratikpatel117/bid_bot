// ignore_for_file: unnecessary_statements

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bidbot/api/active_and_archive_project/submittals/add_submittals_api.dart';
import 'package:bidbot/api/bidding/bidders/add_bidder_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/stateful_widget.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/add_submittals_model.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/screen/signup_page/signup_page.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../const/function_const.dart';

class AddSubmittalsPage extends StatefulWidget {
  const AddSubmittalsPage({Key key}) : super(key: key);

  @override
  _AddSubmittalsPageState createState() => _AddSubmittalsPageState();
}

class _AddSubmittalsPageState extends State<AddSubmittalsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final wantedDateController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipcodeController = TextEditingController();
  final markShipmentController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  bool isLoading = false;
  TabRequestSubmittals tabRequestSubmittals;
  SubmittalDetailsData submittalDetailsData;
  UploadSubmittalsRequest submittalsRequest;
  List<DrawerData> tabListData = [];
  DrawerData selectSubmittal;
  List<DrawerData> countryData;
  DrawerData selectCountry;
  List<DrawerData> stateData;
  DrawerData selectState;
  List<DrawerData> contactData;
  DrawerData selectContact;
  String documentUrl;
  String document;
  String fileName;
  String fileSize;
  String wantedDate;
  String customerId = " ";
  bool isAddContact = false;
  String countryKeyId = " ";
  String phoneNumber;
  String codeWithNumber;

  // final List _allActivities = ['+1', '+91'];
  String _activity = '+1';
  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);
  List<String> documentList = [];
  // Color _dropboxColor = Colors.white;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubmittalsDetails();
    // conditionFunction();
    debugPrint("tabData Status == $documentUrl");
  }

  conditionFunction() {}
  AddSubmittalsApi addSubmittalsApi = AddSubmittalsApi();

  Future tabData() async {
    setState(() {
      isLoading = true;
    });
    tabRequestSubmittals = TabRequestSubmittals(
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      sphereTypeId: "${GlobalValues.loginEmployee.sphereTypeId}",
      // tabCode: 'project-notes',
    );
    await addSubmittalsApi
        .getTabListSubmittals(tabRequestSubmittals)
        .then((value) {
      var tabDataStatus = value.status;
      debugPrint("tabData Status == $tabDataStatus");
      setState(() {
        tabListData = value.data;
      });
    });
    selectSubmittal = tabListData.singleWhere(
        (element) => element.key == submittalDetailsData.submittalStatusId,
        orElse: () => null);
    setState(() {
      isLoading = false;
    });
  }

  Future uploadSubmittals() async {
    setState(() {
      isLoading = true;
    });
    submittalsRequest = UploadSubmittalsRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      fileName: fileName != null ? fileName : "",
      //.isNotEmpty ? fileName : ActiveProjectGlobalValue.submittalsData.fileName,
      fileSize: fileSize != null ? fileSize : "",
      document: document != null ? document : "",
      address: addressController.text,
      city: cityController.text,
      zip: zipcodeController.text,
      wantedShipDate: wantedDateController.text,
      equipmentId: ActiveProjectGlobalValue.submittalsData.equipmentId,
      submittalStatusId: selectSubmittal.key,
      markShipment: markShipmentController.text,
      submittalId: submittalDetailsData.submittalId,
      countryId: selectCountry.key.toString(),
      stateId: selectState.key.toString(),
      companyId: customerId.toString(),

/* firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneNumberController.text.isEmpty
          ? selectContact.key.toString() : null,*/

      contactId: selectContact != null ? selectContact.key : "-1",

      firstName: /* submittalDetailsData.contactId == null ||
          submittalDetailsData.contactId == "-1" && selectContact == null
          ?*/
          firstNameController.text,
      // : null,
      phone: /* submittalDetailsData.contactId == null ||
          submittalDetailsData.contactId == "-1" && selectContact == null
          ?*/
          codeWithNumber,
      // :null,
      email: /* submittalDetailsData.contactId == null ||
          submittalDetailsData.contactId == "-1" && selectContact == null
          ?*/
          emailController.text,
      // :null,
      lastName: /* submittalDetailsData.contactId == null ||
          submittalDetailsData.contactId == "-1" && selectContact == null
          ?*/
          lastNameController.text,
      // : null,
    );
    await addSubmittalsApi.uploadSubmittals(submittalsRequest).then((value) {
      var status = value.status;
      debugPrint("update Submittals status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("New Submittals Successfully Added"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        Navigator.popAndPushNamed(context, "/submittals");
      } else {
        final snackBar = SnackBar(
          content: Text("Add Submittals Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future getSubmittalsDetails() async {
    setState(() {
      isLoading = true;
    });
    await addSubmittalsApi
        .getSubmittalsDetails(
            "${ActiveProjectGlobalValue.submittalsData.submittalId}")
        .then((value) {
      var status = value.status;
      debugPrint("Submittals Details Status === $status");
      setState(() {
        submittalDetailsData = value.data;
        if (submittalDetailsData.customerId != "-1") {
          customerId = submittalDetailsData.customerId;
        } else {
          customerId = GlobalValues.loginEmployee.customerId.toString();
        }
        addressController.text = submittalDetailsData.address;
        cityController.text = submittalDetailsData.city;
        zipcodeController.text = submittalDetailsData.zip;
        markShipmentController.text = submittalDetailsData.markShipment;
        wantedDateController.text = submittalDetailsData.wantedDate;
        countryKeyId = submittalDetailsData.countryId;
        // var   apiSelectedList = tabListData.forEach((element) {element.key = submittalDetailsData.submittalStatusId.toString(); });
        // selectedList = DrawerData(key: submittalDetailsData.submittalStatusId.toString());
      });
      tabData();
      getStateData(submittalDetailsData.countryId);
      getCountryData();
      getContactData(customerId);
    });
    setState(() {
      isLoading = false;
    });
  }

  AddBidderApi addBidderApi = AddBidderApi();

  getCountryData() async {
    setState(() {
      isLoading = true;
    });
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1342785/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}")
        .then((value) {
      setState(() {
        countryData = value.data;
      });
    });
    selectCountry = countryData.singleWhere(
        (element) => element.key == submittalDetailsData.countryId,
        orElse: () => null);
    // selectState = stateData.singleWhere((element) => element.key == submittalDetailsData.stateId,orElse: ()=> null);
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
        contactData = value.data;
      });
      debugPrint("select state === ${StringConst.API}m1344812/$customerId");
    });
    selectContact = contactData.singleWhere(
        (element) => element.key == submittalDetailsData.contactId,
        orElse: () => null);
    // debugPrint(
    //     "${StringConst.API}m1344812/${GlobalValues.loginEmployee.contactId}");
    setState(() {
      isLoading = false;
    });
  }

  getStateData(String countryId) async {
    setState(() {
      isLoading = true;
    });
    await addBidderApi
        .getAddBidderDropDownApi("${StringConst.API}m1342786/$countryId")
        .then((value) {
      setState(() {
        stateData = value.data;
      });
    });
    selectState = stateData.singleWhere(
        (element) => element.key == submittalDetailsData.stateId,
        orElse: () => null);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickDocument() async {
    setState(() {
      isLoading = true;
    });
    List<String> list = [];
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        documentUrl = result.files.single.path;
        document = base64Encode(File(documentUrl).readAsBytesSync());
        fileName = result.files.single.name;
        fileSize = result.files.single.size.toString();
        list.add(fileName);
        debugPrint(
            "file Url === ${base64Encode(File(documentUrl).readAsBytesSync())}");
        debugPrint("fileName === $fileName ");
        debugPrint("fileSize ===$fileSize ");
      });
      setState(() {
        isLoading = false;
        documentList.addAll(list);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    // DateFormat formatter = DateFormat('yyyy-MM-dd');
    // String formatted = formatter.format(selectedDate);
    //  String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
    final DateTime picked = await showDatePicker(
      context: context,
      // fieldHintText: "rgegdgg",
      helpText: "MM/dd/yyyy",
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (submittalDetailsData.wantedDate.isNotEmpty) {
      // picked.
    }
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        wantedDateController.text =
            DateFormat('MM/dd/yyyy').format(selectedDate);
        // pickBidDate = DateFormat.yMd().add_jm().format(selectedDate);
        wantedDate = DateFormat('MM/dd/yyyy').add_Hms().format(selectedDate);
        /* estimatedBidDate.text = DateFormat('MM-dd-yyyy').format(
          selectedDate.toLocal().add(Duration(
                hours: 12,
            minutes: 00,
          )),
        );*/ //  selectedDate.toLocal().toString().split(" ")[0];
      });
    // submittals(;'sss colen bool is pond ');
    debugPrint("selectedDate===${wantedDateController.text}");
    debugPrint("pickBidDate===$wantedDate");
    // debugPrint("anotherDate===$bidDate");
    debugPrint("selectedDate===${selectedDate.toLocal().add(Duration(
          minutes: 00,
          hours: 12,
        ))}");
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
          title: Text("Add Submittals"),
          backgroundColor: ColorConst.appBarBackGroundColor,
          leading: Container(),
          titleSpacing: -30,
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
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text(
                        "Submittals",
                        style: TextstyleConst.addSubmittalsBoldText,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Divider(
                          color: Colors.grey[600],
                          endIndent: 5,
                          height: 2,
                        ),
                      ),
                      BuildDropDownButton(
                        hintText: "Select Submittal Status * ",
                        errorText: "",
                        fieldId: 1,
                        dropdownValueChanged: dropdownValueChanged,
                        isAddContact: isAddContact,
                        listOfData: tabListData,
                        selectList: selectSubmittal,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 12),
                        child: Column(
                          children: [
                            InkWell(
                              child: DragAndDropForFileUpload(),
                              onTap: () {
                                pickDocument();
                              },
                            ),
                            fileName != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      fileName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Text(
                        "Wanted Date",
                        style: TextstyleConst.addSubmittalsBoldText,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Divider(
                          color: Colors.grey[600],
                          endIndent: 5,
                          height: 2,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (submittalDetailsData.wantedDate.isEmpty) {
                            _selectDate(context);
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: wantedDateController,
                            keyboardType: TextInputType.datetime,
                            cursorColor: Colors.black12,
                            //     initialValue: '${selectedDate.month}',
                            decoration:
                                InputDecorationConst().buildInputDecoration(
                              'MM/DD/YYYY',
                              Icon(
                                Icons.calendar_today,
                              ),
                              submittalDetailsData.wantedDate.isNotEmpty
                                  ? true
                                  : false,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Shipping Information",
                          style: TextstyleConst.addSubmittalsBoldText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Divider(
                          color: Colors.grey[600],
                          endIndent: 5,
                          height: 2,
                        ),
                      ),
                      TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.black12,
                        decoration: InputDecorationConst().buildInputDecoration(
                          'Address',
                          SizedBox(),
                          false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                            controller: cityController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black12,
                            decoration:
                                InputDecorationConst().buildInputDecoration(
                              'City',
                              SizedBox(),
                              false,
                            )),
                      ),
                      BuildDropDownButton(
                          hintText: "Select Country",
                          errorText: "",
                          listOfData: countryData,
                          selectList: selectCountry,
                          isAddContact: isAddContact,
                          dropdownValueChanged: dropdownValueChanged,
                          fieldId: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: BuildDropDownButton(
                            hintText: "Select State",
                            errorText: "",
                            listOfData: stateData,
                            selectList: selectState,
                            isAddContact: isAddContact,
                            dropdownValueChanged: dropdownValueChanged,
                            fieldId: 3),
                      ),
                      TextFormField(
                        controller: zipcodeController,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.black12,
                        decoration: InputDecorationConst().buildInputDecoration(
                          'Zipcode',
                          SizedBox(),
                          false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: markShipmentController,
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.black12,
                          decoration:
                              InputDecorationConst().buildInputDecoration(
                            'Mark Shipment',
                            SizedBox(),
                            false,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "48 Hour Notice",
                          style: TextstyleConst.addSubmittalsBoldText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Divider(
                          color: Colors.grey[600],
                          endIndent: 5,
                          height: 2,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AbsorbPointer(
                              absorbing: isAddContact,
                              child: BuildDropDownButton(
                                hintText: "select Contact",
                                errorText: "Contact is required",
                                fieldId: 4,
                                isAddContact: isAddContact,
                                listOfData: contactData,
                                selectList: selectContact,
                                dropdownValueChanged: dropdownValueChanged,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                /*  isAddContact = !isAddContact;
                                contactData.clear();
                                // isAddContact == true ? dropdownValueChanged (fieldId == 4): _dropboxColor = Colors.black26;
                                if (isAddContact == true) {
                                  _dropboxColor = Colors.black26;
                                  contactData.clear();
                                  selectContact = null;
                                } else if (isAddContact == false) {
                                  _dropboxColor = Colors.white;
                                  isAddContact == false
                                      ? getContactData(customerId)
                                      : null;
                                } else {}*/
                                // selectContact = null;

                                isAddContact = !isAddContact;
                                selectContact = null;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 5),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: isAddContact != true
                                        ? Colors.white
                                        : Color(0xff4381b7),
                                    border: Border.all(
                                      color: Color(0xff4381b7),
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  Icons.add,
                                  size: 22,
                                  color: isAddContact != true
                                      ? Color(0xff4381b7)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isAddContact == true
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 8),
                              child: Container(
                                height: 45,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: firstNameController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecorationConst()
                                      .buildInputDecoration(
                                    'First Name',
                                    SizedBox(),
                                    false,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      isAddContact == true
                          ? Container(
                              height: 45,
                              child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: lastNameController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecorationConst()
                                      .buildInputDecoration(
                                    'Last Name',
                                    SizedBox(),
                                    false,
                                  )),
                            )
                          : Container(),
                      isAddContact == true
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                height: 45,
                                child: TextFormField(
                                  controller: emailController,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecorationConst()
                                      .buildInputDecoration(
                                    'Email',
                                    SizedBox(),
                                    false,
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
                                    color: ColorConst.InputEnableBorderColor),
                                borderRadius: BorderRadius.circular(8),
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
                                                  .replaceAll("[(\)\\s-]+", "")
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
                                      controller: phoneNumberController,
                                      inputFormatters: [
                                        (_phoneNumberFormatter.whichNumber == 1)
                                            ? LengthLimitingTextInputFormatter(
                                                14)
                                            : LengthLimitingTextInputFormatter(
                                                11),
                                        FilteringTextInputFormatter.digitsOnly,
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
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                child: TransparentButton(
                                    colorCode: 0xff0098D4,
                                    buttonName: "Submit"),
                                onTap: () {
                                  if (buttonPress() == true) {
                                    uploadSubmittals();
                                    debugPrint("buttonPress Action === true");
                                    debugPrint(
                                        "first name ===  ${firstNameController.text}");
                                    debugPrint(
                                        "last name ===  ${lastNameController.text}");
                                    debugPrint(
                                        "email name ===  ${emailController.text}");
                                    debugPrint(
                                        "number name ===  ${phoneNumberController.text}");
                                  } else {
                                    debugPrint("buttonPress Action === false");
                                  }
                                }),
                            InkWell(
                              child: TransparentButton(
                                buttonName: "Close",
                                colorCode: 0xffEE3737,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                debugPrint("");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Visible(isLoading: isLoading, message: ""),
      ),
    );
  }

  bool buttonPress() {
    final form = _formKey.currentState;
    // debugPrint("Button Press Activity ${buttonPress()}");
    // debugPrint("Button Press Activity ${form?.validate()}");
    if (form.validate()) {
      form?.save();
    }
    if (selectContact != null && submittalDetailsData.contactId != "-1" ||
        // submittalDetailsData.contactId != null ||
        firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        phoneNumberController.text.isNotEmpty) {
      return true;
    } else {
      final snacbar = SnackBar(
        content:
            Text('Please Select either contact or Add new contact details'),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      scaffoldMessengerKey.currentState.showSnackBar(snacbar);
      // ScaffoldMessenger.of(context).showSnackBar(snacbar);
      return false;
    }
  }

  dropdownValueChanged(DrawerData value, int fieldId) {
    if (fieldId == 1)
      // selectedList.key = submittalDetailsData.submittalStatusId;
      setState(() {
        selectSubmittal = value;
        debugPrint(
            "TAB Value === ${selectSubmittal.value}  && ${selectSubmittal.key}");
      });
    if (fieldId == 2) {
      setState(() {
        selectCountry = value;
        countryKeyId = selectCountry.key;
        debugPrint(
            "selected selectCountry == ${selectCountry.value}  && ${selectCountry.key}");
        stateData.clear();
        selectState = null;
        getStateData(selectCountry.key);
      });
    }
    if (fieldId == 3) {
      setState(() {
        selectState = value;
        debugPrint(
            "selected selectState == ${selectState.value}  && ${selectState.key}");
      });
    }
    if (fieldId == 4) {
      setState(() {
        selectContact = value;

        // debugPrint(
        //     "selected selectState == ${selectContact.value}  && ${selectContact.key}");
      });
    }
  }
}
