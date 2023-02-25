import 'package:bidbot/api/active_and_archive_project/service_request/service_request_api.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/active_and_archive_project/service_request/service_request_model.dart';
import 'package:flutter/material.dart';

import '../../../const/color_const.dart';

class ServiceRequestPage extends StatefulWidget {
  const ServiceRequestPage({Key key}) : super(key: key);

  @override
  _ServiceRequestPageState createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool isLoading = false;
  List<ServiceRequestData> listOfServiceRequestData = [];
  ServiceRequestData serviceRequestData;
  ServiceRequest serviceRequest;
  int selectionIndex;
  String projectId = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServiceRequest();
  }

  getServiceRequest() async {
    setState(() {
      isLoading = true;
    });
    ServiceRequestApi serviceRequestApi = ServiceRequestApi();
    serviceRequest = ServiceRequest(
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      loginEmployeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId:
          "${ActiveProjectGlobalValue.activeProjectServiceRequestProjectId}",
    );
    await serviceRequestApi.getServiceRequest(serviceRequest).then((value) {
      // var status = value.status;
      setState(() {
        listOfServiceRequestData = value.data;
      });
    });
    setState(() {
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
        title: Text('Service Requests'),
        actions: [
          TabRights.tabListData.any((element) => element.isAdd == 1)
              ? Container(
                  margin: EdgeInsets.only(
                    right: 11,
                    top: 12,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: ColorConst.LoginButtonColor,
                  ),
                  width: 55,
                  child: InkWell(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, "/addServiceRequest");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Add',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                        ],
                      )),
                )
              : Container(),
          /* Container(
            child: InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, "/addServiceRequest");
              },
              */ /*  child: Icon(
              Icons.add_outlined,
              size: 32,
            ),*/ /*
              child: Text(
                "ASR",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),*/
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? SafeArea(
              child: listOfServiceRequestData != null
                  ? ListView.separated(
                      separatorBuilder: (context, i) {
                        return SizedBox(
                            // height: 3,
                            );
                      },
                      itemCount: listOfServiceRequestData.length,
                      itemBuilder: (context, i) {
                        return cardDetails(listOfServiceRequestData, i);
                      },
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
          : Visible(isLoading: isLoading, message: ""),
    );
  }

  Widget cardDetails(List<ServiceRequestData> serviceRequestData, int i) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextCommon(
                titleText: "Created Date : ",
                responceText: "${serviceRequestData[i].createdDate}",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: RichTextCommon(
                  titleText: "Created By : ",
                  responceText: "${serviceRequestData[i].createdBy}",
                ),
              ),
              RichTextCommon(
                titleText: "Sub Type : ",
                responceText: "${serviceRequestData[i].subType}",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: RichTextCommon(
                        titleText: "Phase : ",
                        responceText: "${serviceRequestData[i].phase}",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 6, left: 6, right: 6, bottom: 6),
                      child: InkWell(
                        onTap: () {
                          //  Navigator.pushNamed(context, "/equipmentView");

                          ActiveProjectGlobalValue.serviceRequestData =
                              serviceRequestData;
                          ActiveProjectGlobalValue.equipmentIndex = i;
                          Navigator.pushNamed(context, "/equipmentView");
                        },
                        child: Icon(
                          Icons.skip_next,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
