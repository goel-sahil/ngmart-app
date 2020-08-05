import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomBorder.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/Login/LoginRequest.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/model/contactUs/ContactUsRequest.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:ngmartflutter/ui/drawer/navigation_drawer.dart';
import 'package:ngmartflutter/ui/forgotPassword/ForgotPassword.dart';
import 'package:ngmartflutter/ui/signUp/SignUpScreen.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController _subjectController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  FocusNode _subjectField = new FocusNode();
  FocusNode _descriptionField = new FocusNode();
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  LoginResponse userInfo;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _hitApi() async {
    provider.setLoading();
    var request = ContactUsRequest(
        title: _subjectController.text,
        description: _descriptionController.text,);

    var response = await provider.contactUs(request, context);
    if (response is APIError) {
      if (response.status == 401) {
        showAlert(
          context: context,
          titleText: "Error",
          message: response.error,
          actionCallbacks: {
            "OK": () {
              onLogoutSuccess(context: context);
            }
          },
        );
      } else {
        showInSnackBar(response.error);
      }
    } else if (response is CommonResponse) {
      showInSnackBar(response.message);
      _descriptionController.clear();
      _subjectController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      key: _scaffoldKeys,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
              child: Form(
            key: _fieldKey,
            child: Column(
              children: <Widget>[
                getSpacer(height: 40),
                Image(
                    image: AssetImage("images/app_logo.jpeg"),
                    height: 100,
                    alignment: Alignment.center,
                    width: 180),
                getSpacer(height: 40),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                            border: CustomBorder.enabledBorder,
                            labelText: "Subject",
                            focusedBorder: CustomBorder.focusBorder,
                            errorBorder: CustomBorder.errorBorder,
                            enabledBorder: CustomBorder.enabledBorder,
                            labelStyle: CustomTextStyle.textFormFieldMedium
                                .copyWith(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16,
                                    color: Colors.black)),
                        controller: _subjectController,
                        focusNode: _subjectField,
                        onFieldSubmitted: (value) {
                          _subjectField.unfocus();
                          FocusScope.of(context).autofocus(_descriptionField);
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter subject."),
                      ),
                      getSpacer(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                            border: CustomBorder.enabledBorder,
                            labelText: "Description",
                            focusedBorder: CustomBorder.focusBorder,
                            errorBorder: CustomBorder.errorBorder,
                            enabledBorder: CustomBorder.enabledBorder,
                            labelStyle: CustomTextStyle.textFormFieldMedium
                                .copyWith(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16,
                                    color: Colors.black)),
                        controller: _descriptionController,
                        focusNode: _descriptionField,
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        validator: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter description."),
                      ),
                      getSpacer(height: 20),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            if (_fieldKey.currentState.validate()) {
                              _hitApi();
                            }
                          },
                          child: Text(
                            "SUBMIT",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          color: AppColors.kPrimaryBlue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                        ),
                      ),
                      getSpacer(height: 14),
                    ],
                  ),
                )
              ],
            ),
          )),
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  String emptyValidator({String value, String txtMsg}) {
    if (value.isEmpty) {
      return txtMsg;
    }
    return null;
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
