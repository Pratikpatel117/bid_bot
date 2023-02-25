import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../api/project_info_api.dart';
import '../../const/string_const.dart';
import '../../const/style_const.dart';
import '../../model/project_information_model.dart';

class ProjectInformationButton extends StatefulWidget {
  ProjectInformationButton({Key key, this.isLoading, this.projectId})
      : super(key: key);
  bool isLoading;
  String projectId;
  @override
  State<ProjectInformationButton> createState() =>
      _ProjectInformationButtonState();
}

class _ProjectInformationButtonState extends State<ProjectInformationButton> {
  ProjectInformationData projectData;
  double countValue = 0.0;

  // @override
  // void initState () {
  //   super.initState();
  // }
  getProjectInformation(String projectId) async {
    setState(() {
      widget.isLoading = true;
    });
    ProjectInformationApi projectInformationApi = ProjectInformationApi();
    await projectInformationApi.getProjectInformation(projectId).then((value) {
      var projectResponse = value.status;
      debugPrint("get Profile Information response = $projectResponse");
      debugPrint("get Profile Id = $projectId");
      if (projectResponse == true) {
        setState(() {
          projectData = value.data;
          Navigator.of(context).push(TutorialOverlay(projectData));
          // ConstWidgets().onLoading(context, projectData);
        });
      }
    });

    setState(() {
      widget.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            getProjectInformation(widget.projectId);
          });
        },
        child: Image.asset(
          "asset/image/info_1x.png",
          height: 20,
          width: 26,
        ),
      ),
    );
  }
}

