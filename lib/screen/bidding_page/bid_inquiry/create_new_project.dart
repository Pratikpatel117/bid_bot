// ignore_for_file: unnecessary_statements

import 'package:bidbot/api/bid_inquiry/create_new_project_api.dart';
import 'package:bidbot/api/bid_inquiry/review_request_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bid_Inquiry/project_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

enum RidesPhase { CreateNew, chooseExisting }

class CreateNewProject extends StatefulWidget {
  const CreateNewProject({
    Key key,
    this.projectId,
  }) : super(key: key);
  final bool projectId;

  @override
  _CreateNewProjectState createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {
  final projectName = TextEditingController();
  final estimatedBidDate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  CreateNewProjectRequest createNewProjectRequest;
  bool autoValidate = false;
  String description = '';
  // final descriptionController = TextEditingController();
  List<DrawerData> leadData;
  DrawerData selectLead;
  List<DrawerData> phaseData;
  DrawerData selectPhase;
  List<DrawerData> typeData;
  DrawerData selectType;
  List<DrawerData> groupData;
  DrawerData selectGroup;
  List<DrawerData> estimatedBy;
  DrawerData selectEstimated;
  List<DrawerData> filterData;
  DrawerData selectedFilterData;
  bool isLoading = false;
  String pickBidDate;
  bool ridesSelected = true;
  bool newValue = false;
  String projectPrivate = "0";
  FilterRequest filterRequest;
  String bidDate;

  void confidenCheck(bool value) {
    setState(() {
      newValue = value;
      if (newValue == true) {
        projectPrivate = "1";
      } else {
        projectPrivate = "0";
      }
    });
  }

  RidesPhase ridesPhase = RidesPhase.CreateNew;

//A TextEditingController was used after being disposed.
  @override
  void initState() {
    super.initState();
    getLeadId();
    getPhaseId();
    getTypeId();
    getGroupId();
    getEstimatedId();
    /*  if(widget.projectId == true){
      projectName.text == GlobalValues.reviewRequestData.projectName;
    }*/
    widget.projectId == true
        ? projectName.text = GlobalValues.reviewRequestData.projectName
        : projectName.text = projectName.text;
    widget.projectId == true && ridesPhase != RidesPhase.chooseExisting
        ? estimatedBidDate.text =
            GlobalValues.reviewRequestData.estimatedBidDate
        : null; //estimatedBidDate.text = "MM/DD/YYYY"
    widget.projectId == true && ridesPhase == RidesPhase.chooseExisting
        ? debugPrint("Bid Date === $bidDate")
        : null;
  }

  Future newProjectSave() async {
    setState(() {
      isLoading = true;
    });
    CreateNewProjectApi createNewProjectApi = CreateNewProjectApi();
    createNewProjectRequest = CreateNewProjectRequest(
      projectName: projectName.text,
      employeeId: GlobalValues.loginEmployee.employeeId.toString(),
      bidDate: pickBidDate,
      projectDescription: description,
      leadId: selectLead.key.toString(),
      estimatorId: selectEstimated.key.toString(),
      industryId: selectGroup.key.toString(),
      phaseId: selectPhase.key.toString(),
      typeId: selectType.key.toString(),
      bidInquiryId: null,
      isPrivateProject: projectPrivate,
    );
    await createNewProjectApi
        .createNewProject(createNewProjectRequest)
        .then((value) {
      var statusResponce = value.status;
      if (statusResponce == true) {
        final snackBar = SnackBar(
          content: Text('New Project Successfully Created'),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
       //  showAlertDialog(context, value.status);
        Navigator.pop(context);
      } else {
        final snackBar = SnackBar(
          content: Text("Created New Project Failed"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
       // showAlertDialog(context, value.status);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff252669),
          leading: Container(),
          titleSpacing: -30,
          title: Text('Create Project'),
          actions: [
            InkWell(
              child: Image.asset("asset/image/crossback.png"),
              onTap: () {
                Navigator.pop(context);
                debugPrint("app bar back context value == ${context.size}");
              },
            ),
            // Stack(children: [],)
          ],
        ),
        body: Stack(
          children: [
            isLoading != true
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 21,
                        right: 21,
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.projectId == true
                                  ? Row(
                                      children: [
                                        Radio(
                                            value: RidesPhase.CreateNew,
                                            groupValue: ridesPhase,
                                            onChanged: (value) {
                                              setState(() {
                                                ridesPhase = value;
                                                ridesSelected = true;
                                              });
                                            }),
                                        Text("Create New")
                                      ],
                                    )
                                  : Container(),
                              widget.projectId == true
                                  ? Row(
                                      children: [
                                        Radio(
                                            value: RidesPhase.chooseExisting,
                                            groupValue: ridesPhase,
                                            onChanged: (value) {
                                              setState(() {
                                                ridesPhase = value;
                                                ridesSelected = false;
                                              });
                                            }),
                                        Text("Choose Existing")
                                      ],
                                    )
                                  : Container(),
                              ridesPhase == RidesPhase.CreateNew
                                  ? Text('Name*')
                                  : Container(),
                              ridesPhase == RidesPhase.CreateNew
                                  ? TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          // projectName.text = value;
                                          // request.username = value;
                                        });
                                      },
                                      onSaved: (submit) {
                                        // request.username = submit;
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Color(0xff4381b7),
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff4381b7),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        border: OutlineInputBorder(
                                            // borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8)),
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
                                        filled: true,
                                        hintText: 'Name',
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 15, 10, 0),
                                        //padding according to your need
                                        hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        fillColor: Colors.white,
                                      ),
                                    )
                                  : Container(),
                              Text('Lead*'),
                              buildDropdownButton(
                                  'Select Lead',
                                  'Lead is Required',
                                  leadData,
                                  selectLead,
                                  dropdownValueChanged,
                                  1),
                              Text('Phase*'),
                              buildDropdownButton(
                                  'Select Phase',
                                  'Phase is Required',
                                  phaseData,
                                  selectPhase,
                                  dropdownValueChanged,
                                  2),
                              Text('Type*'),
                              buildDropdownButton(
                                  'Select Type',
                                  'Type is Required',
                                  typeData,
                                  selectType,
                                  dropdownValueChanged,
                                  3),
                              Text('Group*'),
                              buildDropdownButton(
                                  'Select Industry',
                                  'Industry is Required',
                                  groupData,
                                  selectGroup,
                                  dropdownValueChanged,
                                  4),
                              ridesPhase == RidesPhase.CreateNew
                                  ? Text('Estimated By*')
                                  : Container(),
                              ridesPhase == RidesPhase.CreateNew
                                  ? buildDropdownButton(
                                      'Select Estimated By',
                                      'Estimated By is Required',
                                      estimatedBy,
                                      selectEstimated,
                                      dropdownValueChanged,
                                      5)
                                  : Container(),
                              Text('Bid Date*'),
                              InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: IgnorePointer(
                                  child: TextFormField(
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
                                        return 'Bid Date is Required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: estimatedBidDate,
                                    keyboardType: TextInputType.datetime,
                                    cursorColor: Colors.black12,
                                    //     initialValue: '${selectedDate.month}',
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0.5,
                                        fontSize: 11,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Color(0xff4381b7), width: 1),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 1),
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: ColorConst
                                                .InputFocusedBorderColor,
                                            width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: ColorConst
                                                .InputEnableBorderColor,
                                            width: 1),
                                      ),
                                      filled: true,
                                      hintText: 'MM/DD/YYYY',
                                      // '${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}',
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 15, 10, 0),
                                      //padding according to your need
                                      hintStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ridesPhase == RidesPhase.CreateNew &&
                                      widget.projectId == true
                                  ? Row(
                                      children: [
                                        Checkbox(
                                          value: newValue,
                                          onChanged: confidenCheck,
                                        ),
                                        Text(
                                          'Private Project',
                                          style: TextStyle(
                                              fontFamily:
                                                  StringConst.FONT_FAMILY),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              ridesPhase == RidesPhase.CreateNew
                                  ? Text('Description')
                                  : Container(),
                              ridesPhase == RidesPhase.CreateNew
                                  ? MarkdownTextInput(
                                      (String value) =>
                                          setState(() => description = value),
                                      description,
                                      //  hintText: "Description *",
                                      label: 'Description',
                                      maxLines: 4,
                                      actions: MarkdownType.values,
                                      // controller: descriptionController,
                                      validators: (value) {
                                        if (value.isNotEmpty) {
                                          return null;
                                        } else {
                                          return null;
                                        }
                                      },
                                    )
                                  : Container(),
                              ridesPhase == RidesPhase.chooseExisting
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 9),
                                      child: InkWell(
                                        onTap: () {
                                          if (filterValidate() == true) {
                                            filterApiCall();
                                          }
                                        },
                                        child: Container(
                                          child: Text("Filter"),
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              18,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.greenAccent,
                                                width: 2),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              ridesPhase == RidesPhase.chooseExisting
                                  ? Text('Project')
                                  : Container(),
                              ridesPhase == RidesPhase.chooseExisting
                                  ? buildDropdownButton(
                                      'Select Project',
                                      'Project Name is Required',
                                      filterData,
                                      selectedFilterData,
                                      dropdownValueChanged,
                                      6)
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (buttonPress() == true) {
                                        newProjectSave();
                                        debugPrint(
                                            "app bar back context value == ${_formKey.currentContext.size}");
                                        debugPrint(
                                            "app bar back context value  scaffold key == ${scaffoldKey.currentContext.size}");
                                      }
                                    },
                                    child: BottomActivityButton(
                                      buttonName: "Save",
                                      colorCode: 0xff252669,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: BottomActivityButton(
                                      buttonName: "Close",
                                      colorCode: 0xffEE3737,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Visible(isLoading: isLoading, message: ""),
          ],
        ),
        // : Visible(isLoading: isLoading, message: ""),
      ),
    );
  }

