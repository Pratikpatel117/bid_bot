import 'dart:convert';
import 'dart:io';

import 'package:bidbot/api/bidding/Notes/addNotes_api.dart';
import 'package:bidbot/api/bidding/document/add_document_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/bidding/document/add_document_model.dart';
import 'package:bidbot/model/bidding/notes/add_notes_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddDocument extends StatefulWidget {
  const AddDocument({Key key}) : super(key: key);

  @override
  _AddDocumentState createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  List<DrawerData> tabData;
  DrawerData selectedTab;
  AddNotesTabRequest tabRequest;
  String documentUrl;
  String fileName;
  String fileSize;
  AddDocumentRequest documentRequest;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabListData();
    // documentUrl != null ? uploadDocument() : null;
  }

  Future uploadDocument() async {
    setState(() {
      isLoading = true;
    });
    documentRequest = AddDocumentRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: "${BiddingGlobalValue.documentData.projectId}",
      verticalId: "${GlobalValues.verticalId}",
      subscriptionId: "${GlobalValues.subscriptionId}",
      fileSize: fileSize,
      fileName: fileName,
      document: base64Encode(File(documentUrl).readAsBytesSync()),
      sphereTypeId: "${GlobalValues.loginEmployee.sphereTypeId}",
      tabId: selectedTab != null ? "${selectedTab.key}" : "",
      isSend: "0",
    );
    AddDocumentApi documentApi = AddDocumentApi();
    await documentApi.addDocumentAPi(documentRequest).then((value) {
      var status = value.status;
      debugPrint("add Document status ===$status");
      if (status == true) {
        final snackBar = SnackBar(
            content: Text("New Document Successfully Added"),
            backgroundColor: ColorConst.successSnackBarColor);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.popAndPushNamed(context, "/document");
      } else {
        final snackBar = SnackBar(
          content: Text("New Document Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickDocument() async {
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
      uploadDocument();
    }
  }

  Future tabListData() async {
    setState(() {
      isLoading = true;
    });
    tabRequest = AddNotesTabRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      verticalId: "${GlobalValues.verticalId}",
      tabCode: 'project-Docs',
    );
    AddNotesApi addNotesTabApi = AddNotesApi();
    await addNotesTabApi.notesTabData(tabRequest).then((value) {
      var tabDataStatus = value.status;
      debugPrint("tabData Status == $tabDataStatus");
      setState(() {
        tabData = value.data;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Add Document'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  tabData != null && tabData.isNotEmpty
                      ? Row(
                          children: [
                            Text("Type"),
                          ],
                        )
                      : Container(),
                  tabData != null && tabData.isNotEmpty
                      ? buildDropdownButton('Select Tab', 'Tab is Required',
                          tabData, selectedTab, dropdownValueChanged, 1)
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: InkWell(
                      onTap: () {
                        pickDocument();
                      },
                      child: documentUrl != null
                          ? Text(fileName)
                          : DragAndDropForFileUpload(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      child: TransparentButton(
                          colorCode: 0xffDB3131, buttonName: "Close"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }

  dropdownValueChanged(DrawerData newData, int fieldId) {
    if (fieldId == 1) {
      setState(() {
        selectedTab = newData;
        debugPrint(
            "selected tab data = ${selectedTab.value} && ${selectedTab.key}");
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
