// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/model/active_and_archive_project/active_project/active_project_model.dart';
import 'package:bidbot/model/active_and_archive_project/service_request/service_request_model.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/submittals_model.dart';
import 'package:bidbot/model/bid_list/bidlist_model.dart';
import 'package:bidbot/model/bidding/manage_bid_request_model.dart';
import 'package:bidbot/model/bidding/notes/add_notes_model.dart';
import 'package:bidbot/model/bidding/notes/notes_list_model.dart';
import 'package:bidbot/model/profile_model.dart';
import 'package:bidbot/model/drawer_model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:bidbot/model/bidding/bidding_model.dart';
import 'package:bidbot/model/login_and_signUp/login_model.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'color_const.dart';

class GlobalValues {
  static bool checkconection;
  static int subscriptionId = 7686051;
  static int verticalId = 324;
  static int appId = 2421;
  static String sphereUrl = "bidlist-app.htm";
  static String userToken = " ";
  static String token = "";
  static int mfa;

  static String deepLink = "";
  static String bidDateForBiddingStatus = "";
  static TargetPlatform platform;
  static bool faceIdEnable = false;
  static bool addMeAsBidderTap = false;
  static bool introscreen = false;
  static Map<String, String> apiHeaders = {
    'Accept': 'application/json',
    "Authorization": "$userToken",
    "Content-Type": "application/json",
  };
  static int selectedBidIndex = 0;
  static int personaIndex = 0;
  static Employees loginEmployee;
  static List<Employees> listOfLoginPersona;
  static List<ManageBidData> manageBidData;
  static List<TabData> drawerListData;
  static ManageBidData reviewRequestData;
  static File pdfFile;
  static bool isLoading = false;
  static List<ProjectList> biddingProjectListData; //not use
  static int isBidder = 0;
  static int isMyCompanyBidder = 0;
  static int activeProjectPaginationLimit = 25;
  static ScrollController scrollController;
  static bool calenderView = true;
  static CustomerModel loginDropValue;
  static List<ActiveProjectList> activeProjectResponce; //not use
  static ProfileData profileData;

  //not use
}

class TooltipsGlobalValues {
  static bool drawerTip = true;
  static bool bidListTip = true;
  static bool biddingTip = true;
  static bool activeTip = true;
  static bool archiveTip = true;
  static bool pendingTip = true;
}

class BiddingGlobalValue {
  static String biddingNoteProjectId;
  static String biddingLineItemsProjectId;
  static String biddingDocument;
  static ProjectList biddingForNotes;
  static NotesData editAndSaveNotes;
  static ProjectList biddingForLineItems;
  static NoteListData editNoteData;
  static ProjectList equipmentProposal;
  static ProjectList bidderData;
  static ProjectList playerData;
  static ProjectList documentData;
  static ProjectList updateProposal;
}

class BidListGlobalValue {
  static String bidListNoteProjectId;

  // static NoteListData editNoteData;
  static String bidListLineItemsProjectId;
  static BidProjectList bidListDocument;
  static BidProjectList bidlistBidder;
  static BidProjectList bidlistPlayer;
  static String bidListEquipmentProjectName;
  static BidProjectList bidListEquipmentProposal;
  static BidProjectList bidlistForNotes;
  static BidProjectList bidlistForLineItems;
}

class PendingBidGlobalValue {
  static String pendingBidNoteProjectId;
  static String pendingBidWeGotThisJobProjectId;
  static String pendingBidWeOutThisJobProjectId;

  // static NoteListData editNoteData;
  static String pendingBidLineItemsProjectId;
  static BidProjectList pendingBidEquipmentProposal;
  static BidProjectList pendingBidDocument;
  static BidProjectList pendingBidPlayer;
  static BidProjectList pendingBidBidder;
}

class ActiveProjectGlobalValue {
  static String activeProjectSubmittalsProjectId;
  static String activeProjectLineItemProjectId;
  static String activeProjectWarrantyDetailsProjectId;
  static String activeProjectScheduledShipDateProjectId;
  static String activeProjectStartUpDateProjectId;
  static String activeProjectEquipmentIOMProjectId;
  static SubmittalsData submittalsData;
  static String activeProjectServiceRequestProjectId;
  static List<ServiceRequestData> serviceRequestData;
  static int equipmentIndex;
  static Function(String customerId) contectComone;
}

class ProjectArchivesGlobalValue {
  static String projectArchiveSubmittalsProjectId;
  static String projectArchiveWarrantyDetailsProjectId;
  static String projectArchiveStartUpDateProjectId;
  static String projectArchiveEquipmentIOMProjectId;
  static int communeScreenApi;
}

class TabRights {
  static List<TabData> tabListData;

  static List<TabData> sideMenuBidding = [];

  static void extractDrawerMenuRights() {
    for (int a = 0; a < tabListData.length; a++) {
      TabData tab = tabListData[a];
      if (tab.tabTypeUrl == "bidlist-bidding.htm") {
        sideMenuBidding.add(tab);
      } else if (tab.tabTypeUrl == "bidlist-bidlist.htm") {
        sideMenuBidding.add(tab);
      } else if (tab.tabTypeUrl == "bidlist-pending.htm") {
        sideMenuBidding.add(tab);
      } else if (tab.tabTypeUrl == "bidlist-active.htm") {
        sideMenuBidding.add(tab);
      } else if (tab.tabTypeUrl == "bidlist-archives.htm") {
        sideMenuBidding.add(tab);
      }
    }
  }

  static List<TabData> iconsBidding = [];

