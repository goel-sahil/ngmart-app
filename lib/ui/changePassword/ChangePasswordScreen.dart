import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/ValidatorFunctions.dart';
import 'package:ngmartflutter/model/ChangePasswordRequest.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  FocusNode _passwordField = new FocusNode();
  FocusNode _newPasswordField = new FocusNode();
  FocusNode _confirmPassword = new FocusNode();
  LoginProvider provider;

  Future<void> _hitApi() async {
    provider.setLoading();
    var request = ChangePasswordRequest(
        oldPassword: _passwordController.text,
        password: _newPasswordController.text);

    var response = await provider.changePassword(request, context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      CommonResponse forgotPasswordResponse = response;
      showInSnackBar(forgotPasswordResponse.message);
      Timer(Duration(milliseconds: 500), () {
        Navigator.of(context).pop();
      });
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKeys,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Change Password"),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
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
                    getTextField(
                      context: context,
                      labelText: "Old Password",
                      obsectextType: true,
                      textType: TextInputType.text,
                      focusNodeNext: _newPasswordField,
                      focusNodeCurrent: _passwordField,
                      enablefield: true,
                      controller: _passwordController,
                      validators: (val) =>
                          oldPasswordValidator(newPassword: val),
                    ),
                    getSpacer(height: 20),
                    getTextField(
                      context: context,
                      labelText: "New Password",
                      obsectextType: true,
                      textType: TextInputType.text,
                      focusNodeNext: _confirmPassword,
                      focusNodeCurrent: _newPasswordField,
                      enablefield: true,
                      controller: _newPasswordController,
                      validators: (val) =>
                          newPasswordValidator(newPassword: val),
                    ),
                    getSpacer(height: 20),
                    getTextField(
                      context: context,
                      labelText: "Confirm Password",
                      obsectextType: true,
                      textType: TextInputType.text,
                      focusNodeNext: _confirmPassword,
                      focusNodeCurrent: _confirmPassword,
                      enablefield: true,
                      controller: _confirmPasswordController,
                      validators: (val) => confirmPassword(
                          newPassword: val,
                          password: _newPasswordController.text),
                    ),
                    Container(
                      width: getScreenSize(context: context).width,
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Validates "new password" field
  String oldPasswordValidator({@required String newPassword}) {
    if (newPassword.isEmpty) {
      return 'Please enter old password.';
    }
    return null;
  }

  String newPasswordValidator({@required String newPassword}) {
    if (newPassword.isEmpty) {
      return 'Please enter new password.';
    }
    return null;
  }
}
