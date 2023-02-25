import 'dart:async';

import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/bidding/add_me_as_bidder_api.dart';
import '../api/bidding/change_to_no_bid_api.dart';
import '../api/login_and_signUp/local_auth_api.dart';
import '../api/pdf_view_api.dart';
import '../api/project_info_api.dart';
import '../model/bidding/add_me_as_bidder_model.dart';
import '../model/project_information_model.dart';
import 'color_const.dart';

class FunctionConst {
  Future<List<String>> sharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('username', "${username.text}");
    var credential = prefs.getStringList("credential");
    // var  loginUserName = prefs.getString("username");
    //  var loginPassword = prefs.getString("password");
    return credential;
  }

  Future personaIndexValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
  }

  Future<bool> authenticateBioMetric() async {
    // authenticateUser();
    final isAuthenticated = await LocalAuthApi.authenticate();
    debugPrint("Authentication status === $isAuthenticated");

    if (isAuthenticated == true) {
      debugPrint("Bio authenticate");
      return true;
    } else {
      debugPrint("not authenticate");
      return false;
    }
  }

  Future getProjectInformation(String projectId, BuildContext context,
      ProjectInformationData projectData) async {
    // setState(() {
    //   widget.isLoading = true;
    // });
    ProjectInformationApi projectInformationApi = ProjectInformationApi();
    await projectInformationApi
        .getProjectInformation(projectId.toString())
        .then((value) {
      var projectResponce = value.status;
      debugPrint("get Profile Information responce = $projectResponce");
      debugPrint("get Profile Id = $projectId");
      if (projectResponce == true) {
        // setState(() {
        projectData = value.data;
        ConstWidgets().onLoading(context, projectData);
        // });
      }
    });

    // setState(() {
    //    widget.isLoading = false;
    // });
  }

  equipmentProposal(String projectId, String projectUrl, bool isLoading,
      BuildContext context) async {
    // setState(() {
    //   isLoading = true;
    // });
    PdfApi pdfApi = PdfApi();
    String url =
        "https://www.myciright.com/Ciright/api/restpdf/proposaldetail/$projectId/${GlobalValues.subscriptionId}/${GlobalValues.verticalId}/${GlobalValues.loginEmployee.employeeId}/${GlobalValues.loginEmployee.sphereTypeId}";
    debugPrint("pdf Api CAll = $url");
    // debugPrint("projectId = $projectId");
    if (projectUrl.isNotEmpty && projectUrl != null) {
      final file = await pdfApi.getPdfUrl(projectUrl);
      GlobalValues.pdfFile = file;
      // setState(() {
      //   isLoading = false;
      // });
      Navigator.pushNamed(context, "/pdfView");
    } else {
      final file = await pdfApi.proposalPdf(url);
      GlobalValues.pdfFile = file;
      debugPrint("pdf Api CAll = $file");
      // setState(() {
      //   isLoading = false;
      // });
      Navigator.pushNamed(context, "/pdfView");
    }

    /* setState(() {
      isLoading = false;
    });*/
  }
}

StreamSubscription<DataConnectionStatus> listener;
var Internetstatus = "Unknown";
bool connect;

CheckInternet() async {
  // Simple check to see if we have internet
  connect = await DataConnectionChecker().hasConnection;
  GlobalValues.checkconection = connect;
  print("conection =${GlobalValues.checkconection}");
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  print("Last results: ${DataConnectionChecker().lastTryResults}");

  // actively listen for status updates
  listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        Internetstatus = "Connected To The Internet";
        print('Data connection is available.$Internetstatus');
        /*setState(() {});*/
        break;
      case DataConnectionStatus.disconnected:
        Internetstatus = "No Internet Connection";
        /*  print('You are disconnected from the internet.$Internetstatus');
        setState(() {});*/
        break;
    }
  });
  return await DataConnectionChecker().connectionStatus;
}