  static void extractIconMenuRides() {
    for (int i = 0; i < tabListData.length; i++) {
      TabData tabData = tabListData[i];
      if (tabData.tabTypeUrl == 'bidlist-public-notes.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-line-item.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-proposal.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-bidders.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-players.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-files.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-update-proposal.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-add-me-as-a-bidder.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-company-bidding.htm') {
        //green tick
        iconsBidding.add(tabData);
      } else
      // Pending Bids
      if (tabData.tabTypeUrl == 'bidlist-we-got-this-job.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-we-are-out.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == "bidlist-message-your-salesman.htm") {
        iconsBidding.add(tabData);
      } else
      //Active & Archives Projects
      if (tabData.tabTypeUrl == 'bidlist-submittals.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-warranty.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == "bidlist-startup.htm") {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-ioms.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-spare-parts-list.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-service-reports.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-service-request.htm') {
        iconsBidding.add(tabData);
      } else
      /*if (tabData.tabTypeUrl == 'bidlist-revised-estimate.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-credit-split.htm') {
        iconsBidding.add(tabData);
      } else*/
      if (tabData.tabTypeUrl == 'bidlist-negotiate-order.htm') {
        iconsBidding.add(tabData); // Active isSelect == 0
      } else if (tabData.tabTypeUrl == 'bidlist-line-item-pricing.htm') {
        iconsBidding.add(tabData);
      } else if (tabData.tabTypeUrl == 'bidlist-place-order.htm') {
        iconsBidding.add(tabData);
      }
    }
  }
}

class ColorFullButton extends StatelessWidget {
  ColorFullButton({
    Key key,
    this.buttonName,
    // this.colorCode,
    this.buttonColor,
  }) : super(key: key);
  String buttonName;
  // int colorCode;
  Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      height: 36,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        buttonName,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class SearchTextFormField extends StatelessWidget {
  const SearchTextFormField({Key key, this.searchWithThrottle, this.controller})
      : super(key: key);
  final Function(String, {bool forceLoad, int throttleTime}) searchWithThrottle;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: GlobalValues.selectedBidIndex == 3 ||
              GlobalValues.selectedBidIndex == 4
          ? MediaQuery.of(context).size.width - 100
          : MediaQuery.of(context).size.width,
      child: TextFormField(
        onChanged: (name) {
          searchWithThrottle(name, forceLoad: true);
        },
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff4381b7),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          border: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: ColorConst.SearchBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                BorderSide(color: ColorConst.InputEnableBorderColor, width: 1),
          ),
          //    filled: true,
          hintText: 'Search here...',
          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          //padding according to your need
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

class Visible extends StatelessWidget {
  const Visible({
    Key key,
    @required this.isLoading,
    @required this.message,
  }) : super(key: key);
  final String message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
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
            Text(message),
          ],
        ),
      ),
      visible: isLoading,
    );
  }
}

class BottomActivityButton extends StatelessWidget {
  const BottomActivityButton(
      {Key key, @required this.colorCode, @required this.buttonName})
      : super(key: key);
  final String buttonName;
  final int colorCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12),
      height: 36,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        color: Color(colorCode),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        buttonName,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  TransparentButton(
      {Key key, @required this.colorCode, @required this.buttonName});

  final int colorCode;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      height: 38,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
          border: Border.all(color: Color(colorCode), width: 2),
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        buttonName,
        style: TextStyle(color: Color(colorCode)),
      ),
    );
  }
}

class PopBackAction extends StatelessWidget {
  const PopBackAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class RichTextCommon extends StatelessWidget {
  const RichTextCommon(
      {Key key, @required this.responceText, @required this.titleText})
      : super(key: key);
  final String titleText;
  final String responceText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: titleText,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        TextSpan(
          text: responceText,
          style: TextStyle(
            color: Color(0xff9A9A9A),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
      ]),
    );
  }
}

class DragAndDropForFileUpload extends StatelessWidget {
  const DragAndDropForFileUpload({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: DottedDecoration(
        color: Color(0xffb9b9b9),
        borderRadius: BorderRadius.circular(6),
        shape: Shape.box,
        strokeWidth: 2,
        linePosition: LinePosition.bottom,
        dash: <int>[4, 4],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.file_upload,
            color: Colors.black,
          ),
          Text(
            "Drag And Drop File here",
            style: TextStyle(
                color: Color(0xff7F7F7F),
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "Or",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xff7f7f7f)),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width / 3,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff0BA2E4),
            ),
            child: Text(
              "Browse for File",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class RoleGradientContainer extends StatelessWidget {
  RoleGradientContainer({Key key, this.imagePath, this.roleName})
      : super(key: key);
  final String imagePath;

  String roleName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5.2,
      width: MediaQuery.of(context).size.height / 5,
      decoration: BoxDecoration(
          color: Colors.redAccent,
          gradient: LinearGradient(
              colors: [
                Color(0xff90CAFF),
                Color(0xffffffff),
              ],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(9), topRight: Radius.circular(9))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "asset/image/$imagePath.png",
            height: 100,
            width: 70,
          ),
          Container(
            // width: double.infinity,
            alignment: Alignment(0, 0),
            decoration: BoxDecoration(color: Color(0xff3F407C)),
            child: Text(
              roleName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VisibleProgressBar extends StatelessWidget {
  const VisibleProgressBar({
    Key key,
    @required this.isLoading,
    @required this.message,
  }) : super(key: key);
  final String message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
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
            Text(message),
            Padding(padding: EdgeInsets.only(top: 19)),
            Container(
              height: 30,
              width: 260,
              child: LiquidLinearProgressIndicator(
                value: 0.38, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors
                    .blue), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.grey,
                borderWidth: 3.0,
                borderRadius: 8.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: Text("Loading..."),
              ),
            ),
          ],
        ),
      ),
      visible: isLoading,
    );
  }
}
