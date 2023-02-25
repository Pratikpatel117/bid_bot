import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bidbot/api/bidding/player/player_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/player/player_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/routes.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key key}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool isLoading = false;
  List<PlayerList> listOfPlayer = [];
  PlayerDataRequest playerRequest;
  int selectionIndex = 0;
  String projectId = " ";

  @override
  void initState() {
    super.initState();
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.playerData.projectId;
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidlistPlayer.projectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidPlayer.projectId;
    }
    playerData();
  }

  Future playerData() async {
    setState(() {
      isLoading = true;
      listOfPlayer.clear();
    });
    PlayerApi playerApi = PlayerApi();

    playerRequest = PlayerDataRequest(
      projectId: projectId,
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
    );
    var list = <PlayerList>[];
    await playerApi.getPlayerData(playerRequest).then((value) {
      var status = value.status;

      debugPrint("player Get Data === $status");
      debugPrint("User Token value -->  ${GlobalValues.userToken}");

      value.data.playerList?.forEach((element) {
        list.add(element);
      });
    });
    setState(() {
      listOfPlayer.addAll(list);
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
        title: Text('Players'),
        actions: [
          TabRights.tabListData.any((element) => element.isAdd == 1)
              ? InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/addPlayer");
                  },
                  child: Icon(
                    Icons.add_outlined,
                    size: 32,
                  ),
                )
              : Container(),
          PopBackAction(),
        ],
      ),
      body: Stack(children: [
        isLoading != true
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    left: 12,
                    top: 12,
                  ),
                  child: Column(
                    children: [
                      listOfPlayer.length != 0 && listOfPlayer != null
                          ? Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, i) {
                                  return Divider(
                                    height: 3,
                                    color: Colors.transparent,
                                  );
                                },
                                itemCount: listOfPlayer.length,
                                itemBuilder: (context, i) {
                                  // listOfPlayer.sort((a, b) => a.customer.compareTo(b.customer),);
                                  return Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: Text(
                                              "${listOfPlayer[i].customer}",
                                              style: TextstyleConst
                                                  .biddingProjectTitle,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: widgetWithText(
                                                      Icon(
                                                        Icons.person,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                      " ${listOfPlayer[i].contact}"),
                                                  flex: 13,
                                                ),
                                                Expanded(
                                                  child: widgetWithText(
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child: Icon(
                                                          Icons.business,
                                                          color: Colors.green,
                                                          size: 17,
                                                        ),
                                                      ),
                                                      " ${listOfPlayer[i].discipline}"),
                                                  flex: 11,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //bidDate
                                                Expanded(
                                                  child: widgetWithText(
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 3),
                                                        child: Icon(
                                                          Icons.work,
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 17,
                                                        ),
                                                      ),
                                                      " ${listOfPlayer[i].businessType}"),
                                                  flex: 13,
                                                ),

                                                Expanded(
                                                  child: widgetWithText(
                                                      Image.asset(
                                                        "asset/image/bidding/businessman.png",
                                                        height: 19,
                                                        width: 19,
                                                      ),
                                                      " ${listOfPlayer[i].leadName}"),
                                                  flex: 11,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("No data to display"),
                            ),
                    ],
                  ),
                ),
              )
            : Visible(isLoading: isLoading, message: "Loading Players"),
      ]),
    );
  }

  RichText widgetWithText(Widget leadWidget, String titleText) {
    return RichText(
        text: TextSpan(children: [
      WidgetSpan(
        child: leadWidget,
      ),
      TextSpan(
        text: titleText,
        style: TextstyleConst.biddingRichTextStyle,
      ),
    ]));
  }

  Future<PlayerDataResponse> getPlayerData(
      PlayerDataRequest playerRequest) async {
    final String api = "${StringConst.API}m1342611";
    final response = await http.post(
      Uri.parse(api),
      body: jsonEncode(playerRequest.toJson()),
      headers: GlobalValues.apiHeaders,
    );

    debugPrint("player APi response = ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        return PlayerDataResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        debugPrint("your password is changed --> ${response.statusCode}");
        logout();
      } else {
        return PlayerDataResponse(
            status: false, message: "Invalid Player Data");
      }
    } catch (e) {
      debugPrint("Player Exception  Error = $e");
      throw Exception("Player Exception Error $e");
    }
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("username");
    Navigator.pushNamedAndRemoveUntil(context, loginPage, (route) => false);
    GlobalValues.userToken = null;
    GlobalValues.loginEmployee = null;
    GlobalValues.selectedBidIndex = 0;
    GlobalValues.calenderView = true;
    GlobalValues.drawerListData.clear();
    TabRights.tabListData.clear();
    TabRights.sideMenuBidding.clear();
    TabRights.iconsBidding.clear();
    GlobalValues.manageBidData?.clear();
  }
}
