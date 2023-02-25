import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../api/login_and_signUp/term_and_condition_api.dart';
import '../../const/color_const.dart';
import '../../const/widget.dart';
import '../../model/login_and_signUp/term_and_condition_model.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key key}) : super(key: key);

  @override
  State<TermAndCondition> createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition> {
  List<TermAndConditionData> listOfTermAndCondition = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTermAndConditionData();
  }

  Future getTermAndConditionData() async {
    setState(() {
      isLoading = true;
    });
    TermAndConditionAPi termAndConditionAPi = TermAndConditionAPi();
    await termAndConditionAPi.getTermAndConditionApi().then((value) {
      var status = value.status;
      if (status == true) {
        listOfTermAndCondition = value.data;
      }
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
        title: Text('Term And Condition'),
        actions: [
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: listOfTermAndCondition.length,
                      itemBuilder: (context, i) {
                        return Container(
                          child: Html(data: listOfTermAndCondition[i].content,)
                        );
                      }),
                )
              ],
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }
}
