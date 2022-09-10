import 'package:cinema_tickets/components/default_button.dart';
import 'package:cinema_tickets/screens/home/components/home_screen.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class ForgetSuccess extends StatelessWidget {
  static String routeName = "/forget_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Password changed!"),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Password changed!",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Sign in",
            press: () {
              Navigator.pop(context);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}