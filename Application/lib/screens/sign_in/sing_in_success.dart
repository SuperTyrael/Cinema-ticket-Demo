import 'package:cinema_tickets/components/default_button.dart';
import 'package:cinema_tickets/screens/home/components/home_screen.dart';
import 'package:flutter/material.dart';
import '../../size_config.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4,
          fit: BoxFit.cover,
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Success",
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
            text: "Continue",
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
