import 'dart:convert';
import 'dart:io';

import 'package:bidbot/api/bid_inquiry/bid_inquiry_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bid_inquiry_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class BidInquiry extends StatefulWidget {
  const BidInquiry({Key key}) : super(key: key);

  @override
  _BidInquiryState createState() => _BidInquiryState();
}

class _BidInquiryState extends State<BidInquiry> {
  final projectName = TextEditingController();
  final estimatedBidDate = TextEditingController();
  final description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool newValue = false;
  String confidentialProject = '0';
  bool equipment = false;
  String equipmentReplacement = "0";
  bool part = false;
  String partPrice = "0";
  bool plan = false;
  String planSpeck = " 0";
  bool isLoading = false;
  BidInquiryRequest bidInquiryRequest;
  BidInquiryDocument bidInquiryDocument;
  String isSpec = "0";
  String documentUrl;
  String fileName;
  String fileSize;
  String estimatedDate;
  String descriptionText = '';

  void confidenCheck(bool value) {
    setState(() {
      newValue = value;
      if (newValue == true) {
        confidentialProject = "1";
      } else {
        confidentialProject = "0";
      }
      // debugPrint("is CheckBox Value == $newValue");
      debugPrint("confidentialProject Value == $confidentialProject");
    });
  }

  void equipmentCheck(bool value) {
    setState(() {
      equipment = value;
      if (equipment == true) {
        equipmentReplacement = "1";
      } else {
        equipmentReplacement = "0";
      }
      debugPrint("isEquipmentReplacement Value == $equipmentReplacement");
    });
  }

  void partPriceRequest(bool value) {
    setState(() {
      part = value;
      if (part == true) {
        partPrice = "1";
      } else {
        partPrice = "0";
      }
      debugPrint("isPartsPriceRequest Value == $partPrice");
    });
  }