class TutorialOverlay extends ModalRoute<void> {
  TutorialOverlay(this.projectData);

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;
  final ProjectInformationData projectData;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context, projectData),
      ),
    );
  }

  Widget _buildOverlayContent(
      BuildContext context, ProjectInformationData projectData) {
    double Totalprice = 0.0;
    return Center(
      child: Container(
        color: Color(0xff3F407B),
        height: MediaQuery.of(context).size.height / 1.1,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 305,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ]),

            projectRichText('Project Name : ',
                " ${projectData.projectName.isNotEmpty && projectData.projectName != "null" ? projectData.projectName : ' '}"),
            projectRichText('ProjectId : ',
                " ${projectData.projectId.isNotEmpty && projectData.projectId != "null" ? projectData.projectId : ' '}"),
            projectRichText('Lead : ',
                " ${projectData.lead.isNotEmpty && projectData.lead != "null" ? projectData.lead : ' '}"),
            projectRichText('Estimated By : ',
                " ${projectData.estimatedBy.isNotEmpty && projectData.estimatedBy != "null" ? projectData.estimatedBy : ' '}"),
            projectRichText('Sold To : ',
                " ${projectData.soldTo.isNotEmpty && projectData.soldTo != "null" ? projectData.soldTo : ' '}"),
            projectRichText('Phase : ',
                " ${projectData.phase.isNotEmpty && projectData.phase != "null" ? projectData.phase : ' '}"),
            projectRichText('Probability : ',
                " ${projectData.probability.isNotEmpty && projectData.probability != "null" ? projectData.probability : ' '}"),
            projectRichText('Go Probability : ',
                " ${projectData.goProbability.isNotEmpty && projectData.goProbability != "null" ? projectData.goProbability : ' '}"),
            projectRichText('Created Date : ',
                " ${projectData.createdDate.isNotEmpty && projectData.createdDate != "null" ? projectData.createdDate : ' '}"),
            projectRichText('Project Value : ',
                " ${projectData.projectValue.isNotEmpty && projectData.projectValue != "null" ? projectData.projectValue : ' '}"),
            projectRichText('Equipment Value : ',
                " ${projectData.equipmentValue.isNotEmpty && projectData.equipmentValue != "null" ? projectData.equipmentValue : ' '}"),
            // projectRichText('Description : 000',
            //     " ${projectData.description != "null" ? projectData.description : ' '}"),
            RichText(
              text: TextSpan(children: [
                WidgetSpan(
                    child: Text(
                  "Description : ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: StringConst.FONT_FAMILY,
                  ),
                )),
                WidgetSpan(
                  child: projectData.description.isNotEmpty &&
                          projectData.description != "null"
                      ? MarkdownBody(
                          data: projectData.description,
                          shrinkWrap: true,
                          styleSheet: MarkdownStyleSheet(
                            a: TextstyleConst.projectInfoMarkText,
                            em: TextstyleConst.projectInfoMarkText,
                            strong: TextstyleConst.projectInfoMarkText,
                            del: TextstyleConst.projectInfoMarkText,
                            p: TextstyleConst.projectInfoMarkText,
                            blockquote: TextstyleConst.projectInfoMarkText,
                            checkbox: TextstyleConst.projectInfoMarkText,
                            code: TextstyleConst.projectInfoMarkText,
                            h1: TextstyleConst.projectInfoMarkText,
                            h2: TextstyleConst.projectInfoMarkText,
                            h3: TextstyleConst.projectInfoMarkText,
                            h4: TextstyleConst.projectInfoMarkText,
                            h5: TextstyleConst.projectInfoMarkText,
                            h6: TextstyleConst.projectInfoMarkText,
                            listBullet: TextstyleConst.projectInfoMarkText,
                            img: TextstyleConst.projectInfoMarkText,
                            tableHead: TextstyleConst.projectInfoMarkText,
                            tableBody: TextstyleConst.projectInfoMarkText,
                          ),
                        )
                      : SizedBox(),
                ),
              ]),
              textAlign: TextAlign.center,
            ),
            projectData.equipmentList != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Equipments List :",
                      style: TextstyleConst.projectInformationTitle,
                    ),
                  )
                : Container(),

            Divider(color: Colors.white, thickness: 1, height: 2),
            projectData.equipmentList != null
                ? Flexible(
                    child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              projectData.equipmentList.forEach((element) =>
                                  Totalprice +=
                                      double.parse(element.salePrice));
                              debugPrint("total price = $Totalprice");
                              return Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ListText(
                                      textName: projectData
                                          .equipmentList[index].manufacture,
                                    ),
                                    ListText(
                                      textName: projectData
                                          .equipmentList[index].product,
                                    ),
                                    ListText(
                                      textName:
                                          projectData.equipmentList[index].tag,
                                    ),
                                    ListText(
                                        textName: NumberFormat.simpleCurrency()
                                            .format(double.parse(projectData
                                                .equipmentList[index]
                                                .salePrice))),
                                  ],
                                ),
                                Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                    height: 2),
                              ]);
                            },
                            itemCount: projectData.equipmentList.length),
                      ),
                      Container(
                        height: 19.5,
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Total Sale Price : ",
                                      style: TextstyleConst
                                          .projectInformationSubtitle),
                                  Text(
                                    NumberFormat.simpleCurrency().format(
                                        double.parse(
                                            projectData.equipmentValue)),
                                    style: TextstyleConst
                                        .projectInformationSubtitle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
                : Container(),
            projectData.bidderList != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Bidders List :",
                      style: TextstyleConst.projectInformationTitle,
                    ),
                  )
                : Container(),

            projectData.bidderList != null
                ? Flexible(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          // List<Widget> equipmentList = [];
                          // var equipment = projectData.equipmentList[index];
                          // var width = MediaQuery.of(context).size.width / 4.8;
                          /*  Widget commonText(String textName) {
                        Container(
                            child: Text(
                              textName,
                            ),
                            width: width);
                      }

                      for (int i = 0;
                      i < projectData.equipmentList.length;
                      i++) {
                        equipmentList.add(
                          Container(
                              child: Text(
                                projectData
                                    .equipmentList[index].manufacture,
                              ),
                              width: width),
                        );
                      }*/
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListText(
                                    textName: projectData
                                        .bidderList[index].customerName,
                                  ),
                                  ListText(
                                    textName: projectData
                                        .bidderList[index].businessType,
                                  ),
                                  ListText(
                                    textName: projectData
                                        .bidderList[index].contactName,
                                  ),
                                ],
                              ),
                              Divider(
                                  color: Colors.white, thickness: 1, height: 2),
                            ],
                          );
                        },
                        itemCount: projectData.bidderList.length))
                : Container(),

            projectData.playerList != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Players List :",
                      style: TextstyleConst.projectInformationTitle,
                    ),
                  )
                : Container(),

            projectData.playerList != null
                ? Flexible(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          // List<Widget> equipmentList = [];
                          // var equipment = projectData.equipmentList[index];
                          // var width = MediaQuery.of(context).size.width / 4.8;
                          /*  Widget commonText(String textName) {
                        Container(
                            child: Text(
                              textName,
                            ),
                            width: width);
                      }

                      for (int i = 0;
                      i < projectData.equipmentList.length;
                      i++) {
                        equipmentList.add(
                          Container(
                              child: Text(
                                projectData
                                    .equipmentList[index].manufacture,
                              ),
                              width: width),
                        );
                      }*/
                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ListText(
                                      textName: projectData
                                          .playerList[index].customerName,
                                    ),
                                    ListText(
                                      textName: projectData
                                          .playerList[index].businessType,
                                    ),
                                    ListText(
                                      textName: projectData
                                          .playerList[index].contactName,
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                    height: 2),
                              ],
                            ),
                          );
                        },
                        itemCount: projectData.playerList.length))
                : Container(),

            projectData.noteList != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Notes List :",
                      style: TextstyleConst.projectInformationTitle,
                    ),
                  )
                : Container(),

            projectData.noteList != null
                ? Flexible(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListText(
                                      textName:
                                          projectData.noteList[index].tabLabel),
                                  ListText(
                                    textName: projectData
                                        .noteList[index].createdDateStr,
                                  ),
                                  ListText(
                                    textName: projectData
                                        .noteList[index].createdByName,
                                  ),
                                  ListText(
                                    textName:
                                        projectData.noteList[index].thread,
                                  ),
                                  /*  ListText(
                                    textName: projectData.noteList[index].notes,
                                  ),*/
                                ],
                              ),
                              Divider(
                                  color: Colors.white, thickness: 1, height: 2),
                            ],
                          );
                        },
                        itemCount: projectData.playerList.length))
                : Container(),
          ],
        ),
      ),
    );
  }

  RichText projectRichText(String textFirst, String textSecond) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: textFirst,
          style: TextstyleConst.projectInformationTitle,
        ),
        TextSpan(
          text: textSecond,
          //${projectData.projectName.isNotEmpty ? projectData.projectName : ""}
          style: TextstyleConst.projectInformationSubtitle,
        )
      ]),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class ListText extends StatelessWidget {
  ListText({Key key, this.textName}) : super(key: key);
  final String textName;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 4.8;

    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Text(
          textName,
          style: TextstyleConst.projectInformationSubtitle,
        ),
        width: width);
  }
}
