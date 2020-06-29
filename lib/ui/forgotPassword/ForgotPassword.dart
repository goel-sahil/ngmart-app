import 'package:flutter/material.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _mobileNumberController = new TextEditingController();
  FocusNode _mobileNumberField = new FocusNode();
  LoginProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            getSpacer(height: 40),
            getTextField(
              context: context,
              labelText: "Mobile Number",
              obsectextType: false,
              textType: TextInputType.number,
              focusNodeNext: _mobileNumberField,
              focusNodeCurrent: _mobileNumberField,
              enablefield: true,
              controller: _mobileNumberController,
              validators: (val) => emptyValidator(
                  value: val, txtMsg: "Please enter mobile number."),
            ),
            getSpacer(height: 20),
            Container(
              width: getScreenSize(context: context).width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                onPressed: () {
//                  if (_fieldKey.currentState.validate()) {
//                    _hitApi();
//                  }
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
    );
  }

  String emptyValidator({String value, String txtMsg}) {
    if (value.isEmpty) {
      return txtMsg;
    }
    return null;
  }
}
