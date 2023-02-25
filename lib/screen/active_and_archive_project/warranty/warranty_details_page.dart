import 'package:bidbot/api/active_and_archive_project/warranty/warranty_details_api.dart';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/warranty/warranty_details_model.dart';
import 'package:flutter/material.dart';

class WarrantyDetailsPage extends StatefulWidget {
  const WarrantyDetailsPage({Key key}) : super(key: key);

  @override
  _WarrantyDetailsPageState createState() => _WarrantyDetailsPageState();
}

class _WarrantyDetailsPageState extends State<WarrantyDetailsPage> {
  String projectId = " ";
  List<WarrantyData> warrantyData = [];
  bool isLoading = false;
  int selectionIndex = 0;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalValues.selectedBidIndex == 3) {
      projectId =
          "${ActiveProjectGlobalValue.activeProjectWarrantyDetailsProjectId}";
    } else if (GlobalValues.selectedBidIndex == 4) {
      projectId =
          "${ProjectArchivesGlobalValue.projectArchiveWarrantyDetailsProjectId}";
    }
    getWarrantyDetails(projectId);
  }

  Future getWarrantyDetails(String projectId) async {
    setState(() {
      isLoading = true;
    });
    WarrantyDetailsApi warrantyDetailsApi = WarrantyDetailsApi();
    List<WarrantyData> list = [];
    await warrantyDetailsApi.getWarrantyDetails(projectId).then((value) {
      var apiResponce = value.status;
      debugPrint("warranty details == $apiResponce");
      value.data.forEach((element) {
        list.add(element);
      });
    });
    setState(() {
      isLoading = false;
      warrantyData.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff252669),
          leading: Container(),
          titleSpacing: -30,
          title: Text('Warranty '),
          actions: [
            PopBackAction(),
          ],
        ),
        body: isLoading != true
            ? warrantyData.isNotEmpty && warrantyData != null
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          physics: PageScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: warrantyData.length,
                          // controller: scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return detailsCard(warrantyData, i);
                          },
                          /*separatorBuilder: (context, i) {
                            return Divider(
                              color: Colors.white,
                              height: 0,
                            );
                          },*/
                        )),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "No data to display",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
            : Visible(isLoading: isLoading, message: ""),
      ),
    );
  }

  Widget detailsCard(List<WarrantyData> warrantyDetails, int i) {
    selectionIndex = i;
    return Container(
      // width: 400.0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Center(
        child: Card(
          // color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // if you need this
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${warrantyData[i].manufacturer}",
                  style: TextstyleConst.horizontalCardHeaderStyle,
                ),
                Text(
                  "${warrantyData[i].product}",
                  style: TextStyle(
                    color: Color(0xff9A9A9A),
                    fontFamily: StringConst.FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                selectionIndex == i
                    ? Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 7),
                        child: richText("Qty : ", "${warrantyData[i].qty}", i),
                      )
                    : Container(),
                selectionIndex == i
                    ? richText("Tag : ", "${warrantyData[i].tag}", i)
                    : Container(),
                selectionIndex == i
                    ? Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 7),
                        child: richText("Equipment Id : ",
                            "${warrantyData[i].equipmentId}", i),
                      )
                    : Container(),
                selectionIndex == i
                    ? richText('Warranty term : ',
                        "${warrantyData[i].warrantyTerm}", i)
                    : Container(),
                selectionIndex == i
                    ? Padding(
                        padding: const EdgeInsets.only(
                          bottom: 7,
                          top: 7,
                        ),
                        child: richText("Warranty Type : ",
                            "${warrantyData[i].warrantyType}", i),
                      )
                    : Container(),
                selectionIndex == i
                    ? richText(
                        "StartUp Date : ", "${warrantyData[i].startUpDate}", i)
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child: Text(
                      "${i + 1}/${warrantyData.length}",
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

  RichText richText(String titleText, String responceText, int i) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: titleText,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 16,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
        TextSpan(
          text: responceText,
          style: TextStyle(
            color: Color(0xff9A9A9A),
            fontSize: 16,
            fontFamily: StringConst.FONT_FAMILY,
          ),
        ),
      ]),
    );
  }
}
