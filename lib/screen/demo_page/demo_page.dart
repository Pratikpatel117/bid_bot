import 'package:bidbot/const/asset_const.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/model/login_and_signUp/signup_model.dart';
import 'package:bidbot/screen/bidding_page/bidding_page.dart';
import 'package:bidbot/utils/routes.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key key}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  LoginSignUpValue loginSignUpValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: noLoginAppBar(context),
      body: BiddingPage(
        isLogin: false,
      ),
    );
  }

  Widget noLoginAppBar(BuildContext context) {
    return AppBar(
      shadowColor: Colors.white,
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 55,
              child: Image.asset(
                "asset/image/tristate1.png",
                height: 25,
                fit: BoxFit.cover,
                width: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 13),
              child: SizedBox(
                height: 42,
                width: 3,
                child: Container(
                  color: Color(0xff252669),
                ),
              ),
            ),
            Container(
              child: Image.asset(
                BID_BOT_LOGO,
                height: 80,
                width: 80,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
          child: Container(
            height: 2,
            color: Color(0xff9192B3),
          ),
          preferredSize: Size.fromHeight(4.0)),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20, bottom: 16, top: 16),
          alignment: Alignment.center,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: ColorConst.LoginButtonColor,
          ),
          width: 95,
          child: InkWell(
              onTap: () async {
                Navigator.pushNamed(context, loginPage, arguments: {
                  "cust": loginSignUpValue,
                });
              },
              child: Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
        ),
      ],
    );
  }
}
