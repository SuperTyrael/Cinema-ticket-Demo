import 'package:cinema_tickets/screens/forget/forget_form.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ForgetPassword extends StatelessWidget {
  static String routeName = "/forget_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Verification", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  'Please input your registrated phone number, \nwe will send a message with PINs to you',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                ForgetForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  'By continuing your confirm that you agree \nwith our Term and Condition',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}