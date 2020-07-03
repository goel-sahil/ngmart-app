import 'package:flutter/material.dart';
import 'package:ngmartflutter/helper/styles.dart';

class CommingSoonScreen extends StatefulWidget {
  @override
  _CommingSoonScreenState createState() => _CommingSoonScreenState();
}

class _CommingSoonScreenState extends State<CommingSoonScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Coming Soon",
        style: h6,
      ),
    );
  }
}
