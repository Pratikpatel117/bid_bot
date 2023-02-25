// ignore_for_file: unnecessary_statements

import 'package:bidbot/api/bidding/Notes/addNotes_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/notes/add_notes_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:html/parser.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key key, this.editNote}) : super(key: key);
  final bool editNote;

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  AddNotesRequest notesRequest;
  AddNotesTabRequest tabRequest;
  List<DrawerData> tabListData;
  DrawerData selectedTab;
  bool isPrivateStatus = false;
  String isPrivateValue = "0";
  bool isSemiPrivateStatus = false;
  String isSemiPrivateValue = "0";
  String description = '';
  NotesData editAndSaveNotes;
  bool isLoading = false;
  NotesTab selectedNotesTab;
  int selectedTabIndex = 0;
  String projectId = " ";

  void privateNote(bool value) {
    setState(() {
      isPrivateStatus = value;
      if (isPrivateStatus == true) {
        isPrivateValue = "1";
      } else {
        isPrivateValue = "0";
      }
      debugPrint("ISPrivate Value == $isPrivateValue");
      // debugPrint("DAteTime Value == $now");
    });
  }

  void subPrivateNotes(bool value) {
    setState(() {
      isSemiPrivateStatus = value;
      if (isSemiPrivateStatus == true) {
        isSemiPrivateValue = "1";
      } else {
        isSemiPrivateValue = "0";
      }
      debugPrint("isSemiPrivateValue Value == $isSemiPrivateValue");
    });
  }

  htmlToStringConvert() {
    final string = parse(BiddingGlobalValue.editNoteData.notes);
    debugPrint("html to String Converter == $string");
    final description = parse(string.body.text).documentElement.text;
    debugPrint("html to String Converter == $description");
  }

