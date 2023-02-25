import 'dart:convert';
import 'dart:io';

import 'package:bidbot/api/bidding/proposal/update_proposal_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/update_proposal/updateProposal_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UpdateProposal extends StatefulWidget {
  const UpdateProposal({Key key}) : super(key: key);

  @override
  _UpdateProposalState createState() => _UpdateProposalState();
}

class _UpdateProposalState extends State<UpdateProposal> {
  String documentUrl;
  String fileName;
  String fileSize;
  bool isLoading = false;
  UpdateProposalRequest proposalRequest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future updateProposal() async {
    setState(() {
      isLoading = true;
    });
    proposalRequest = UpdateProposalRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: "${BiddingGlobalValue.updateProposal.projectId}",
      fileName: fileName,
      proposalDocument: base64Encode(File(documentUrl).readAsBytesSync()),
      proposalDescription: "",
      projectExternalProposalDocumentId: null,
    );

    UploadProposalApi proposalApi = UploadProposalApi();
    await proposalApi.uploadProposalAPi(proposalRequest).then((value) {
      var status = value.status;
      debugPrint("add Proposal status ===$status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("New Proposal Successfully Added"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.popAndPushNamed(context, "/homePage");
      } else {
        final snackBar = SnackBar(
          content: Text("New Proposal Not Added"),
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
      updateProposal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Add Proposal'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/homePage");
            },
            icon: Icon(
              Icons.clear_outlined,
              color: Colors.white,
              size: 32,
            ),
            padding: EdgeInsets.only(right: 7),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90),
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
                  Navigator.popAndPushNamed(context, "/homePage");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
