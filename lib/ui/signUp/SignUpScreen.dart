import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/ValidatorFunctions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ngmartflutter/model/signUp/SignUpRequest.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:ngmartflutter/ui/otp/otp_verification.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileNumberController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _pinCodeController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  FocusNode _emailField = new FocusNode();
  FocusNode _firstNameField = new FocusNode();
  FocusNode _lastNameField = new FocusNode();
  FocusNode _mobileNumberField = new FocusNode();
  FocusNode _passwordField = new FocusNode();
  FocusNode _addressField = new FocusNode();
  FocusNode _pinCodeField = new FocusNode();
  FocusNode _cityEmailField = new FocusNode();
  FocusNode _stateField = new FocusNode();
  FocusNode _countryField = new FocusNode();
  LoginProvider provider;

  Future<void> _hitApi() async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        provider.hideLoader(); //hide loader
      },
      onSuccess: () {},
    );

    if (gotInternetConnection) {
      provider.setLoading();
      var mobileNumber = _mobileNumberController.text;
      var password = _passwordController.text;
      var address = AddressData(
          address: _addressController.text,
          city: _cityController.text,
          country: _countryController.text,
          pinCode: _pinCodeController.text,
          state: _stateController.text);
      var request = SignUpRequest(
          phoneNumber: mobileNumber,
          password: password,
          lastName: _lastNameController.text,
          firstName: _firstNameController.text,
          address: address,
          email: _emailController.text);

      var response = await provider.signUp(request, context);
      if (response is APIError) {
        showInSnackBar(response.error);
      } else {
        showInSnackBar("Sign Up successful.");
        Navigator.of(context).push(new CupertinoPageRoute(
            builder: (context) =>
                Otpverification(
                  phone: _mobileNumberController.text,
                  id: provider.userId,
                  otpType: OTPType.REGISTER,
                )));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKeys,
        appBar: AppBar(
          title: Text("Sign Up"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _fieldKey,
              child: Column(
                children: <Widget>[
                  getSpacer(height: 20),
                  getTextField(
                      context: context,
                      labelText: "First Name",
                      obsectextType: false,
                      textType: TextInputType.text,
                      focusNodeNext: _lastNameField,
                      focusNodeCurrent: _firstNameField,
                      enablefield: true,
                      controller: _firstNameController,
                      validators: (val) =>
                          emptyValidator(
                              txtMsg: "Please enter first name.", value: val)),
                  getSpacer(height: 20),
                  getTextField(
                      context: context,
                      labelText: "Last Name",
                      obsectextType: false,
                      textType: TextInputType.text,
                      focusNodeNext: _emailField,
                      focusNodeCurrent: _lastNameField,
                      enablefield: true,
                      controller: _lastNameController,
                      validators: (val) =>
                          emptyValidator(
                              txtMsg: "Please enter last name.", value: val)),
                  getSpacer(height: 20),
                  getTextField(
                      context: context,
                      labelText: "Email",
                      obsectextType: false,
                      textType: TextInputType.emailAddress,
                      focusNodeNext: _passwordField,
                      focusNodeCurrent: _emailField,
                      enablefield: true,
                      controller: _emailController,
                      validators: (val) => validatorEmail(val)),
                  getSpacer(height: 20),
                  getTextField(
                      context: context,
                      labelText: "Password",
                      obsectextType: true,
                      textType: TextInputType.text,
                      focusNodeNext: _mobileNumberField,
                      focusNodeCurrent: _passwordField,
                      enablefield: true,
                      controller: _passwordController,
                      validators: (val) =>
                          enteredPasswordValidator(enteredPassword: val)),
                  getSpacer(height: 20),
                  getTextField(
                    context: context,
                    labelText: "Mobile Number",
                    obsectextType: false,
                    textType: TextInputType.number,
                    focusNodeNext: _addressField,
                    focusNodeCurrent: _mobileNumberField,
                    enablefield: true,
                    controller: _mobileNumberController,
                    validators: (val) =>
                        emptyValidator(
                            value: val, txtMsg: "Please enter mobile number."),
                  ),
                  getSpacer(height: 20),
                  getTextField(
                    context: context,
                    labelText: "Address",
                    obsectextType: false,
                    textType: TextInputType.text,
                    focusNodeNext: _cityEmailField,
                    focusNodeCurrent: _addressField,
                    enablefield: true,
                    controller: _addressController,
                    validators: (val) =>
                        emptyValidator(
                            value: val, txtMsg: "Please enter address."),
                  ),
                  getSpacer(height: 20),
                  getTextField(
                    context: context,
                    labelText: "City",
                    obsectextType: false,
                    textType: TextInputType.text,
                    focusNodeNext: _stateField,
                    focusNodeCurrent: _cityEmailField,
                    enablefield: true,
                    controller: _cityController,
                    validators: (val) =>
                        emptyValidator(
                            value: val, txtMsg: "Please enter city."),
                  ),
                  getSpacer(height: 20),
                  getTextField(
                    context: context,
                    labelText: "State",
                    obsectextType: false,
                    textType: TextInputType.text,
                    focusNodeNext: _countryField,
                    focusNodeCurrent: _stateField,
                    enablefield: true,
                    controller: _stateController,
                    validators: (val) =>
                        emptyValidator(
                            value: val, txtMsg: "Please enter state."),
                  ),
                  getSpacer(height: 20),
                  getTextField(
                    context: context,
                    labelText: "Country",
                    obsectextType: false,
                    textType: TextInputType.text,
                    focusNodeNext: _pinCodeField,
                    focusNodeCurrent: _countryField,
                    enablefield: true,
                    controller: _countryController,
                    validators: (val) =>
                        emptyValidator(
                            value: val, txtMsg: "Please enter country."),
                  ),
                  getSpacer(height: 20),
                  getTextField(
                    context: context,
                    labelText: "Pin Code",
                    obsectextType: false,
                    textType: TextInputType.text,
                    focusNodeNext: _pinCodeField,
                    focusNodeCurrent: _pinCodeField,
                    enablefield: true,
                    controller: _pinCodeController,
                    validators: (val) =>
                        emptyValidator(
                            value: val, txtMsg: "Please enter pin code."),
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
                        "SIGN UP",
                        style: CustomTextStyle.textFormFieldRegular
                            .copyWith(color: Colors.white, fontSize: 14),
                      ),
                      color: AppColors.kPrimaryBlue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                  getSpacer(height: 20),
                ],
              ),
            ),
          ),
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

  String validatorEmail(String value) {
    if (value.isEmpty) {
      return emailValidator(email: value);
    }
    return null;
  }

  getLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    // From coordinates
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first
            .subAdminArea},${first.addressLine}, ${first.featureName},${first
            .thoroughfare}, ${first.countryName}');

    _addressController.text = first.addressLine.toString() ?? "";

    if (first.locality != null) {
      _cityController.text = first.locality;
    } else {
      _cityController.text = "Karnal";
    }

    if (first.adminArea != null) {
      _stateController.text = first.adminArea;
    } else {
      _stateController.text = "Haryana";
    }

    if (first.countryName != null) {
      _countryController.text = first.countryName;
    } else {
      _countryController.text = "India";
    }

    if (first.postalCode != null) {
      _pinCodeController.text = first.postalCode;
    } else {
      _pinCodeController.text = "";
    }
  }
}
