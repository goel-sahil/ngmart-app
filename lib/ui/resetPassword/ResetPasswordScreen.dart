import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/ValidatorFunctions.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/resetPassword/ResetPasswordRequest.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  var id;
  var code;

  ResetPasswordScreen({Key key, this.id, this.code}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  FocusNode _passwordField = new FocusNode();
  FocusNode _newPasswordField = new FocusNode();
  LoginProvider provider;

  Future<void> _hitApi() async {
    provider.setLoading();
    var password = _passwordController.text;
    var request = ResetPasswordRequest(
        password: password, code: widget.code, userId: widget.id);

    var response = await provider.resetPassword(request, context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      CommonResponse forgotPasswordResponse = response;
      showInSnackBar(forgotPasswordResponse.message);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKeys,
        appBar: AppBar(
          title: Text("Reset Password"),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _fieldKey,
                child: Column(
                  children: <Widget>[
                    getSpacer(height: 80),
                    getTextField(
                      context: context,
                      labelText: "New Password",
                      obsectextType: true,
                      textType: TextInputType.number,
                      focusNodeNext: _newPasswordField,
                      focusNodeCurrent: _passwordField,
                      enablefield: true,
                      controller: _passwordController,
                      validators: (val) =>
                          newPasswordValidator(newPassword: val),
                    ),
                    getSpacer(height: 20),
                    getTextField(
                      context: context,
                      labelText: "Confirm Password",
                      obsectextType: true,
                      textType: TextInputType.number,
                      focusNodeNext: _newPasswordField,
                      focusNodeCurrent: _newPasswordField,
                      enablefield: true,
                      controller: _newPasswordController,
                      validators: (val) => confirmPassword(
                          newPassword: val, password: _passwordController.text),
                    ),
                    getSpacer(height: 20),
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
}
