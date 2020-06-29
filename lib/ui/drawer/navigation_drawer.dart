import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/ui/search/SearchPage.dart';

import 'SubCategoryScreen.dart';
import 'drawer_item.dart';
import 'HomeScreen.dart';

class NavigationDrawer extends StatefulWidget {
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int _selectionIndex = 0;
  final drawerItems = [
    DrawerItem("Shop Now", FontAwesomeIcons.shoppingCart),
    DrawerItem("My Profile", FontAwesomeIcons.userCircle),
    DrawerItem("Buy with Parchi", FontAwesomeIcons.buysellads),
    DrawerItem("About us", FontAwesomeIcons.userAlt),
    DrawerItem("Terms & policy", FontAwesomeIcons.terminal),
    DrawerItem("Contact us", FontAwesomeIcons.searchLocation),
    DrawerItem("Review us", FontAwesomeIcons.snapchat),
    DrawerItem("Share with friends", FontAwesomeIcons.shareAlt),
  ];

  _getDrawerItemScreen(int pos) {
    switch (pos) {
//      case 1:
//        return SecondScreen();
//      case 2:
//        return Tabs();
      default:
        return NavigationDrawer();
    }
  }

  _onSelectItem(int index) {
    setState(() {
      _selectionIndex = index;
      _getDrawerItemScreen(_selectionIndex);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _getDrawerItemScreen(_selectionIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(
          d.title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        selected: i == _selectionIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("NGMart"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SearchPage()));
                }),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Sahil Goel'),
              accountEmail: Text('sahil@gmail.com'),
            ),
            Column(
              children: drawerOptions,
            ),
          ],
        ),
      ),
      body: HomeScreen(),
    );
  }
}
