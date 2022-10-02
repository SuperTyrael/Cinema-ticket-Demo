import 'package:cinema_tickets/components/default_button.dart';
import 'package:cinema_tickets/components/form_error.dart';
import 'package:cinema_tickets/models/credit_card.dart';
import 'package:cinema_tickets/screens/payment/components/credit_card.dart';
import 'package:cinema_tickets/screens/sign_in/sing_in_success.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../constants.dart';
import '../../size_config.dart';

class AddCreditCardPage extends StatelessWidget {
  static String routeName = "/add_credit_card_page";

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: kGoldenColor,
      ),
      title: new Text(
        "Add new card",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
        overflow: TextOverflow.fade,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: AddCreditCardBody(),
    );
  }
}

class AddCreditCardBody extends StatefulWidget {
  @override
  AddCreditCardBodyState createState() => AddCreditCardBodyState();
}

class AddCreditCardBodyState extends State<AddCreditCardBody> {
  String cardExpiration = "";
  String cardHolder = "";
  String cardNumber = "";

  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error)) errors.remove(error);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final card = CreditCardBuilder(
        color: Color(0xFF090943),
        card: CreditCard(
          expDate: cardExpiration,
          holderName: cardHolder,
          number: cardNumber,
        ),
        isActive: false);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        card,
        SizedBox(
          height: size.height * 0.03,
        ),
        _cardNumberField(),
        SizedBox(height: getProportionateScreenHeight(20)),
        _cardHolderField(),
        SizedBox(height: getProportionateScreenHeight(20)),
        _cardExpirationField(),
        FormError(errors: errors),
        SizedBox(height: getProportionateScreenHeight(30)),
        DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);

                final card = CreditCard(
                  expDate: cardExpiration,
                  holderName: cardHolder,
                  number: cardNumber,
                );
                Hive.box<CreditCard>("cards").add(card);
                Navigator.pop(context);
              }
            }),
      ],
    );
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: body,
        ),
      ),
    );
  }

  TextFormField _cardNumberField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            removeError(error: kCardNumberError);
          }
          if (value.isNotEmpty && value.length == 16) {
            removeError(error: kCardNumberMatchError);
          }
          cardNumber = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCardNumberError);
          return "";
        } else if (value.length != 16) {
          addError(error: kCardNumberMatchError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Card Number",
        prefixIcon: Icon(Icons.credit_card),
      ),
    );
  }

  TextFormField _cardHolderField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            removeError(error: kCardHolderError);
          }
          if (value.contains(" ")) {
            removeError(error: kCardHolderMatchError);
          }
          cardHolder = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCardHolderError);
          return "";
        } else if (!value.contains(" ")) {
          addError(error: kCardHolderMatchError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Card Holder Name",
        prefixIcon: Icon(Icons.people),
      ),
    );
  }

  TextFormField _cardExpirationField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            removeError(error: kCardExpirationError);
          }
          cardExpiration = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCardExpirationError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Expiration of Card",
        labelStyle: TextStyle(),
        prefixIcon: Icon(Icons.update),
      ),
    );
  }
}
