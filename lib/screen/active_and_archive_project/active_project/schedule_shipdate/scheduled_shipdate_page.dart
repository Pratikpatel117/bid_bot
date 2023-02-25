import 'package:bidbot/api/active_and_archive_project/active_project_api/scheduled_shipdate_api/sceduled_shipdate_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/active_project/scheduled_ship_date/scheduled_shipdate_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduledShipDatePage extends StatefulWidget {
  const ScheduledShipDatePage({Key key}) : super(key: key);

  @override
  _ScheduledShipDatePageState createState() => _ScheduledShipDatePageState();
}

class _ScheduledShipDatePageState extends State<ScheduledShipDatePage> {
  String projectId = " ";
  List<ShipDateData> scheduledShipDates = [];
  bool isLoading = false;
  int selectionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 3) {
      projectId =
          "${ActiveProjectGlobalValue.activeProjectScheduledShipDateProjectId}";
    }
    getScheduledShipdates(projectId);
    debugPrint("ship connection = ${GlobalValues.checkconection}");
  }

  Future getScheduledShipdates(String projectId) async {
    setState(() {
      isLoading = true;
    });
    ScheduledShipDateApi scheduledShipDateApi = ScheduledShipDateApi();
    List<ShipDateData> list = [];
    await scheduledShipDateApi.getScheduledShipDate(projectId).then((value) {
      var apiResponce = value.status;
      debugPrint("Schedule Ship Date == $apiResponce");
      value.data.forEach((element) {
        list.add(element);
      });
    });
    setState(() {
      isLoading = false;
      scheduledShipDates.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff252669),
          leading: Container(),
          titleSpacing: -30,
          title: Text('Ship Dates'),
          actions: [
            PopBackAction(),
          ],
        ),
        body: GlobalValues.checkconection == true
            ? isLoading != true
                ? scheduledShipDates.isNotEmpty && scheduledShipDates != null
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          // color: Colors.greenAccent,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: ListView.separated(
                            // controller: PageController(),
                            itemCount: scheduledShipDates.length,
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return detailsCard(scheduledShipDates, i);
                            },
                            separatorBuilder: (context, i) {
                              return Divider(
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "No data to display",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                : Visible(isLoading: isLoading, message: "")
            : Center(
                child: CupertinoAlertDialog(
                  title: const Icon(
                    Icons.wifi_off_outlined,
                    color: Colors.black,
                    size: 50,
                  ),
                  content: const Text('No Internet Connection!'),
                ),
              ));
  }

  Widget detailsCard(List<ShipDateData> scheduledShipDates, int i) {
    return Container(
      // width: 400.0,
      //   color: Colors.blueAccent,
      width: MediaQuery.of(context).size.width,

      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        shadowColor: Color(0xff0BA2E4),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${scheduledShipDates[i].manufacturer}",
                    style: TextstyleConst.horizontalCardHeaderStyle,
                  ),
                  Text(
                    "${scheduledShipDates[i].product}",
                    style: TextStyle(
                      color: Color(0xff9A9A9A),
                      fontFamily: StringConst.FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 7),
                    child:
                        richText("Tag : ", "${scheduledShipDates[i].tag}", i),
                  ),
                  richText('Qty : ', "${scheduledShipDates[i].qty}", i),
                  /*  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: richText("Equipment Id : ",
                        "${scheduledShipDates[i].equipmentId}", i),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: richText("Equipment Status : ",
                        "${scheduledShipDates[i].equipmentStatus}", i),
                  ),
                  richText("Customer Released Date : ",
                      "${scheduledShipDates[i].customerReleaseDate}", i),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: richText("Scheduled Ship Date : ",
                        "${scheduledShipDates[i].scheduledShipDate}", i),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 46),
                    child: Center(
                      child: Text(
                        "${i + 1}/${scheduledShipDates.length}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText widgetRichText(Widget leadingIcon, String responceText,
      List<ShipDateData> scheduledShipDates, int i) {
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: leadingIcon,
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
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  RichText richText(String titleText, String responceText, int i) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: titleText,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 15,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        TextSpan(
          text: responceText,
          style: TextStyle(
            color: Color(0xff9A9A9A),
            fontSize: 15,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
      ]),
    );
  }
}
/*
*  Card(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${scheduledShipDates[i].manufacturer}",
                style: TextStyle(
                  color: Color(0xff0BA2E4),
                  fontFamily: StringConst.FONT_FAMILY,
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
              Text(
                "${scheduledShipDates[i].product}",
                style: TextStyle(
                  color: Color(0xff9A9A9A),
                  fontFamily: StringConst.FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              selectionIndex == i
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: richText(
                                "Tag : ",
                                "${scheduledShipDates[i].tag}",
                                i), //Icon(Icons.schedule,)
                          ),
                          Expanded(
                            child: richText(
                                'Qty : ', "${scheduledShipDates[i].qty}", i),
                            flex: 1,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              selectionIndex == i
                  ? richText("Equipment Id : ",
                      "${scheduledShipDates[i].equipmentId}", i)
                  : Container(),
              selectionIndex == i
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          richText("Equipment Status : ",
                              "${scheduledShipDates[i].equipmentStatus}", i),
                        ],
                      ),
                    )
                  : Container(),
              selectionIndex == i
                  ? richText("Customer Released Date : ",
                      "${scheduledShipDates[i].customerReleaseDate}", i)
                  : Container(),
              selectionIndex == i
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: richText("Scheduled Ship Date : ",
                          "${scheduledShipDates[i].scheduledShipDate}", i),
                    )
                  : Container(),
              /* selectionIndex == i
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: widgetRichText(
                              Image.asset(
                                "asset/image/releasedate.jpg",
                                height: 24,
                                width: 24,
                              ),
                              "${scheduledShipDates[i].scheduledShipDate}",
                              scheduledShipDates,
                              i), //Icon(Icons.schedule,)
                          flex: 1,
                        ),
                        Expanded(
                          flex: 1,
                          child: widgetRichText(
                              Image.asset(
                                "asset/image/scheduleshipdate.png",
                                height: 24,
                                width: 24,
                              ),
                              "${scheduledShipDates[i].scheduledShipDate}",
                              scheduledShipDates,
                              i),
                        ),
                      ],
                    )
                  : Container(),*/
            ],
          ),
        ),
      ),*/
