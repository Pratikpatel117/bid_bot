import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:flutter/material.dart';

import '../../const/color_const.dart';
import '../../const/widget.dart';

class SecurityKey extends StatefulWidget {
  const SecurityKey({Key key}) : super(key: key);

  @override
  _SecurityKeyState createState() => _SecurityKeyState();
}

class _SecurityKeyState extends State<SecurityKey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Security Key'),
        actions: [
          PopBackAction(),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
        child: Column(
          children: [
        /*    Row(children: [
        Padding(
        padding: const EdgeInsets.only(right: 11,bottom: 18),
        child: InkWell(
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xff252669),
            size: 32,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
            ]),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Help To Protect Your Account',
                  style: TextstyleConst.HeaderTitlePage,
                ),
              ],
            ),
            Image.asset(
              'asset/image/security.png',
              width: 100,
              height: 120,
            ),
            Text(
              'Security Key',
              style: TextStyle(
                  fontFamily: StringConst.FONT_FAMILY,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 23),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Use a physical security Key to help protect your Bid-Bot Account to unauthorised access',
              style: TextStyle(
                color: Colors.black,
                fontFamily: StringConst.FONT_FAMILY,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 36,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 120,
                    decoration: BoxDecoration(
                      color: Color(0xff252669),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Turn on',
                      style: TextStyle(color: Color(0xfff5f5f5)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
