import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new SingleChildScrollView(
            child: Container(
              child: new Column(
                children: <Widget>[
                  getView("Review us", 1),
                  getView("Rate Our App", 2),
                  getView("Change Password", 3),
                  getView("Terms & Conditions", 4),
                  getView("FAQ", 5),
                  getView("About US", 6),
                  getView("Contact Us", 7),
                  getView("Share App", 7),
                  //getView("Support With New Ticket",7)
                ],
              ),
            ),
          ),
          Center(
            child: getHalfScreenProviderLoader(
              status: /*provider.getLoading()*/ false,
              context: context,
            ),
          )
        ],
      ),
    );
  }

  void gotowebview(String description, String title) {
//    Navigator.push(
//      context,
//      CupertinoPageRoute(
//          builder: (context) => new Webview(
//                url: description,
//                title: title,
//              )),
//    );
  }

  Widget getView(String title, int pos) {
    return InkWell(
      onTap: () {
        print(pos);
        switch (pos) {
          case 7:
            {
              Share.share('check out my website https://example.com');
            }
            break;
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
        child: Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  title,
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                new Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: Colors.black87,
                )
              ],
            ),
            new Container(
              height: 1.0,
              color: Colors.black,
              margin: new EdgeInsets.only(top: 20.0),
            )
          ],
        ),
      ),
    );
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
