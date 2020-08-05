import 'package:flutter/material.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/admin/ContactUs/ContactResponse.dart';

class ContactDetail extends StatefulWidget {
  Data contactData;

  ContactDetail({this.contactData});

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Contact Details"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Title:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    getSpacer(width: 10),
                    Text(
                      widget.contactData.title,
                      style: TextStyle(color: AppColors.kGrey, fontSize: 16),
                    ),
                  ],
                ),
                getSpacer(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      "Description:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    getSpacer(width: 10),
                    Text(
                      widget.contactData.description,
                      style: TextStyle(color: AppColors.kGrey, fontSize: 16),
                    ),
                  ],
                ),
                getSpacer(height: 10),
                Divider(
                  color: AppColors.kBlackGrey,
                ),
                getSpacer(height: 10),
                widget.contactData.user != null
                    ? Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Name:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              getSpacer(width: 10),
                              Text(
                                "${widget.contactData.user.firstName} ${widget.contactData.user.lastName}",
                                style: TextStyle(
                                    color: AppColors.kGrey, fontSize: 16),
                              ),
                            ],
                          ),
                          getSpacer(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                "Email:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              getSpacer(width: 10),
                              Text(
                                "${widget.contactData.user.email}",
                                style: TextStyle(
                                    color: AppColors.kGrey, fontSize: 16),
                              ),
                            ],
                          ),
                          getSpacer(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                "Phone number:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              getSpacer(width: 10),
                              Text(
                                "${widget.contactData.user.phoneNumber}",
                                style: TextStyle(
                                    color: AppColors.kGrey, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
