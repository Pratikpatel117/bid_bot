import 'package:bidbot/const/widget.dart';

class EmployeeListRequest {
  String subscriptionId;
  String verticalId;
  String sphereTypeId;

  EmployeeListRequest(
      {this.subscriptionId, this.verticalId, this.sphereTypeId});

  EmployeeListRequest.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    sphereTypeId = json['sphereTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['sphereTypeId'] = this.sphereTypeId;
    return data;
  }
}
/*Container(
        child: Column(
          children: [
            Container(
              child: ListTile(
                leading: Container(
                  // color: Colors.greenAccent,
                  height: 25, width: 15,
                  margin: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    side: BorderSide(
                      width: 1.5,
                    ),
                    activeColor: Colors.lightBlueAccent,
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),
                minLeadingWidth: 10,
                title: Row(
                  children: [
                    FlutterLogo(),
                    SizedBox(width: 5),
                    Text("Mark"),
                  ],
                ),
                trailing: Text("Lead"),
              ),
            ),
            Container(
              child: ListTile(
                leading: Container(
                  // color: Colors.greenAccent,
                  height: 25, width: 15,
                  margin: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    side: BorderSide(
                      width: 1.5,
                    ),
                    activeColor: Colors.lightBlueAccent,
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),
                minLeadingWidth: 10,
                title: Row(
                  children: [
                    FlutterLogo(),
                    SizedBox(width: 5),
                    Text("Mark"),
                  ],
                ),
                trailing: Text("Support"),
              ),
            ),
            Container(
              child: ListTile(
                leading: Container(
                  // color: Colors.greenAccent,
                  height: 25, width: 15,
                  margin: EdgeInsets.only(left: 8),
                  child: Checkbox(
                    side: BorderSide(
                      width: 1.5,
                    ),
                    activeColor: Colors.lightBlueAccent,
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),
                minLeadingWidth: 10,
                title: Row(
                  children: [
                    FlutterLogo(),
                    SizedBox(width: 5),
                    Text("Mark"),
                  ],
                ),
                trailing: Text("Management"),
              ),
            ),
            ListView.builder(
                key: Key('builder ${selected.toString()}'),
                //attention
                itemCount: 4,
                padding: EdgeInsets.only(left: 13.0, right: 13.0, bottom: 25.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return ExpansionTile(
                    title: Text("Bidders",
                        style: TextStyle(
                            color: ColorConst.appBarBackGroundColor,
                            fontSize: 17)),
                    trailing: selected != i
                        ? Icon(
                            Icons.chevron_right,
                            color: ColorConst.appBarBackGroundColor,
                          )
                        : Icon(
                            Icons.expand_more,
                          ),
                    initiallyExpanded: i == selected,
                    children: [
                      ListTile(
                        // tileColor: Colors.greenAccent,
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 9),
                        title: Container(
                          child: Row(children: [
                            Checkbox(
                              activeColor: Colors.lightBlueAccent,
                              value: isChecked,
                              onChanged: (bool value) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                            ),
                            Text("Flutter"),
                          ]),
                          // color: Colors.greenAccent,
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        subtitle: Column(
                          children: [
                            Column(children: [
                              // drawerData( Icon(
                              //   Icons.person,
                              //   color: Colors.green,
                              //   size: 20,
                              // ), "Flutter Developers"),
                              drawerData(
                                  Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  'flutter.c@ciright.com'),
                              drawerData(
                                  Icon(
                                    Icons.call,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  '+987654321'),
                            ]),
                          ],
                        ),
                      ),
                    ],
                    onExpansionChanged: (value) {
                      if (value) {
                        setState(() {
                          Duration(seconds: 20000);
                          selected = i;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    },
                  );
                }),
            Container(
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
          ],
        ),
      )*/
