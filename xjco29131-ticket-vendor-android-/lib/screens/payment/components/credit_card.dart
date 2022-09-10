import 'package:cinema_tickets/models/credit_card.dart';
import 'package:flutter/material.dart';

class CreditCardBuilder extends StatelessWidget {
  final Color color;
  final CreditCard card;
  final VoidCallback? onTap;
  final bool isActive;

  const CreditCardBuilder(
      {Key? key,
      required this.color,
      required this.card,
      required this.isActive,
      this.onTap})
      : super(key: key);

  void _handleTap() {
    if (onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
        elevation: isActive ? 10 : 4.0,
        color: color,
        shadowColor: isActive ? Colors.indigoAccent : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
              color: isActive ? Colors.indigoAccent : Colors.transparent,
              width: 4),
        ),
        child: Container(
          height: 200,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildLogosBlock(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  card.number,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontFamily: 'CourrierPrime'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildDetailsBlock(
                    label: 'CARDHOLDER',
                    value: card.holderName,
                  ),
                  _buildDetailsBlock(label: 'VALID THRU', value: card.expDate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the top row containing logos
  Row _buildLogosBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          "assets/images/contact_less.png",
          height: 20,
          width: 18,
        ),
        Image.asset(
          "assets/images/mastercard.png",
          height: 50,
          width: 50,
        ),
      ],
    );
  }

// Build Column containing the cardholder and expiration information
  Column _buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: TextStyle(
              color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        Text(
          '$value',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
