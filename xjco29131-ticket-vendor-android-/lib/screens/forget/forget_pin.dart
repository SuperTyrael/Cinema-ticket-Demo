import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/screens/forget/forget_success.dart';
import 'package:cinema_tickets/screens/sign_up/sign_up_success.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class ForgetPin extends StatefulWidget {
  @override
  _ForgetPinState createState() => _ForgetPinState();
}

class _ForgetPinState extends State<ForgetPin> {
  final TextEditingController _pinPutController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: kGoldenColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinPut = PinPut(
      autofocus: true,
      fieldsCount: 4,
      onSubmit: (String pin) async {
        // if all are valid then go to success screen
        await Navigator.pushNamed(context, ForgetSuccess.routeName);
        Navigator.pop(context);
      },
      controller: _pinPutController,
      submittedFieldDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(20.0),
      ),
      selectedFieldDecoration: _pinPutDecoration,
      followingFieldDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: kGoldenColor.withOpacity(.5),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Mobile Verification", style: headingStyle),
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  child: pinPut,
                ),
              ],
            ),
          ));
        }));
  }

  @override
  void dispose() {
    _pinPutController.dispose();
    super.dispose();
  }
}
