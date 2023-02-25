import 'dart:isolate';

import 'package:bidbot/api/active_and_archive_project/submittals/share_document_api.dart';
import 'package:bidbot/api/bidding/player/player_api.dart';
import 'package:bidbot/api/employee_api.dart';
import 'package:bidbot/api/lead_support_management_api.dart';
import 'package:bidbot/model/active_and_archive_project/submittals/share_submittals_model.dart';
import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../../../api/bidding/bidders/bidder_api.dart';
import '../../../api/bidding/bidders/qab_bidder_api.dart';
import '../../../const/color_const.dart';
import '../../../const/widget.dart';
import '../../../model/bidding/bidder/bidder_model.dart';
import '../../../model/bidding/bidder/qab_bidder_model.dart';
import '../../../model/bidding/player/player_model.dart';
import '../../../model/employee_model.dart';
import 'package:expandable_group/expandable_group_widget.dart';

import '../../../model/lead_support_management_model.dart';

class ShareDocumentPage extends StatefulWidget {
  const ShareDocumentPage({Key key}) : super(key: key);

  @override
  State<ShareDocumentPage> createState() => _ShareDocumentPageState();
}

class _ShareDocumentPageState extends State<ShareDocumentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selected = 0;
  bool isChecked = true, isLoading = false;
  LeadSupportRequest leadSupportRequest;
  EmployeeListRequest employeeListRequest;
  List<DrawerData> listOfDrawer = [];
  PlayerDataRequest playerRequest;
  List<PlayerList> playerList = [];
  List<BidderData> listOfBidderData = [];
  String projectId = "";
  List<LeadSupportData> leadSupportData = [];
  List<Map<String, List<ListItems>>> listOfItems = [];
  String leadId = "";
  String supportId = "";
  String managementId = "";
  List<String> bidderIdList = [];
  List<String> playerIdList = [];
  List<String> employeeIdList = [];
  ShareSubmittalsRequest shareRequest;

  @override
  void initState() {
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = "${BiddingGlobalValue.equipmentProposal.projectId}";
    } else if (GlobalValues.selectedBidIndex == 3) {
      projectId =
          "${ActiveProjectGlobalValue.activeProjectSubmittalsProjectId}";
    } else if (GlobalValues.selectedBidIndex == 4) {
      projectId =
          "${ProjectArchivesGlobalValue.projectArchiveSubmittalsProjectId}";
    }
    super.initState();
    getLeadSupportManagementData();
    // getQABContactData();
    getBidderData();
    getPlayerData();
    getEmployeeData();
  }

  Future shareSubmittals() async {
    setState(() {
      isLoading = true;
    });
    shareRequest = ShareSubmittalsRequest(
        employeeId: "${GlobalValues.loginEmployee.employeeId}",
        submittalId: "${ActiveProjectGlobalValue.submittalsData.submittalId}",
        recipient: [
          Recipient(
            leadId: leadId,
            supportId: supportId,
            managementId: managementId,
            bidders: bidderIdList,
            employees: employeeIdList,
            players: playerIdList,
          )
        ]);
    ShareSubmittalsApi shareSubmittalsApi = ShareSubmittalsApi();
    await shareSubmittalsApi.shareSubmittals(shareRequest).then((value) {
      var status = value.status;
      debugPrint("share Submittals api status == $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Submittals Successfully Share!"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      }
    });
    setState(() {
      isChecked = false;
    });
  }

  Future getLeadSupportManagementData() async {
    leadSupportRequest = LeadSupportRequest(projectId: projectId);
    LeadSupportManagementApi leadSupportApi = LeadSupportManagementApi();
    await leadSupportApi
        .getLeadSupportManagementData(leadSupportRequest)
        .then((value) {
      var status = value.status;
      print("lead support api status == $status");
      if (status == true) {
        leadSupportData = value.data;
      }
    });
  }

  Future getBidderData() async {
    isLoading = true;
    var list = <BidderData>[];
    var bidderList = <ListItems>[];
    BidderApi bidderApi = BidderApi();
    await bidderApi.getBidderApi(projectId).then((value) {
      var bidderStatus = value.status;
      debugPrint("status of bidderApi on Page = $bidderStatus");

      value.data?.forEach((element) {
        if (element.contactEmailAddress.isNotEmpty) {
          list.add(element);
          bidderList.add(ListItems(
            customerName: element.customer,
            emailId: element.contactEmailAddress,
            number: element.contactPhone,
            identifyId: element.bidderId,
            isCheck: false,
          ));
        }
      });
    });

    setState(() {
      listOfBidderData.addAll(list);
      bidderList.isNotEmpty ? listOfItems.add({"Bidders": bidderList}) : null;
      // listOfMultipleList.add(bidderList);
      isLoading = false;
    });
  }

  Future getPlayerData() async {
    setState(() {
      isLoading = true;
    });
    var list = <ListItems>[];
    PlayerApi playerApi = PlayerApi();
    playerRequest = PlayerDataRequest(
      verticalId: "${GlobalValues.verticalId}",
      subscriptionId: "${GlobalValues.subscriptionId}",
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: projectId,
    );
    await playerApi.getPlayerData(playerRequest).then((value) {
      var status = value.status;
      print("player status == ${value.data.playerList}");
      value.data.playerList != null && value.data.playerList.isNotEmpty
          ? value.data.playerList.forEach((element) {
              print("${element.playerId}");
              list.add(ListItems(
                customerName: element.customer,
                emailId: element.contactEmail,
                number: "",
                identifyId: element.playerId,
                isCheck: false,
              ));
            })
          : playerList = [];
      // print("player status == ${value.data.playerList}");
      // print("player List : ${playerList.first.leadName}");
    });
    list.isNotEmpty ? listOfItems.add({"Players": list}) : null;
    setState(() {
      isLoading = false;
    });
  }

  Future getEmployeeData() async {
    setState(() {
      isLoading = true;
    });
    var employeeList = <ListItems>[];
    EmployeeApi employeeApi = EmployeeApi();
    employeeListRequest = EmployeeListRequest(
        subscriptionId: "${GlobalValues.subscriptionId}",
        verticalId: "${GlobalValues.verticalId}",
        sphereTypeId: "${GlobalValues.loginEmployee.sphereTypeId}");
    await employeeApi.employeeApiData(employeeListRequest).then((value) {
      var status = value.status;
      print("status == $status");
      if (status == true) {
        setState(() {
          listOfDrawer = value.data;
          value.data.forEach((element) {
            employeeList.add(ListItems(
              customerName: element.value,
              identifyId: element.key,
              isCheck: false,
            ));
          });
          employeeList.isNotEmpty
              ? listOfItems.add({"Employee": employeeList})
              : null;
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorConst.appBarBackGroundColor,
        leading: Container(),
        titleSpacing: -30,
        title: Text("Share"),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Container(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                          child: Column(
                        children: leadSupportManagement(),
                      )),
                      Container(
                          child: Column(
                        children: subList(),
                      )),
                      InkWell(
                        onTap: () {
                          shareSubmittals();
                          debugPrint(
                              "bidder id = ${bidderIdList.length} && {bidderIdList.first}");
                          bidderIdList.forEach((element) {
                            debugPrint("bidder List == $element");
                          });
                          debugPrint(
                              "Player id = ${playerIdList.length} && {bidderIdList.first}");
                          playerIdList.forEach((element) {
                            debugPrint("Player List == $element");
                          });
                          debugPrint(
                              "Employee id = ${employeeIdList.length} && {bidderIdList.first}");
                          employeeIdList.forEach((element) {
                            debugPrint("Employee List == $element");
                          });
                          debugPrint("support id = $supportId");
                          debugPrint("lead id = $leadId");
                          debugPrint("management id = $managementId");
                          /* listOfItems.forEach((element) {
                            debugPrint("list of Items data == $element");
                            for (var key in element.keys)
                              print("map ok Key == $key");
                          });*/ // listOfMultipleList.forEach((element) {
                          //   print(
                          // });
                          bidderIdList.clear();
                          playerIdList.clear();
                          employeeIdList.clear();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 2.8,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xff4898D4),
                              borderRadius: BorderRadius.circular(7)),
                          child: Text(
                            "Share",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Visible(
              isLoading: isLoading,
              message: "",
            ),
    );
  }
/*
  String getMonth(int month) {
    switch (month) {
      case 1:
        return "Bidder";
      case 2:
        return "Player";
      case 3:
        return "Employee";
    }
  }

  List<dynamic> getWeeks() {
    return listOfMultipleList;
  }

  List<List<TextItems>> listOfText() {
    int listIndex = 3;

    List<List<Widget>> list = [];
  }

  Widget headerText(String header) {
    return Text(header);
  }*/

  List<Widget> subList() {
    List<Widget> list = [];
    listOfItems.forEach((element) {
      for (var keys in element.keys) {
        for (var value in element.values) {
          list.add(ExpandableGroup(
            header: _header(keys),
            items: _buildItems(context, value, keys),
            headerEdgeInsets: EdgeInsets.only(left: 16.0, right: 16.0),
          ));
        }
      }
    });
    return list;
  }

  Widget _header(String name) => Text(name,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ));

  List<Widget> _buildItems(
          BuildContext context, List<ListItems> items, String key) =>
      items
          .map(
            (e) => ListTile(
              // tileColor: Colors.greenAccent,
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 9),
              title: Container(
                // color: Colors.greenAccent,
                // tileColor: Colors.greenAccent,
                child: Row(children: [
                  Checkbox(
                    activeColor: Colors.lightBlueAccent,
                    value: e.getIsChecked(),
                    onChanged: (bool value) {
                      setState(() {
                        e.selectCheck(value);
                        key == "Bidders" && e.getIsChecked() == true
                            ? bidderIdList.add(e.identifyId)
                            : bidderIdList.remove(e.identifyId);
                        key == "Players" && e.getIsChecked() == true
                            ? playerIdList.add(e.identifyId)
                            : playerIdList.remove(e.identifyId);
                        key == "Employee" && e.getIsChecked() == true
                            ? employeeIdList.add(e.identifyId)
                            : employeeIdList.remove(e.identifyId);
                        // isChecked = !isChecked;
                      });
                    },
                  ),
                  Expanded(child: Text("${e.customerName}")),
                ]),
                height: MediaQuery.of(context).size.height / 25,
              ),
              subtitle: Column(
                children: [
                  Column(children: [
                    /*   drawerData( Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 20,
                ), "Flutter Developers"),*/
                    e.emailId != null
                        ? drawerData(
                            Icon(
                              Icons.email,
                              color: Colors.blue,
                              size: 18,
                            ),
                            '${e.emailId}')
                        : Container(),
                    e.number != null
                        ? drawerData(
                            Icon(
                              Icons.call,
                              color: Colors.red,
                              size: 20,
                            ),
                            '${e.number}')
                        : Container(),
                  ]),
                ],
              ),
            ),
          )
          .toList();

  Widget drawerData(Icon leadIcon, String titleText) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 13, top: 3),
          child: leadIcon,
        ),
        Text(titleText),
      ],
    );
  }

  List<Widget> leadSupportManagement() {
    List<Widget> list = [];
    int count = 0;
    for (int i = count; i < leadSupportData.length; i++) {
      list.add(
        Container(
          child: ListTile(
            leading: Container(
              height: 25,
              width: 15,
              margin: EdgeInsets.only(left: 8),
              child: Checkbox(
                side: BorderSide(
                  width: 1.5,
                ),
                activeColor: Colors.lightBlueAccent,
                value: leadSupportData[i].isChecked,
                onChanged: (bool value) {
                  setState(() {
                    leadSupportData[i].checkDone();
                    leadSupportData.first.isChecked == true
                        ? leadId = leadSupportData.first.id
                        : leadId = "";
                    leadSupportData[1].isChecked == true
                        ? supportId = leadSupportData[1].id
                        : supportId = "";
                    leadSupportData.last.isChecked == true
                        ? managementId = leadSupportData.last.id
                        : managementId = "";
                    // debugPrint("lead id ${leadSupportData[i].id}");
                    debugPrint("lead id $leadId & $supportId & $managementId");
                  });
                },
              ),
            ),
            minLeadingWidth: 10,
            title: Row(
              children: [
                ClipRRect(
                  child: Image.network(
                    "${leadSupportData[i].profileUrl}",
                    height: 40,
                    width: 40,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                SizedBox(width: 5),
                Text(leadSupportData[i].name, style: TextStyle(fontSize: 15)),
              ],
            ),
            trailing: Text(
                i == 0
                    ? "Lead"
                    : i == 1
                        ? "Support"
                        : "Management",
                style: TextStyle(
                  fontSize: 13,
                )),
          ),
        ),
      );
      count++;
    }
    return list;
  }
}

class ListItems {
  String customerName;
  String emailId;
  String number;
  bool isCheck = false;
  bool getIsChecked() {
    return isCheck;
  }

  void selectCheck(bool isChecked) {
    this.isCheck = isChecked;
  }

  String identifyId;
  ListItems(
      {this.customerName,
      this.emailId,
      this.number,
      this.isCheck,
      this.identifyId});

  void toggleDone() {
    isCheck = !isCheck;
  }
}
/*class TextItems {
  String titleText;
  Widget leadWidget;
  String email;
  String number;
  Map<String, ListItems> listItems;

  TextItems(
      {this.titleText,
      this.leadWidget,
      this.email,
      this.number,
      this.listItems});
}
*/
/*
class ListTextItems extends StatelessWidget {
  ListTextItems({Key key, this.textItems, this.title}) : super(key: key);
  Map<String, List<ListItems>> textItems;
  String title;

  Widget listItem(TextItems listItems) {
    return ExpansionTile(
      // key: PageStorageKey<ListItems>(textItems),
      title: Text(
        "${listItems.titleText}",
      ),
      // children: ,
    );
  }

  Widget withTitle(Map<String, List<ListItems>> textItems, String title) {
    if (textItems.values.isEmpty) {
      return ListTile(
        title: Text("${textItems.keys}"),
      );
    }
    var index = textItems.values.length;
    // return ExpansionTile(title: Text("${textItems.keys}",),children: listItems(textItems.values));
  }

  List<Widget> listItems(List<ListItems> listItems) {
    List<Widget> list = [];
    // list.add(Text("${listItems.customerName}"));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return withTitle(textItems, title);
  }
}*/
