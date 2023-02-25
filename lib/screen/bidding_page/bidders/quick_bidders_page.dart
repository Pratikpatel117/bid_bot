import 'package:bidbot/api/bidding/bidders/qab_bidder_api.dart';
import 'package:bidbot/screen/bidding_page/bidders/quick_add_bidder_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../const/string_const.dart';
import '../../../const/widget.dart';
import '../../../model/bidding/bidder/qab_bidder_model.dart';

class QuickBidders extends StatefulWidget {
  const QuickBidders({Key key}) : super(key: key);

  @override
  _QuickBiddersState createState() => _QuickBiddersState();
}

class _QuickBiddersState extends State<QuickBidders> {
  bool isLoading = false;
  List<QABData> qabdata = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQABData();
  }

  Future getQABData() async {
    isLoading = true;
    qabdata.clear();

    QABBidderApi qabBidderApi = QABBidderApi();

    List<QABData> list = [];
    await qabBidderApi.qabData().then((value) {
      var status = value.status;
      debugPrint("get QAB Data == $status");
      value.data?.forEach((element) {
        list.add(element);
        // debugPrint("get QABData == $element");
      });
      qabdata.addAll(list);
    });

    setState(() {
      qabdata.addAll(list);
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
        title: Text('Bidders'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? qabdata.isNotEmpty
              ? Container(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ListView.separated(
                      itemCount: qabdata.length,
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.all(7)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        "${qabdata[i].customerName}",
                                        style: TextStyle(
                                          color: Color(0xff2A2C70),
                                          fontFamily: StringConst.FONT_FAMILY,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 25),
                                        child: Text(
                                          "${qabdata[i].bidderCount}",
                                          style: TextStyle(
                                            color: Color(0xff2A2C70),
                                            fontFamily: StringConst.FONT_FAMILY,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuickAddBidderPage(
                                                          customerId: qabdata[i]
                                                              .customerId)));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xff2A2C70),
                                            size: 21,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider(
                          height: 3,
                        );
                      },
                    ),
                  ),
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
                  ))
          : Visible(isLoading: isLoading, message: ""),
    );
  }
}
