import 'package:bidbot/api/bidding/bidders/add_bidder_api.dart';
import 'package:bidbot/api/bidding/player/add_player_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/player/add_player_model.dart';
import 'package:flutter/material.dart';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({Key key}) : super(key: key);

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  List<DrawerData> customerData;
  DrawerData selectCustomer;
  List<DrawerData> discipline;
  DrawerData selectDiscipline;
  List<DrawerData> countryData;
  DrawerData selectCountry;
  List<DrawerData> stateData;
  DrawerData selectState;
  List<DrawerData> businessType;
  DrawerData selectBusinessType;
  bool filterStatus = false;
  bool isLoading = false;
  AddPlayerRequest playerRequest;
  String projectId = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerData();
    getCountryData();
    getBusinessType();
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.playerData.projectId;
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidlistPlayer.projectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidPlayer.projectId;
    }
  }

  AddBidderApi addBidderApi = AddBidderApi();

  Future saveNewPlayer() async {
    /*   setState(() {
      isLoading = true;
    });*/
    AddPlayerApi playerApi = AddPlayerApi();
    playerRequest = AddPlayerRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: projectId,
      customerId: "${selectCustomer.key}",
      businessTypeId: "${selectBusinessType.key}",
      businessTypeDisciplineId: "${selectDiscipline.key}",
      contactId: null,
      isBidder: null,
      cv: null,
      id: null,
      playerStatusId: null,
    );
    await playerApi.addPlayerApi(playerRequest).then((value) {
      var status = value.status;
      debugPrint("new Player Add Status = $status");
      if (status == true) {
        final snackBar = SnackBar(
            content: Text("New Player Successfully Added"),
            backgroundColor: ColorConst.successSnackBarColor);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.popAndPushNamed(context, "/player");
      } else {
        final snackBar = SnackBar(
          content: Text("New Player Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    /*  setState(() {
      isLoading = false;
    });*/
  }

  getCustomerData() async {
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1343024/${GlobalValues.loginEmployee.employeeId}")
        .then((value) {
      var status = value.status;
      debugPrint("customer Status =$status");
      value.data?.forEach((element) {
        debugPrint("customer Drop Down=${element.value} &&& ${element.key}");
      });
      setState(() {
        customerData = value.data;
      });
    });
  }

  getDisciplineData() async {
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1342788/${selectBusinessType.key}")
        .then((value) {
      setState(() {
        discipline = value.data;
      });
    });
  }

  getCountryData() async {
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1342785/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}")
        .then((value) {
      setState(() {
        countryData = value.data;
      });
    });
  }

  getStateData() async {
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1342786/${selectCountry.key}")
        .then((value) {
      setState(() {
        stateData = value.data;
      });
    });
  }

  getBusinessType() async {
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1342787/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}")
        .then((value) {
      setState(() {
        businessType = value.data;
      });
    });
  }

  getFilterData() async {
    await addBidderApi
        .getAddBidderDropDownApi(
            "${StringConst.API}m1343021/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}/${selectBusinessType.key}/${selectCountry.key}/${selectState.key}")
        .then((value) {
      var filter = value.status;
      debugPrint("filter Api Responce $filter");
      setState(() {
        customerData = value.data;
      });
      // filterStatus == true ?  getCustomerData() : null;
    });
  }

  bool filterValidate() {
    if (selectCountry != null &&
        selectState != null &&
        selectBusinessType != null) {
      return true;
    } else {
      final form2 = _formKey2.currentState;
      // debugPrint("Button Press Activity ${buttonPress()}");
      // debugPrint("Button Press Activity ${form?.validate()}");
      if (form2.validate()) {
        form2?.save();
        return true;
      }
      return false;
      /*final snacbar = SnackBar(
        content: Text('Please Select All filter'),
        backgroundColor: Colors.redAccent,
      );
      ScaffoldMessenger.of(context).showSnackBar(snacbar);
      return false;*/
    }
    // selectLead ?? selectGroup ?? selectPhase ?? selectType == null ?
  }

  bool buttonPress() {
    final form1 = _formKey1.currentState;
    final form2 = _formKey2.currentState;
    // debugPrint("Button Press Activity ${buttonPress()}");
    // debugPrint("Button Press Activity ${form?.validate()}");
    if (form1.validate() || form2.validate()) {
      form1?.save();
      form2?.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff252669),
          leading: Container(),
          titleSpacing: -30,
          title: Text('Add Players'),
          actions: [
            PopBackAction(),
          ],
        ),
        body: isLoading != true
            ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(children: [
                  Form(
                      key: _formKey1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer"),
                          buildDropdownButton(
                              "select Customer",
                              "customer is required",
                              customerData,
                              selectCustomer,
                              dropdownValueChanged,
                              1),
                          Text("Discipline"),
                          buildDropdownButton(
                              "Select Discipline",
                              "Discipline is required",
                              discipline,
                              selectDiscipline,
                              dropdownValueChanged,
                              2),
                        ],
                      )),
                  Form(
                      key: _formKey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Image.asset(
                                    "asset/image/bidding/filter.png",
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.contain,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      filterStatus = !filterStatus;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          filterStatus == true
                              ? Wrap(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        "Country*",
                                        style: TextStyle(),
                                      ),
                                    ),
                                    buildDropdownButton(
                                        "Select Country",
                                        "Country is required",
                                        countryData,
                                        selectCountry,
                                        dropdownValueChanged,
                                        3),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        "State*",
                                        style: TextStyle(),
                                      ),
                                    ),
                                    buildDropdownButton(
                                        "Select State",
                                        "State is required",
                                        stateData,
                                        selectState,
                                        dropdownValueChanged,
                                        4),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        "Business Type*",
                                      ),
                                    ),
                                    buildDropdownButton(
                                        "Select Business Type",
                                        "Business Type is required",
                                        businessType,
                                        selectBusinessType,
                                        dropdownValueChanged,
                                        5),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            child: TransparentButton(
                                              buttonName: "Filter",
                                              colorCode: 0xff00B407,
                                            ),
                                            onTap: () {
                                              if (filterValidate() == true) {
                                                customerData?.clear();
                                                discipline?.clear();
                                                getFilterData();
                                                debugPrint(
                                                    "customer & Filter validation Validation Pass");
                                                filterStatus = false;
                                                // addNotesSave();
                                              }
                                            },
                                          ),
                                          InkWell(
                                            child: TransparentButton(
                                              buttonName: "Cancel",
                                              colorCode: 0xffEE3737,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                // countryData?.clear();
                                                // stateData?.clear();
                                                // businessType?.clear();
                                                filterStatus = false;
                                              });
                                              // Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: TransparentButton(
                                      colorCode: 0xff0098D4, buttonName: "Add"),
                                  onTap: () {
                                    if (buttonPress() == true) {
                                      debugPrint(
                                          "customer & Contact Validation Pass");
                                      saveNewPlayer();
                                      // addNotesSave();
                                    }
                                  },
                                ),
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
                      )),
                ]),
              )
            : Visible(isLoading: isLoading, message: "Loading Players"));
  }

  dropdownValueChanged(DrawerData newData, int field) {
    if (field == 1) {
      setState(() {
        selectCustomer = newData;
        debugPrint(
            "selected selectCustomer == ${newData.value}  && ${newData.key}");
        getDisciplineData();
      });
    }
    if (field == 2) {
      setState(() {
        selectDiscipline = newData;
        debugPrint(
            "selected selectContact == ${newData.value}  && ${newData.key}");
      });
    }
    if (field == 3) {
      setState(() {
        selectCountry = newData;
        debugPrint(
            "selected selectCountry == ${newData.value}  && ${newData.key}");
        getStateData();
      });
    }
    if (field == 4) {
      setState(() {
        selectState = newData;
        debugPrint(
            "selected selectState == ${newData.value}  && ${newData.key}");
      });
    }
    if (field == 5) {
      setState(() {
        selectBusinessType = newData;
        debugPrint(
            "selected selectBusinessType == ${newData.value}  && ${newData.key}");
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
        return value == null ? errorText : null;
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
}
