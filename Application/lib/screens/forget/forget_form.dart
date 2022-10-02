import 'package:cinema_tickets/api/user.dart';
import 'package:cinema_tickets/components/custom_surfix_icon.dart';
import 'package:cinema_tickets/components/default_button.dart';
import 'package:cinema_tickets/components/form_error.dart';
import 'package:cinema_tickets/screens/forget/forget_pin.dart';
import 'package:cinema_tickets/screens/sign_up/pin.dart';
import 'package:cinema_tickets/screens/sign_up/sign_up_success.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ForgetForm extends StatefulWidget {
  @override
  _ForgetFormState createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  final _formKey = GlobalKey<FormState>();
  String? mobile;
  String? password;
  String? confirmPassword;

  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
          child: Column(
            children: [
              _phoneField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(40)),
              DefaultButton(
                text: "Continue",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPin()),
                    );
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
          )),
    );
  }

  TextFormField _confirmPassField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        suffixIcon: Icon(Icons.lock),
      ),
      autofillHints: [AutofillHints.newPassword],
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: Icon(Icons.lock),
      ),
      autofillHints: [AutofillHints.newPassword],
    );
  }

  TextFormField _phoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => mobile = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mobile Number",
        suffixIcon: Icon(Icons.phone_android),
      ),
      autofillHints: [AutofillHints.newUsername],
    );
  }
}