/*
PUBLIC NOTES  && 1507931
C Notes  && 269713
Bid Notes  && 81121
.Co Notes  && 686165
CDC Info Notes  && 430378
Manufacturer Notes  && 634427
Man Notes  && 1088159
 */

  /* List<NotesTab> notesTab = <NotesTab>[
    // NotesTab(value: "Select Tab",key: "0"),
    NotesTab(value: "PUBLIC NOTES", key: "1507931"),
    NotesTab(
      value: "C Notes",
      key: "269713",
    ),
    NotesTab(
      value: "Bid Notes",
      key: "81121",
    ),
    NotesTab(
      value: ".Co Notes",
      key: "686165",
    ),
    NotesTab(
      value: "CDC Info Notes",
      key: "430378",
    ),
    NotesTab(
      value: "Manufacturer Notes",
      key: "634427",
    ),
    NotesTab(
      value: "Man Notes",
      key: "1088159",
    ),
  ];*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabData();
    // widget.editNote == true ?  BiddingGlobalValue.editNoteData.tabId = selectedNotesTab.key : null ;
    /*  widget.editNote == true ? notesTab.forEach((element) {
      element.key = BiddingGlobalValue.editNoteData.tabId;
    }) : notesTab;*/
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.biddingNoteProjectId;
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidListNoteProjectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidNoteProjectId;
    }
    debugPrint("add notes description text ===$description");

    /*widget.editNote == true
        ? selectedNotesTab = notesTab[selectedTabIndex]
        : null;*/

    descriptionController.addListener(() {
      // debugPrint("description controller == ${descriptionController.text}");
    });
    // htmlToStringConvert();
    widget.editNote == true
        ? description =
            parse(parse(BiddingGlobalValue.editNoteData.notes).body.text)
                .documentElement
                .text
        : description = '';
    //  debugPrint("description notes === ${descriptionController.text}");
    widget.editNote == true
        ? BiddingGlobalValue.editNoteData.isPrivate == "1"
            ? isPrivateStatus = true
            : isPrivateStatus = false
        : null;
    widget.editNote == true
        ? BiddingGlobalValue.editNoteData.isSemiPrivate == "1"
            ? isSemiPrivateStatus = true
            : isSemiPrivateStatus = false
        : null;
  }

  Future tabData() async {
    setState(() {
      isLoading = true;
    });
    tabRequest = AddNotesTabRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      verticalId: "${GlobalValues.verticalId}",
      tabCode: 'project-notes',
    );
    AddNotesApi addNotesTabApi = AddNotesApi();
    await addNotesTabApi.notesTabData(tabRequest).then((value) {
      var tabDataStatus = value.status;
      debugPrint("tabData Status == $tabDataStatus");
      setState(() {
        tabListData = value.data;
      });
    });
    widget.editNote == true && tabListData != null
        ? selectedTab = tabListData.singleWhere(
            (element) => element.key == BiddingGlobalValue.editNoteData.tabId,
            orElse: () => null)
        : null;
    setState(() {
      isLoading = false;
    });
  }

  Future addNotesSave() async {
    setState(() {
      isLoading = true;
    });
    notesRequest = AddNotesRequest(
      verticalId: "${GlobalValues.verticalId}",
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: projectId,
      subscriptionId: "${GlobalValues.subscriptionId}",
      activeTabId: GlobalValues.selectedBidIndex == 0 && selectedTab != null
          ? selectedTab.key
          : "1507931",
      isPrivate: isPrivateValue,
      isSemiPrivate: isSemiPrivateValue,
      isBidder: "0",
      isPlayer: "0",
      sendOrNotify: "0",
      notes: description,
      noteDateStr: DateFormat("MM/dd/yyyy").format(DateTime.now()),
      noteId: widget.editNote != true
          ? null
          : "${BiddingGlobalValue.editNoteData.noteId}",
      parentNoteId: null,
      thread: descriptionController.text.split(".")[0],
    );
    AddNotesApi notesApi = AddNotesApi();
    await notesApi.addNotesData(notesRequest).then((value) {
      var notesStatus = value.status;
      debugPrint("Add Notes Status == $notesStatus");
      /*  debugPrint("Add Notes ProjectId == ${value.data.projectId}");
      debugPrint("Add Notes noteId == ${value.data.noteId}");
      debugPrint("Add note ProjectId == ${value.data.note}");
      debugPrint("Add Notes ProjectId == ${value.data}");
      debugPrint("Add Notes ProjectId == ${value.data.projectId}");
      debugPrint("Add Notes ProjectId == ${value.data.projectId}");
      debugPrint("Add Notes ProjectId == ${value.data.projectId}");
      debugPrint("Add Notes ProjectId == ${value.data.projectId}");
      debugPrint("Add Notes ProjectId == ${value.data.projectId}");
   */
      if (notesStatus == true) {
        final snackBar = SnackBar(
          content: widget.editNote != true
              ? Text("New Note Successfully Added")
              : Text("Note Updated successfully"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // int count = 0;
        // Navigator.of(context).popUntil((_) => count++ >= 2);
        Navigator.popAndPushNamed(context, "/notes");
        // });
      } else {
        final snackBar = SnackBar(
          content: Text("New Note Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   Navigator.popAndPushNamed(context, "/addNotes");
      }
      /* setState(() {
        BiddingGlobalValue.editAndSaveNotes = value.data;
      });*/
    });
    // setState(() {
    isLoading = false;
    // });
  }

  /* @override
  void dispose() {
    try{
      if(!mounted) {
        descriptionController.text;
        _formKey.currentState.dispose();
      }
    } catch (e){
      debugPrint("Dispose Error Catch === $e");
      throw Exception("Dispose Error Catch === $e");
    }
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text(widget.editNote != true ? 'Add Notes' : "Edit Note"),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
              child: ListView(children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                              tabListData != null &&
                              tabListData.isNotEmpty
                          ? Text("Tab*")
                          : SizedBox(),
                      tabListData != null && tabListData.isNotEmpty
                          ? buildDropdownButton('Select Tab', 'Tab is Required',
                              tabListData, selectedTab, dropdownValueChanged, 1)
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 45),
                        child: Row(
                          children: [
                            Flexible(
                              child: ListTile(
                                leading: Checkbox(
                                    value: isPrivateStatus,
                                    onChanged: privateNote),
                                title: Text("Private"),
                                horizontalTitleGap: -11,
                              ),
                            ),
                            Flexible(
                              child: ListTile(
                                leading: Checkbox(
                                    value: isSemiPrivateStatus,
                                    onChanged: subPrivateNotes),
                                title: Text("Semi Private"),
                                horizontalTitleGap: -11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(' Note'),
                      MarkdownTextInput(
                        (String value) => setState(() {
                          description = value;
                          // debugPrint("description printing == $description");
                          // debugPrint("description printing == ${descriptionController.text.split(".")[0]}");
                        }),
                        description,
                        //  hintText: "Description *",
                        label: 'Note',
                        maxLines: 4,
                        actions: MarkdownType.values,
                        controller: descriptionController,
                        validators: (value) {
                          if (value.isEmpty) {
                            return "Note is Required";
                          } else {
                            return null;
                          }
                        },
                      ),
                      /* Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: MarkdownBody(
                    data: description,
                    shrinkWrap: true,
                  ),
                ),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: TransparentButton(
                                  colorCode: 0xff0098D4, buttonName: "Save"),
                              onTap: () {
                                if (buttonPress() == true) {
                                  addNotesSave();
                                  // Navigator.popUntil(context, (route) => false);
                                }
                              },
                            ),
                            InkWell(
                              child: TransparentButton(
                                  colorCode: 0xffEE3737, buttonName: "Close"),
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                  debugPrint(
                                      "description printing == ${descriptionController.text.split(".")[0]}");
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          : Visible(isLoading: isLoading, message: ""),
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

  dropdownValueChanged(DrawerData value, int fieldId) {
    /*  if (widget.editNote == true) {
      setState(() {
        selectedTab?.key = BiddingGlobalValue.editNoteData.tabId;
        debugPrint("Edit Notes TAB Value === ${selectedTab?.key}");
      });
    }*/
    if (fieldId == 1)
      setState(() {
        selectedTab = value;
        debugPrint("TAB Value === ${selectedTab.value}  && ${selectedTab.key}");
      });
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

class NotesTab {
  String key;
  String value;

  NotesTab({this.value, this.key});
}

/* if (widget.editNote && BiddingGlobalValue.editNoteData.tabId == "1507931") {
      selectedTabIndex = 0;
    } else if (widget.editNote &&
        BiddingGlobalValue.editNoteData.tabId == "269713") {
      selectedTabIndex = 1;
    } else if (widget.editNote &&
        BiddingGlobalValue.editNoteData.tabId == "81121") {
      selectedTabIndex = 2;
    } else if (widget.editNote &&
        BiddingGlobalValue.editNoteData.tabId == "686165") {
      selectedTabIndex = 3;
    } else if (widget.editNote &&
        BiddingGlobalValue.editNoteData.tabId == "430378") {
      selectedTabIndex = 4;
    } else if (widget.editNote &&
        BiddingGlobalValue.editNoteData.tabId == "634427") {
      selectedTabIndex = 5;
    } else if (widget.editNote &&
        BiddingGlobalValue.editNoteData.tabId == "1088159") {
      selectedTabIndex = 6;
    }*/
