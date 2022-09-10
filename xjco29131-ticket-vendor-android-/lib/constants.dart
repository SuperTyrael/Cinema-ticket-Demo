import 'package:cinema_tickets/size_config.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF84AB5C);
const kTextColor = Color(0xFF202E2E);
const kTextLigntColor = Color(0xFF7286A5);
const kBackGroundColor = Color(0xff040302);
const kGoldenColor = Color(0xffFA6D17);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter Valid Email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please enter your name";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kAddressNullError = "Please enter your address";

const String kCardNumberError = "Please enter your card number";
const String kCardExpirationError = "Please enter your expiration date";
const String kCardCVVError= "Please enter your CVV";
const String kCardHolderError = "Please enter holder name";
const String kCardNumberMatchError = "Please enter correct card number";
const String kCardHolderMatchError = "Please enter correct holder name";
const String kCardCVVMatchError= "Please enter your CVV correctly";