  void planAndSpeck(bool value) {
    setState(() {
      plan = value;
      if (plan == true) {
        planSpeck = "1";
      } else {
        planSpeck = "0";
      }
      debugPrint("isPlan Value == $planSpeck");
    });
  }

  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    /*  Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );*/

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: (status == true)
          ? Text("Bid Request Successfully")
          : Text("Bid Request Failed"),
      content: (status == true)
          ? Image.asset('asset/image/loginstoast.png')
          : Image.asset('asset/image/loginfailtoast.png'),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    Navigator.pop(context);
  }

  Future requestSubmit() async {
    setState(() {
      isLoading = true;
    });
    bidInquiryRequest = BidInquiryRequest(
      employeeId: GlobalValues.loginEmployee.employeeId.toString(),
      verticalId: GlobalValues.verticalId.toString(),
      subscriptionId: GlobalValues.subscriptionId.toString(),
      customerContactId: GlobalValues.loginEmployee.contactId,
      projectName: projectName.text,
      isSpec: isSpec,
      estimatedBidDate: estimatedBidDate.text,
      isConfidentialPrivateProject: confidentialProject,
      isEquipmentReplacement: equipmentReplacement,
      isPartsPriceRequest: partPrice,
      isPlan: planSpeck,
      description: descriptionText,
      document: documentUrl != null
          ? [
              BidInquiryDocument(
                document: base64Encode(File(documentUrl).readAsBytesSync()),
                fileName: fileName,
                fileSize: fileSize,
              )
            ]
          : [],
    );

    BidInquiryApi bidInquiryApi = BidInquiryApi();
    await bidInquiryApi.bidInquiryData(bidInquiryRequest).then((value) {
      var statusResponce = value.status;
      if (statusResponce == true) {
        final snacbar = SnackBar(
          content: Text('New Bid Inquiry Successfully Added'),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
        showAlertDialog(context, value.status);
        Navigator.pop(context);
      } else {
        final snacbar = SnackBar(
          content: Text('Bid Inquiry can not Added'),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadInquiryDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        documentUrl = result.files.single.path;
        fileName = result.files.single.name;
        fileSize = result.files.single.size.toString();
        debugPrint(
            "file Url === ${base64Encode(File(documentUrl).readAsBytesSync())}");
        debugPrint("fileName === $fileName ");
        debugPrint("fileSize ===$fileSize ");
      });
    } else {}
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    // DateFormat formatter = DateFormat('yyyy-MM-dd');
    // String formatted = formatter.format(selectedDate);
    //  String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        // estimatedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
        estimatedBidDate.text = DateFormat('MM/dd/yyyy').format(
            selectedDate); //  selectedDate.toLocal().toString().split(" ")[0];
      });
    debugPrint("selectedDate===${estimatedBidDate.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        title: Text('Bid Inquiry'),
        actions: [
          InkWell(
            child: Image.asset("asset/image/crossback.png"),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 21,
            right: 21,
          ),
          child: ListView(children: [
            Form(
              key: _formKey, //autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                    textAlign: TextAlign.left,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        // projectName.text = value;
                        // request.username = value;
                      });
                    },
                    onSaved: (submit) {
                      // request.username = submit;
                      debugPrint("project name is=== $submit");
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name is Required';
                      } else {
                        return null;
                      }
                    },
                    controller: projectName,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black12,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        height: 0.5,
                        fontSize: 11,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Color(0xff4381b7), width: 1),
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
                      border: OutlineInputBorder(
                          // borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: ColorConst.InputFocusedBorderColor,
                            width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: ColorConst.InputEnableBorderColor, width: 1),
                      ),
                      filled: true,
                      hintText: 'Project Name',
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      //padding according to your need
                      hintStyle: TextstyleConst.createNewProjectField,
                      fillColor: Colors.white,
                    ),
                  ),
                  Text(
                    'Estimated Bid Date',
                    style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                  ),
                  /*TextFormField(
                    onTap: () {
                      _selectDate(context);
                    },
                  ),*/
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        // onTap: () {
                        //   _selectDate(context);
                        // },
                        // initialValue: estimatedBidDate.text.isNotEmpty ? "${selectedDate.toLocal()}".split(' ')[0] : "MM-DD-YYYY",
                        onChanged: (value) {
                          setState(() {
                            // request.username = value;
                          });
                        },
                        onSaved: (submit) {
                          // request.username = submit;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Estimated Bid Date is Required';
                          } else {
                            return null;
                          }
                        },
                        controller: estimatedBidDate,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black12,
                        //     initialValue: '${selectedDate.month}',
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            height: 0.5,
                            fontSize: 11,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Color(0xff4381b7), width: 1),
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
                          border: OutlineInputBorder(
                              // borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8)),
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
                          filled: true,
                          hintText: 'MM-DD-YYYY',
                          // '${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}',
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                          //padding according to your need
                          hintStyle: TextstyleConst.createNewProjectField,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: newValue,
                        onChanged: confidenCheck,
                      ),
                      Text(
                        'Confidential Project',
                        style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: part,
                        onChanged: partPriceRequest,
                      ),
                      Text(
                        'Part Price Request',
                        style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: equipment,
                        onChanged: equipmentCheck,
                      ),
                      Text(
                        'Equipment Replacement',
                        style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: plan,
                        onChanged: planAndSpeck,
                      ),
                      Text(
                        'Plan & Spec',
                        style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upload Files",
                        style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                      ),
                      InkWell(
                        onTap: () {
                          uploadInquiryDocument();
                        },
                        child: documentUrl != null
                            ? Container(
                                child: Text(
                                  fileName,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.justify,
                                  maxLines: 5,
                                ),
                                height: 40,
                                width: 200,
                                alignment: Alignment.centerRight,
                              )
                            : Container(
                                height: 35,
                                width: 90,
                                decoration:
                                    BoxDecoration(color: Color(0xff252669)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Choose',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: StringConst.FONT_FAMILY),
                                    ),
                                    Image.asset('asset/image/uploadarrow.png')
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 7),
                    child: Text(
                      'Description',
                      style: TextStyle(fontFamily: StringConst.FONT_FAMILY),
                    ),
                  ),
                  MarkdownTextInput(
                    (String value) => setState(() => descriptionText = value),
                    descriptionText,
                    //  hintText: "Description *",
                    label: 'Description',
                    maxLines: 4,
                    validators: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else {
                        return null;
                      }
                    },
                    actions: MarkdownType.values,
                    controller: description,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xff252669),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: StringConst.FONT_FAMILY),
                            ),
                            height: 55,
                            width: MediaQuery.of(context).size.width / 1.7,
                          ),
                          onTap: () {
                            if (buttonPress() == true) {
                              requestSubmit();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Visible(isLoading: isLoading, message: " "),
      ]),
    );
  }

  bool buttonPress() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form?.save();
      return true;
    }
    return false;
  }
}