  /*
  @override
  void dispose() {
    projectName.dispose();
    estimatedBidDate.dispose();
    descriptionController.dispose();
    super.dispose();
  }*/
/* filter parameter
 {
  "subscriptionId": 7686051,
  "verticalId": 324,
  "employeeId": "3070",
  "bidDate": "12/16/2021 00:00:00",
  "phaseId": "3246",
  "industryId": "25439",
  "typeId": "1301",
  "leadId": "3230"
}*/
  Future filterApiCall() async {
    setState(() {
      isLoading = true;
    });
    filterRequest = FilterRequest(
      employeeId: "3070",
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      bidDate: bidDate != null ? bidDate : "",
      typeId: selectType != null ? selectType.key.toString() : "-1",
      phaseId: selectPhase != null ? selectPhase.key.toString() : "-1",
      industryId: selectGroup != null ? selectGroup.key.toString() : "-1",
      leadId: selectLead != null ? selectLead.key.toString() : "-1",
    );
    FilterApi filterApi = FilterApi();
    await filterApi.filterApi(filterRequest).then((value) {
      var filterResult = value.status;
      debugPrint("filter Printed Result $filterResult");
      if (filterResult == true) {
        setState(() {
          filterData = value.data;
          debugPrint("filter Printed Result ${value.message}");
          value.data.forEach((element) {
            debugPrint("filter Printed Project Name ${element.value}");
          });
          // debugPrint("filter Printed Result ${filterData.first.value} &&& ${filterData.first.key}");
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  bool filterValidate() {
    if (selectLead != null ||
        selectGroup != null ||
        selectPhase != null ||
        selectType != null ||
        bidDate != null) {
      return true;
    } else {
      final snackBar = SnackBar(
        content: Text('Please Select Atleast one filter'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
      showAlertDialog(context, false);
      return false;
    }
    // selectLead ?? selectGroup ?? selectPhase ?? selectType == null ?
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
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        estimatedBidDate.text = DateFormat('MM-dd-yyyy').format(selectedDate);
        pickBidDate = DateFormat.yMd().add_jm().format(selectedDate);
        bidDate = DateFormat('MM/dd/yyyy').add_Hms().format(selectedDate);
        /* estimatedBidDate.text = DateFormat('MM-dd-yyyy').format(
          selectedDate.toLocal().add(Duration(
                hours: 12,
            minutes: 00,
          )),
        );*/ //  selectedDate.toLocal().toString().split(" ")[0];
      });
    debugPrint("selectedDate===${estimatedBidDate.text}");
    debugPrint("pickBidDate===$pickBidDate");
    debugPrint("anotherDate===$bidDate");
    debugPrint("selectedDate===${selectedDate.toLocal().add(Duration(
          minutes: 00,
          hours: 12,
        ))}");
  }

  CreateNewProjectApi createNewProjectApi = CreateNewProjectApi();

  getLeadId() async {
    await createNewProjectApi.getCreateProjectApi("m1345633").then((value) {
      //  if (value.status = true) {
      if (mounted) {
        setState(() {
          leadData = value.data;
        });
      }
      // debugPrint("Get Lead Data ${leadData.last.value}");
    });
  }

  getPhaseId() async {
    await createNewProjectApi.getCreateProjectApi("m1345632").then((value) {
      //   if (value.status = true) {
      setState(() {
        phaseData = value.data;
      });
      //  }
      // debugPrint("Get Phase Data ${phaseData.last.value}");
    });
  }

  getTypeId() async {
    await createNewProjectApi.getCreateProjectApi("m1345630").then((value) {
      //  if (value.status = true) {
      setState(() {
        typeData = value.data;
      });
      //  }
      // debugPrint("Get typeData Data ${typeData.last.value}");
    });
  }

  getGroupId() async {
    await createNewProjectApi.getCreateProjectApi("m1345631").then((value) {
      //   if (value.status = true) {
      setState(() {
        groupData = value.data;
      });
      //  }
      // debugPrint("Get groupData Data ${groupData.last.value}");
    });
  }

  getEstimatedId() async {
    await createNewProjectApi.getCreateProjectApi("m1345633").then((value) {
      // if (value.status = true) {
      setState(() {
        estimatedBy = value.data;
      });
      //  }
      // debugPrint("Get estimatedBy Data ${estimatedBy.last.value}");
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
          ? Text("New Project Successfully Created")
          : Text("Please Select Atleast one filter"),
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

  dropdownValueChanged(DrawerData value, int fieldId) {
    if (fieldId == 1) {
      setState(() {
        selectLead = value;
        debugPrint(
            "selected selectLead == ${selectLead.value}  && ${selectLead.key}");
      });
    }
    if (fieldId == 2) {
      setState(() {
        selectPhase = value;
        debugPrint(
            "selected selectPhase == ${selectPhase.value}  && ${selectPhase.key}");
      });
    }
    if (fieldId == 3) {
      setState(() {
        selectType = value;
        debugPrint(
            "selected selectType == ${selectType.value}  && ${selectType.key}");
      });
    }
    if (fieldId == 4) {
      setState(() {
        selectGroup = value;
        debugPrint(
            "selected selectGroup == ${selectGroup.value}  && ${selectGroup.key}");
      });
    }
    if (fieldId == 5) {
      setState(() {
        selectEstimated = value;
        debugPrint(
            "selected selectEstimated == ${selectEstimated.value}  && ${selectEstimated.key}");
      });
    }
    if (fieldId == 6) {
      setState(() {
        selectedFilterData = value;
        debugPrint(
            "selected selectedFilterData == ${selectedFilterData.value}  && ${selectedFilterData.key}");
      });
    }
  }

  DropdownButtonFormField<dynamic> buildDropdownButton(
      String hintText,
      String errorText,
      List<DrawerData> listOfData,
      DrawerData selectList,
      Function(DrawerData value, int fieldId) dropdownValueChanged,
      int fieldId) {
    return DropdownButtonFormField(
      hint: Text(hintText),
      isDense: true,
      isExpanded: true,
      elevation: 6,
      validator: // ridesPhase != RidesPhase.chooseExisting ?
          (value) {
        return ridesPhase != RidesPhase.chooseExisting &&
                estimatedBidDate.text.isNotEmpty
            ? value == null
                ? errorText
                : null
            : null;
      },
      //: null,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          height: 0.5,
          fontSize: 11,
        ),
        border: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),

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
        //  hintText: 'Project Name *',
        contentPadding: EdgeInsets.fromLTRB(8, 0, 10, 0),
        //padding according to your need
        hintStyle: TextStyle(color: Colors.grey, fontSize: 9),
        fillColor: Colors.white,
      ),
      // iconEnabledColor: Colors.transparent,
      // iconDisabledColor: Colors.transparent,
      icon: Icon(
        Icons.arrow_drop_down,
      ),
      // onTap: () {
      //   debugPrint("Get Lead data On tap==$phaseData");
      // },
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

  bool buttonPress() {
    final form = _formKey.currentState;
    // debugPrint("Button Press Activity ${buttonPress()}");
    // debugPrint("Button Press Activity ${form?.validate()}");
    if (form.validate()) {
      form?.save();
      return true;
    }
    return false;
  }

  String validate(String value) {
    return null;
  }
}
