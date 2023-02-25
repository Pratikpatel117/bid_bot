import 'package:bidbot/api/active_and_archive_project/startUp_dates/startUp_date_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/startUp_date/startUp_date_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../const/style_const.dart';

class StartUpDatePage extends StatefulWidget {
  const StartUpDatePage({Key key}) : super(key: key);

  @override
  _StartUpDatePageState createState() => _StartUpDatePageState();
}

class _StartUpDatePageState extends State<StartUpDatePage> {
  final selectedDateController = TextEditingController();
  bool isLoading = false;
  String projectId = " ";
  List<StartUpDateData> startUpDatesList = [];
  int selectionIndex;
  bool isRequestedDate = false;
  int requestedIndex;

  String selectRequestDate = " ";
  StartupRequestDate startupRequestDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 3) {
      projectId = ActiveProjectGlobalValue.activeProjectStartUpDateProjectId;
    } else if (GlobalValues.selectedBidIndex == 4) {
      projectId = ProjectArchivesGlobalValue.projectArchiveStartUpDateProjectId;
    }
    getStartUpDateData(projectId);
  }

  StartUpDatesApi startUpDatesApi = StartUpDatesApi();

  Future getStartUpDateData(String projectId) async {
    setState(() {
      isLoading = true;
    });
    List<StartUpDateData> list = [];
    await startUpDatesApi.getStartUpDates(projectId).then((value) {
      var status = value.status;
      debugPrint("StartUp Date responce = $status");
      if (status == true) {
        value.data.forEach((element) {
          list.add(element);
        });
      }
    });
    setState(() {
      isLoading = false;
      startUpDatesList.addAll(list);
    });
  }

  Future requestStartUpDateChange(String equipmentId) async {
    setState(() {
      isLoading = true;
      startUpDatesList.clear();
    });
    startupRequestDate =
        StartupRequestDate(startupRequestDate: selectRequestDate);
    await startUpDatesApi
        .requestStartUpDate(startupRequestDate, equipmentId)
        .then((value) {
      var updateResult = value.status;
      // if(lineItemsProjectList.isDisplayProposal == "1"){
      //   isDisplayProposal = false;
      // } else if(lineItemsProjectList.isDisplayProposal == "0"){
      //   isDisplayProposal = true;
      // }
      debugPrint('update Display Proposal code =====  $updateResult');
      if (updateResult == true) {
        final snacbar = SnackBar(
          content: Text("Requested start up date updated suceessfully !"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);

        Navigator.popAndPushNamed(context, "/startUpDate");

        // Navigator.pop(context);
        // setState(() {
        // getProfileData();
        // });
      } else {
        final snacbar = SnackBar(
          content: Text("StartUp Date did not Requested"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snacbar);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context, String equipmentId) async {
    DateTime selectedDate = DateTime.now();
    // DateFormat formatter = DateFormat('yyyy-MM-dd');
    // String formatted = formatter.format(selectedDate);
    //  String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
    final DateTime picked = await showDatePicker(
      context: context,
      // fieldHintText: "rgegdgg",
      helpText: "MM/dd/yyyy",
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked == null) {
      selectedDate = null;
      selectRequestDate = null;
      // requestStartUpDateChange(equipmentId) ;
    }
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // selectedDateController.text =
        //     DateFormat('MM-dd-yyyy').format(selectedDate);
        // selectStartUpDate = DateFormat.yMd().add_jm().format(selectedDate);
        selectRequestDate = DateFormat('MM/dd/yyyy').format(selectedDate);
        selectedDateController.text =
            DateFormat('MM/dd/yyyy').format(selectedDate);
        /* estimatedBidDate.text = DateFormat('MM-dd-yyyy').format(
          selectedDate.toLocal().add(Duration(
                hours: 12,
            minutes: 00,
          )),
        );*/ //  selectedDate.toLocal().toString().split(" ")[0];
      });
      // debugPrint("selectedDate===${estimatedBidDate.text}");
      // debugPrint("pickBidDate===$pickBidDate");
      // debugPrint("anotherDate===$bidDate");
      requestStartUpDateChange(equipmentId);
      debugPrint("selectedDate===$selectRequestDate");
    }
  }

  requestDateTap(StartUpDateData startUpDateData) {
    setState(() {
      isRequestedDate = !isRequestedDate;
      selectedDateController.text = "${startUpDateData.startupRequestDate}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Startup'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? startUpDatesList.isNotEmpty && startUpDatesList != null
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    // alignment: Alignment.center,
                    // color: Colors.greenAccent,
                    child: ListView.builder(
                      physics: PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      // controller: scrollController,
                      shrinkWrap: true,
                      itemCount: startUpDatesList.length,
                      itemBuilder: (context, i) {
                        return startUpDateCard(startUpDatesList, i);
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
          : Visible(isLoading: isLoading, message: ""),
    );
  }

  Widget startUpDateCard(List<StartUpDateData> startUpData, int i) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      // color: Colors.redAccent,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          shadowColor: Color(0xff0BA2E4),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 27,
              bottom: 27,
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${startUpDatesList[i].manufacturer}",
                  style: TextstyleConst.horizontalCardHeaderStyle,
                ),
                Text(
                  "${startUpDatesList[i].product}",
                  style: TextstyleConst.horizontalCardSubHeaderStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: richText(
                            "Equipment Id : ",
                            "${startUpDatesList[i].equipmentId}",
                            i), //Icon(Icons.schedule,)
                      ),
                      Expanded(
                        child:
                            richText('Qty : ', "${startUpDatesList[i].qty}", i),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                richText(
                    "Ship Date : ", "${startUpDatesList[i].startUpDate}", i),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: richText("Tag : ", "${startUpDatesList[i].tag}", i),
                ),
                richText("Scheduled StartUp Date : ",
                    "${startUpDatesList[i].startUpDate}", i),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: richText("Actual StartUp Date : ",
                      "${startUpDatesList[i].actualStartupDate}", i),
                ),
                // richText("StartUp Date", "${startUpDatesList[i].startUpDate}", i),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: widgetRichText(
                      startUpData[i].startUpRequired == "1"
                          ? requestStartUpDate(startUpDatesList[i], i)
                          : Container(
                              height: MediaQuery.of(context).size.height / 42,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                // color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                startUpDatesList[i]
                                        .startupRequestDate
                                        .isNotEmpty
                                    ? "${startUpDatesList[i].startupRequestDate}"
                                    : " ",
                                style: TextStyle(
                                  color: Color(0xff9A9A9A),
                                  fontSize: 14,
                                  fontFamily: StringConst.FONT_FAMILY,
                                ),
                              ),
                            ),
                      "Requested StartUp Date : ",
                      i),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child: Text(
                      "${i + 1}/${startUpDatesList.length}",
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
    );
  }

  RichText widgetRichText(Widget leadingIcon, String responceText, int i) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: responceText,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 14,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        WidgetSpan(
          child: leadingIcon,
        ),
      ]),
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  Widget requestStartUpDate(StartUpDateData startUpDateData, int i) {
    return SizedBox(
      child: isRequestedDate != true || requestedIndex != i
          ? Container(
              height: MediaQuery.of(context).size.height / 42,
              width: MediaQuery.of(context).size.width / 2.25,
              decoration: BoxDecoration(
                // color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(3),
              ),
              child: InkWell(
                onDoubleTap: () {
                  setState(() {
                    requestedIndex = i;
                    requestDateTap(startUpDateData);
                  });
                },
                child: Text(
                  startUpDateData.startupRequestDate.isNotEmpty
                      ? "${startUpDateData.startupRequestDate}"
                      : "Double click to add date",
                  style: TextStyle(
                    color: Color(0xff252669),
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              alignment: Alignment.centerLeft,
            )
          : Container(
              height: MediaQuery.of(context).size.height / 39,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                // color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(2),
              ),
              child: InkWell(
                onTap: () {
                  _selectDate(context, startUpDateData.equipmentId);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: selectedDateController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ),
              ),
            ),
    );
  }

  Widget richText(String titleText, String responceText, int i) {
    return RichTextCommon(
      titleText: titleText,
      responceText: responceText,
    );
  }
}
