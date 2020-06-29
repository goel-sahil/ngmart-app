import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomBorder.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/Login/LoginRequest.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:ngmartflutter/ui/signUp/SignUpScreen.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _mobileNumberController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  FocusNode _mobileField = new FocusNode();
  FocusNode _passwordField = new FocusNode();
  LoginProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();

  Future<void> _hitApi() async {
    provider.setLoading();
    var mobileNumber = _mobileNumberController.text;
    var password = _passwordController.text;
    var request = LoginRequest(phoneNumber: mobileNumber, password: password);

    var response = await provider.login(request, context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
//      MemoryManagement.setUserLoggedIn(isUserLoggedin: true);
//      Navigator.of(context).pushAndRemoveUntil(
//          MaterialPageRoute(builder: (context) =>
//              NavigationDrawer()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      key: _scaffoldKeys,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Builder(builder: (context) {
            return Form(
              key: _fieldKey,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Image(
                          image: AssetImage("images/app_logo.jpeg"),
                          height: 100,
                          alignment: Alignment.center,
                          width: 180),
                      flex: 40,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                                  border: CustomBorder.enabledBorder,
                                  labelText: "Mobile No.",
                                  focusedBorder: CustomBorder.focusBorder,
                                  errorBorder: CustomBorder.errorBorder,
                                  enabledBorder: CustomBorder.enabledBorder,
                                  labelStyle: CustomTextStyle.textFormFieldMedium
                                      .copyWith(
                                      fontSize: MediaQuery.of(context)
                                          .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                              controller: _mobileNumberController,
                              focusNode: _mobileField,
                              onFieldSubmitted: (value) {
                                _mobileField.unfocus();
                                FocusScope.of(context).autofocus(_passwordField);
                              },
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: (val) => emptyValidator(
                                  value: val,
                                  txtMsg: "Please enter mobile number."),
                            ),
                            getSpacer(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                                  border: CustomBorder.enabledBorder,
                                  labelText: "Password",
                                  focusedBorder: CustomBorder.focusBorder,
                                  errorBorder: CustomBorder.errorBorder,
                                  enabledBorder: CustomBorder.enabledBorder,
                                  labelStyle: CustomTextStyle.textFormFieldMedium
                                      .copyWith(
                                      fontSize: MediaQuery.of(context)
                                          .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                              obscureText: true,
                              controller: _passwordController,
                              focusNode: _passwordField,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validator: (val) => emptyValidator(
                                  value: val, txtMsg: "Please enter password."),
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
                                  "LOGIN",
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
                            getSpacer(height: 10),
                            Container(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Text(
                                  "Forget Password?",
                                  style: CustomTextStyle.textFormFieldBold.copyWith(
                                      color: AppColors.kPrimaryBlue, fontSize: 14),
                                ),
                              ),
                            ),
                            getSpacer(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    margin: EdgeInsets.only(right: 16),
                                    height: 1,
                                  ),
                                  flex: 40,
                                ),
                                Text(
                                  "Or",
                                  style: CustomTextStyle.textFormFieldMedium
                                      .copyWith(fontSize: 14),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    margin: EdgeInsets.only(left: 16),
                                    height: 1,
                                  ),
                                  flex: 40,
                                )
                              ],
                            ),
                            getSpacer(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account?",
                                  style: CustomTextStyle.textFormFieldMedium
                                      .copyWith(fontSize: 14),
                                ),
                                getSpacer(width: 4),
                                GestureDetector(
                                  child: Text(
                                    "Sign Up",
                                    style: CustomTextStyle.textFormFieldBold
                                        .copyWith(
                                        fontSize: 14,
                                        color: AppColors.kPrimaryBlue),
                                  ),
                                  onTap: () {
                              Navigator.of(context).push(new CupertinoPageRoute(
                                  builder: (context) => SignUpScreen()));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      flex: 60,
                    )
                  ],
                ),
              ),
            );
          }),
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
