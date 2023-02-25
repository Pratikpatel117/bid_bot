import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bidder/qab_bidder_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../api/bidding/bidders/qab_bidder_api.dart';
import '../../../const/color_const.dart';

class QuickAddBidderPage extends StatefulWidget {
  const QuickAddBidderPage({Key key, this.customerId}) : super(key: key);
  final String customerId;
  @override
  _QuickAddBidderPageState createState() => _QuickAddBidderPageState();
}

class _QuickAddBidderPageState extends State<QuickAddBidderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool isLoading = false;
  List<QABContactData> qabcontactdata = [];
  QABSubmitData qabSubmitData;
  QABContactData _qabContactData;
  String projectId = "";
  List<String> contactIdarr = [];
  int index = 0;
  bool isChecked = false;

  /*Future checkboxCallback(
      bool checkboxState, List<QABContactData> contactData) {
    setState(() {
      // _qabContactData.toggleDone();
      if (isChecked == null) {
        print("select checkbox");
      }
      isChecked = checkboxState;
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQABContactData();
  }

  Future submitQabContactdata() async {
    print(qabcontactdata.length);

    projectId = BiddingGlobalValue.bidderData.projectId;
    QABBidderApi qabBidderApi = QABBidderApi();
    qabSubmitData = QABSubmitData(
      projectId: projectId,
      customerId: '${widget.customerId}',
      contactIds: contactIdarr,
      employeeId: '${GlobalValues.loginEmployee.employeeId}',
    );

    await qabBidderApi.submitselectedcontactdata(qabSubmitData).then((value) {
      var status = value.status;
      debugPrint("Contact list submit status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Contact data Save "),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
        Navigator.popAndPushNamed(context, "/bidder");
      } else {
        final snackBar = SnackBar(
          content: Text("Please Select Contacts!"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    qabcontactdata.clear();
    contactIdarr.clear();
  }

  Future getQABContactData() async {
    isLoading = true;
    qabcontactdata.clear();

    QABBidderApi qabBidderApi = QABBidderApi();
    List<QABContactData> list = [];
    await qabBidderApi.QABContactData("${widget.customerId}").then((value) {
      var status = value.status;
      debugPrint("get QAB Contact Data == $status");
      value.data?.forEach((element) {
        list.add(element);
      });
      qabcontactdata.addAll(list);
    });

    setState(() {
      contactIdarr.clear();
      //   qabcontactdata.addAll(list);
      isLoading = false;
    });
    debugPrint("qab contact data == ${qabcontactdata.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Add Bidders'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? SafeArea(
              child: qabcontactdata.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                        height: 0,
                                      ),
                                  itemCount: qabcontactdata.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          debugPrint(
                                              "qabdata = ${qabcontactdata.length}");
                                          index = i;
                                        });
                                      },
                                      child: Card(
                                        elevation: 5,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new ListTile(
                                                title: Row(children: [
                                                  Checkbox(
                                                      activeColor: Colors
                                                          .lightBlueAccent,
                                                      value: qabcontactdata[i]
                                                          .isDone,
                                                      onChanged: (contactlist) {
                                                        setState(() {
                                                          qabcontactdata[i]
                                                              .toggleDone();
                                                          contactIdarr.add(
                                                              qabcontactdata[i]
                                                                  .customerContactId);
                                                        });
                                                        debugPrint(
                                                            "contact list val == ${contactIdarr.length}");
                                                      }
                                                      /*checkboxCallback(qabcontactdata[i].toggleDone()),*/
                                                      ),
                                                  Flexible(
                                                    child: Text(
                                                        "${qabcontactdata[i].customerContactName}"),
                                                  )
                                                ]),
                                                subtitle: index == i
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                              Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .green,
                                                                size: 20,
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                    '${qabcontactdata[i].title}'),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                              Icon(
                                                                Icons.email,
                                                                color:
                                                                    Colors.blue,
                                                                size: 18,
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                              Text(
                                                                  '${qabcontactdata[i].email}'),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                              Icon(
                                                                Icons.call,
                                                                color:
                                                                    Colors.red,
                                                                size: 20,
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                              Text(
                                                                  '${qabcontactdata[i].phone}'),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        child: TransparentButton(
                                            colorCode: 0xff0098D4,
                                            buttonName: "Save"),
                                        onTap: () {
                                          setState(() {
                                            print(qabcontactdata.length);
                                            contactIdarr.forEach((element) {
                                              print(
                                                  " array = ${element.length}");
                                            });
                                            if (buttonPress() == true) {
                                              submitQabContactdata();
                                            } else {
                                              debugPrint(
                                                  "Submit Button Action == False");
                                            }
                                          });
                                        }),
                                    InkWell(
                                      child: TransparentButton(
                                          colorCode: 0xffEE3737,
                                          buttonName: "Close"),
                                      onTap: () {
                                        setState(() {
                                          Navigator.popAndPushNamed(
                                              context, "/bidder");
                                          debugPrint("");
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Center(
                          child: Text(
                            "No Data to display",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      )))
          : Visible(isLoading: isLoading, message: " "),
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      isChecked = val;
    });
  }

  bool buttonPress() {
    if (contactIdarr.isEmpty) {
      final snackBar = SnackBar(
        content: Text("Please Select Bidder Contact!"),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else
      return true;
  }
}