class BidderStatus extends StatefulWidget {
  const BidderStatus({Key key, this.projectLink}) : super(key: key);
  final String projectLink;
  @override
  State<BidderStatus> createState() => _BidderStatusState();
}

class _BidderStatusState extends State<BidderStatus> {
  AddMeAsBidderRequest addMeAsBidderRequest;
  bool isLoading = false;
  Future changeToNoBid(String bidderId) async {
    ChangeToNoBidApi changeToNoBidApi = ChangeToNoBidApi();
    await changeToNoBidApi.ChangeToNoBid(bidderId).then((value) {
      var status = value.status;
      debugPrint("Remove Bids status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Bidder Successfully Removed"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // Navigator.popAndPushNamed(context, "/homePage",
        //     arguments: {"isLogin": false});
      } else {
        final snackBar = SnackBar(
          content: Text("Bidder Add Submittals Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addMeAsBidderTap(widget.projectLink);
  }

  Future addMeAsBidderTap(String projectLink) {
    setState(() {
      isLoading = true;
    });
    /*  widget.addMeBidderTap = true;
    final getXBox = GetStorage();
    getXBox.write("bidderTap", widget.sectionList);*/
    addMeAsBidderRequest = AddMeAsBidderRequest(
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      appId: "${GlobalValues.appId}",
      link: projectLink,
    );
    AddMeAsBidderApi addMeAsBidderApi = AddMeAsBidderApi();
    addMeAsBidderApi.addMeAsBidderTap(addMeAsBidderRequest).then((value) {
      var status = value.status;
      debugPrint("update Submittals status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Bidder Added Successfully"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // widget.reCallGetBidding("$projectDate");
      } else {
        final snackBar = SnackBar(
          content: Text("Error while adding as a bidder"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    setState(() {
      isLoading = false;
      GlobalValues.addMeAsBidderTap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ConstWidgets {
  /* getProjectInformation(String projectId, bool isLoading ,BuildContext context ,ProjectInformationData projectData) async {
    setState(() {
      isLoading = true;
    });
    ProjectInformationApi projectInformationApi = ProjectInformationApi();
    await projectInformationApi.getProjectInformation(projectId).then((value) {
      var projectResponce = value.status;
      debugPrint("get Profile Information responce = $projectResponce");
      debugPrint("get Profile Id = $projectId");
      if (projectResponce == true) {
        setState(() {
          projectData = value.data;
          // _onLoading();
          onLoading(context, projectData);
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }*/

  onLoading(BuildContext context, ProjectInformationData projectData) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: EdgeInsets.all(13),
          backgroundColor: Color(0xff3F407B),

          /*        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  projectRichText('Project Name : ',
                      " ${projectData.projectName.isNotEmpty && projectData.projectName != "null" ? projectData.projectName : ' '}"),
                  projectRichText('ProjectId : ',
                      " ${projectData.projectId.isNotEmpty && projectData.projectId != "null" ? projectData.projectId : ' '}"),
                  projectRichText('Lead : ',
                      " ${projectData.lead.isNotEmpty && projectData.lead != "null" ? projectData.lead : ' '}"),
                  projectRichText('Estimated By : ',
                      " ${projectData.estimatedBy.isNotEmpty && projectData.estimatedBy != "null" ? projectData.estimatedBy : ' '}"),
                  projectRichText('Sold To : ',
                      " ${projectData.soldTo.isNotEmpty && projectData.soldTo != "null" ? projectData.soldTo : ' '}"),
                  projectRichText('Phase : ',
                      " ${projectData.phase.isNotEmpty && projectData.phase != "null" ? projectData.phase : ' '}"),
                  projectRichText('Probability : ',
                      " ${projectData.probability.isNotEmpty && projectData.probability != "null" ? projectData.probability : ' '}"),
                  projectRichText('Go Probability : ',
                      " ${projectData.goProbability.isNotEmpty && projectData.goProbability != "null" ? projectData.goProbability : ' '}"),
                  projectRichText('Created Date : ',
                      " ${projectData.createdDate.isNotEmpty && projectData.createdDate != "null" ? projectData.createdDate : ' '}"),
                  projectRichText('Project Value : ',
                      " ${projectData.projectValue.isNotEmpty && projectData.projectValue != "null" ? projectData.projectValue : ' '}"),
                  projectRichText('Equipment Value : ',
                      " ${projectData.equipmentValue.isNotEmpty && projectData.equipmentValue != "null" ? projectData.equipmentValue : ' '}"),
                  // projectRichText('Description : ',
                  //     " ${projectData.description != "null" ? projectData.description : ' '}"),
                  RichText(
                    text: TextSpan(
                        // text: 'Project Name : ',
                        */ /*  style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: StringConst.FONT_FAMILY,
                      ),*/ /*
                        children: [
                          // TextSpan(
                          //   text: "Description : ",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.bold,
                          //     fontFamily: StringConst.FONT_FAMILY,
                          //   ),
                          // ),
                          WidgetSpan(
                              child: Text(
                            "Description : ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: StringConst.FONT_FAMILY,
                            ),
                          )),
                          WidgetSpan(
                            child: projectData.description.isNotEmpty &&
                                    projectData.description != "null"
                                ? MarkdownBody(
                                    data: projectData.description,
                                    shrinkWrap: true,
                                    styleSheet: MarkdownStyleSheet(
                                      a: TextstyleConst.projectInfoMarkText,
                                      em: TextstyleConst.projectInfoMarkText,
                                      strong:
                                          TextstyleConst.projectInfoMarkText,
                                      del: TextstyleConst.projectInfoMarkText,
                                      p: TextstyleConst.projectInfoMarkText,
                                      blockquote:
                                          TextstyleConst.projectInfoMarkText,
                                      checkbox:
                                          TextstyleConst.projectInfoMarkText,
                                      code: TextstyleConst.projectInfoMarkText,
                                      h1: TextstyleConst.projectInfoMarkText,
                                      h2: TextstyleConst.projectInfoMarkText,
                                      h3: TextstyleConst.projectInfoMarkText,
                                      h4: TextstyleConst.projectInfoMarkText,
                                      h5: TextstyleConst.projectInfoMarkText,
                                      h6: TextstyleConst.projectInfoMarkText,
                                      listBullet:
                                          TextstyleConst.projectInfoMarkText,
                                      img: TextstyleConst.projectInfoMarkText,
                                      tableHead:
                                          TextstyleConst.projectInfoMarkText,
                                      tableBody:
                                          TextstyleConst.projectInfoMarkText,
                                    ),
                                  )
                                : SizedBox(),*/

          content: Container(
            height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                projectRichText('Project Name : ',
                    " ${projectData.projectName.isNotEmpty && projectData.projectName != "null" ? projectData.projectName : ' '}"),
                projectRichText('ProjectId : ',
                    " ${projectData.projectId.isNotEmpty && projectData.projectId != "null" ? projectData.projectId : ' '}"),
                projectRichText('Lead : ',
                    " ${projectData.lead.isNotEmpty && projectData.lead != "null" ? projectData.lead : ' '}"),
                projectRichText('Estimated By : ',
                    " ${projectData.estimatedBy.isNotEmpty && projectData.estimatedBy != "null" ? projectData.estimatedBy : ' '}"),
                projectRichText('Sold To : ',
                    " ${projectData.soldTo.isNotEmpty && projectData.soldTo != "null" ? projectData.soldTo : ' '}"),
                projectRichText('Phase : ',
                    " ${projectData.phase.isNotEmpty && projectData.phase != "null" ? projectData.phase : ' '}"),
                projectRichText('Probability : ',
                    " ${projectData.probability.isNotEmpty && projectData.probability != "null" ? projectData.probability : ' '}"),
                projectRichText('Go Probability : ',
                    " ${projectData.goProbability.isNotEmpty && projectData.goProbability != "null" ? projectData.goProbability : ' '}"),
                projectRichText('Created Date : ',
                    " ${projectData.createdDate.isNotEmpty && projectData.createdDate != "null" ? projectData.createdDate : ' '}"),
                projectRichText('Project Value : ',
                    " ${projectData.projectValue.isNotEmpty && projectData.projectValue != "null" ? projectData.projectValue : ' '}"),
                projectRichText('Equipment Value : ',
                    " ${projectData.equipmentValue.isNotEmpty && projectData.equipmentValue != "null" ? projectData.equipmentValue : ' '}"),
                RichText(
                  text: TextSpan(
                      // text: 'Project Name : ',
                      /*  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: StringConst.FONT_FAMILY,
                    ),*/
                      children: [
                        WidgetSpan(
                            child: Text(
                          "Description : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: StringConst.FONT_FAMILY,
                          ),
                        )),
                        WidgetSpan(
                          child: projectData.description.isNotEmpty &&
                                  projectData.description != "null"
                              ? MarkdownBody(
                                  data: projectData.description,
                                  shrinkWrap: true,
                                  styleSheet: MarkdownStyleSheet(
                                    a: TextstyleConst.projectInfoMarkText,
                                    em: TextstyleConst.projectInfoMarkText,
                                    strong: TextstyleConst.projectInfoMarkText,
                                    del: TextstyleConst.projectInfoMarkText,
                                    p: TextstyleConst.projectInfoMarkText,
                                    blockquote:
                                        TextstyleConst.projectInfoMarkText,
                                    checkbox:
                                        TextstyleConst.projectInfoMarkText,
                                    code: TextstyleConst.projectInfoMarkText,
                                    h1: TextstyleConst.projectInfoMarkText,
                                    h2: TextstyleConst.projectInfoMarkText,
                                    h3: TextstyleConst.projectInfoMarkText,
                                    h4: TextstyleConst.projectInfoMarkText,
                                    h5: TextstyleConst.projectInfoMarkText,
                                    h6: TextstyleConst.projectInfoMarkText,
                                    listBullet:
                                        TextstyleConst.projectInfoMarkText,
                                    img: TextstyleConst.projectInfoMarkText,
                                    tableHead:
                                        TextstyleConst.projectInfoMarkText,
                                    tableBody:
                                        TextstyleConst.projectInfoMarkText,
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ]),
                  textAlign: TextAlign.center,
                ),
                // projectRichText('Description : ',
                //     " ${projectData.description != "null" ? projectData.description : ' '}"),
              ],
            ),
          ),
        );
      },
    );
    // Navigator.of(context,rootNavigator: true).pop();
  }

  RichText projectRichText(String textFirst, String textSecond) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: textFirst,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        TextSpan(
          text: textSecond,
          //${projectData.projectName.isNotEmpty ? projectData.projectName : ""}
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            // fontWeight: FontWeight.bold,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        )
      ]),
    );
  }
}

class InputDecorationConst {
  buildInputDecoration(
      String hintText, Widget suffixWidget, bool isFilledText) {
    return InputDecoration(
      errorStyle: TextStyle(
        height: 0.5,
        fontSize: 11,
      ),
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
      border: OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8)),
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
      hintText: hintText,
      suffixIcon: suffixWidget,
      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      //padding according to your need
      hintStyle: TextstyleConst.addSubmittalsTextFieldStyle,
      fillColor: isFilledText != true ? Colors.white : Color(0xffCCCCCC),
    );
  }
}
/*
// class initialize
List<Equipments> listEquipment = [];
Equipments equipments;

// submit api parameter
{
 equipments : [
   {
     equipmentId :
   }
]

}

class Equipments {
  String equipmentId;
  String serialNumber;
  Equipments({this.equipmentId,this.serialNumber});
}
// check box on changed method
setState((){
  equipments.equipmetId = equiomentId {Api given }
  equipments.serialnumber = serialNumber {Api given }
})
*/
