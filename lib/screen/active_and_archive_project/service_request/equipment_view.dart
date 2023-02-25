import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/service_request/service_request_model.dart';
import 'package:flutter/material.dart';

class EquipmentView extends StatefulWidget {
  const EquipmentView({Key key}) : super(key: key);

  @override
  State<EquipmentView> createState() => _EquipmentViewState();
}

class _EquipmentViewState extends State<EquipmentView> {
  List<ServiceRequestData> serviceRequestData;
  int index;

  int selectionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceRequestData = ActiveProjectGlobalValue.serviceRequestData;
    index = ActiveProjectGlobalValue.equipmentIndex;
  }

  /* @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    serviceRequestData.clear();
  }*/

  // final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Service Requests'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          separatorBuilder: (context, i) {
            return Divider(
              height: 6,
              color: Colors.white,
            );
          },
          itemCount: serviceRequestData[index].equipments.length,
          itemBuilder: (context, i) {
            var equipment = serviceRequestData[index].equipments[i];
            return InkWell(
              onTap: () {
                setState(() {
                  selectionIndex = i;
                });
              },
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7, left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${equipment.manufacturer}",
                        style: TextStyle(
                          color: Color(0xff9A9A9A),
                          fontFamily: StringConst.FONT_FAMILY,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "${equipment.product}",
                        style: TextStyle(
                          color: Color(0xff9A9A9A),
                          fontFamily: StringConst.FONT_FAMILY,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      selectionIndex == i
                          ? RichTextCommon(
                              titleText: "Created Date : ",
                              responceText:
                                  "${serviceRequestData[index].createdDate}",
                            )
                          : Container(),
                      selectionIndex == i
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: RichTextCommon(
                                titleText: "Created By : ",
                                responceText:
                                    "${serviceRequestData[index].createdBy}",
                              ),
                            )
                          : Container(),
                      selectionIndex == i
                          ? RichTextCommon(
                              responceText: "${equipment.tag}",
                              titleText: "Tag : ")
                          : Container(),
                      selectionIndex == i
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 13,
                                    child: RichTextCommon(
                                      titleText: "Sub Type : ",
                                      responceText:
                                          "${serviceRequestData[index].subType}",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 11,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: RichTextCommon(
                                        titleText: "Phase : ",
                                        responceText:
                                            "${serviceRequestData[index].phase}",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      selectionIndex == i
                          ? Row(
                              children: [
                                Expanded(
                                    flex: 13,
                                    child: RichTextCommon(
                                        responceText: "${equipment.warranty}",
                                        titleText: "Warranty : ")),
                                Expanded(
                                    flex: 11,
                                    child: RichTextCommon(
                                        responceText: "${equipment.terms}",
                                        titleText: "Terms : ")),
                              ],
                            )
                          : Container(),
                      selectionIndex == i
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: RichTextCommon(
                                  responceText: "${equipment.serialNumber}",
                                  titleText: "Serial Number : "),
                            )
                          : Container(),
                      selectionIndex == i
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Start Up Required : ",
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 14,
                                      fontFamily: StringConst.FONT_FAMILY,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: InkWell(
                                        /* onTap: () {
                                      setState(() {
                                        displayProposal(
                                            lineItemsProjectList[
                                            i]);
                                        debugPrint(
                                            "is line Project Equipment Id == ${lineItemsProjectList[i].item}");
                                        debugPrint(
                                            "is line Project Equipment Id == ${lineItemsProjectList[i].isDisplayProposal}");
                                      });
                                    },*/
                                        child:
                                            equipment.isStartUpRequired == "1"
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 17,
                                                    color: Colors.greenAccent,
                                                  )
                                                : Icon(
                                                    Icons.cancel,
                                                    color: Colors.redAccent,
                                                    size: 17,
                                                  )),
                                  ),
                                ]),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
