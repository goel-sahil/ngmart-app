import 'package:meta/meta.dart';

// Validates email format
bool isEmailFormatValid(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(email);
}

// Validates email field
String emailValidator({
  @required String email,
}) {
  if (email
      .trim()
      .isEmpty) {
    return 'Please enter an email address.';
  } else if (!isEmailFormatValid(email.trim())) {
    return 'Please enter a valid email address.';
  }
  return null;
}

// Validates phone number field
String phoneNumberValidator({@required String phoneNumber}) {
  if (phoneNumber
      .trim()
      .isEmpty) {
    return 'Please enter a phone number.';
  }
  if (phoneNumber.length < 7) {
    return 'Please enter minimum 7 digit.';
  }
  return null;
}

// Validates status field
String statusValidator({@required String status}) {
  if (status
      .trim()
      .isEmpty) {
    return 'Please select stauts.';
  }
  return null;
}

// Validates status field
String activityValidator({@required String activity}) {
  if (activity
      .trim()
      .isEmpty) {
    return 'Please select activity.';
  }
  return null;
}

// Validates message field
String messageValidator({@required String message}) {
  if (message
      .trim()
      .isEmpty) {
    return 'Please enter message.';
  }
  return null;
}

// Validates activityDescription field
String activityDescriptionValidator({@required String message}) {
  if (message
      .trim()
      .isEmpty) {
    return 'Please describe the activity.';
  }
  return null;
}

// Validates attachAFile field
String attachAFileValidator({@required String file}) {
  if (file
      .trim()
      .isEmpty) {
    return 'Please attach a file.';
  }
  return null;
}

// Validated "entered password" field
String enteredPasswordValidator({@required String enteredPassword}) {
  if (enteredPassword.isEmpty) {
    return 'Please enter password.';
  }
  return null;
}

// Validates password format
bool isPasswordLengthValid(String password) {
  if (password.length >= 8) {
    return true;
  }
  return false;
}

// Validates password complexity
bool isPasswordComplexEnough(String password) {
  String p =
      r"^(?=(.*[0-9]))(?=.*[\!@#$%^&*()\\[\]{}\-_+=~`|:;'\<>,./?])(?=.*[a-z])(?=(.*[A-Z]))";
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(password);
}

// Validates "new password" field
String newPasswordValidator({@required String newPassword}) {
  if (newPassword.isEmpty) {
    return 'Please enter new password.';
  } else if (!isPasswordLengthValid(newPassword)) {
    return 'Please use at least 8 characters for password.';
  }
  return null;
}




String confirmPassword(
    {@required String newPassword, @required String password }) {
  if (newPassword.isEmpty) {
    return 'Please enter confirm password.';
  } else if (newPassword!=password) {
    return 'Confirm password and password should match.';
  }
  return null;
}

// Validates "current password" field
String currentPasswordValidator({@required String currentPassword}) {
  if (currentPassword.isEmpty) {
    return 'Please enter current password.';
  }
//  else if (!isPasswordLengthValid(currentPassword)) {
//    return ' Please use at least 8 characters for password.';
//  }
  return null;
}

// Validates name format
bool isNameFormatValid(String name) {
  String p = r"^[a-zA-Z ]*$";
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(name);
}

// Validates name length
bool isNameLengthValid(String name) {
  if (name
      .trim()
      .length >= 0) {
    return true;
  }
  return false;
}

// Validates first name
String firstNameValidator({@required String firstName}) {
  if (firstName
      .trim()
      .isEmpty) {
    return 'Please enter first name.';
  } else if (!isNameLengthValid(firstName.trim())) {
    return 'Please use at least 3 characters for first name.';
  } else if (!isNameFormatValid(firstName.trim())) {
    return 'No special characters allowed.';
  }
  return null;
}

// Validates middle name
String middleNameValidator({@required String middleName}) {
  if (middleName
      .trim()
      .isEmpty) {
    return 'Please enter middle name.';
  } else if (!isNameLengthValid(middleName.trim())) {
    return 'Please use at least 3 characters for middle name.';
  } else if (!isNameFormatValid(middleName.trim())) {
    return 'No special characters allowed.';
  }
  return null;
}

// Validates name
String nameValidator({@required String name}) {
  if (name
      .trim()
      .isEmpty) {
    return 'Please enter name.';
  } else if (!isNameLengthValid(name.trim())) {
    return 'Please use at least 3 characters for first name.';
  } else if (!isNameFormatValid(name.trim())) {
    return 'No special characters allowed.';
  }
  return null;
}

// Validates last name
String lastNameValidator({@required String lastName}) {
  if (lastName
      .trim()
      .isEmpty) {
    return 'Please enter last name.';
  } else if (!isNameLengthValid(lastName.trim())) {
    return 'Please use at least 3 characters for last name.';
  } else if (!isNameFormatValid(lastName.trim())) {
    return 'No spaces or special characters allowed.';
  }
  return null;
}

// Validates age
String ageValidator({@required String age}) {
  if (age
      .trim()
      .isEmpty) {
    return 'Please enter age.';
  }
  return null;
}
