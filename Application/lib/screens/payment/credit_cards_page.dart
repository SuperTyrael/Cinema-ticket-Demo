import 'package:cinema_tickets/models/credit_card.dart';
import 'package:cinema_tickets/screens/new/mains.dart';
import 'package:cinema_tickets/screens/payment/countdown.dart';
import 'package:cinema_tickets/screens/sign_in/sing_in_success.dart';
import 'package:cinema_tickets/utils/notification.dart';
import 'package:flutter/material.dart';

import 'package:cinema_tickets/screens/payment/add_credit_card.dart';
import 'package:cinema_tickets/screens/payment/components/credit_card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants.dart';

class CreditCardsPage extends StatelessWidget {
  final int price;
  final DateTime startTime;

  const CreditCardsPage({
    Key? key,
    required this.price,
    required this.startTime,
  }) : super(key: key);

  static String routeName = "/credit_card_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: kGoldenColor,
        ),
        title: new Text(
          "My Credit Card",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ), //Color(0xFF0C138E)
          textAlign: TextAlign.left,
          overflow: TextOverflow.fade,
        ),
      ),
      body: CreditCardsPageBody(price: price, startTime: startTime),
    );
  }
}

class CreditCardsPageBody extends StatefulWidget {
  final int price;
  final DateTime startTime;

  const CreditCardsPageBody({
    Key? key,
    required this.price,
    required this.startTime,
  }) : super(key: key);
  @override
  CreditCardsPageBodyState createState() => CreditCardsPageBodyState();
}

class CreditCardsPageBodyState extends State<CreditCardsPageBody> {
  List<Color> cardColors = [Color(0xFF090943), Color(0xFF000000), Colors.red];

  int? _active;

  @override
  Widget build(BuildContext context) {
    final grid = ValueListenableBuilder<Box<CreditCard>>(
        valueListenable: Hive.box<CreditCard>("cards").listenable(),
        builder: (context, box, child) {
          final cards = box.values.toList();

          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CreditCardBuilder(
                  color: cardColors[index % 3],
                  card: cards[index],
                  isActive: _active == index,
                  onTap: () {
                    setState(() {
                      _active = index;
                    });
                  },
                );
              },
              childCount: cards.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisSpacing: 1, childAspectRatio: 1.8),
          );
        });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            CountdownIndicator(startTime: widget.startTime),
            const SizedBox(height: 16.0),
            Container(
              constraints: BoxConstraints(maxHeight: 430),
              child: CustomScrollView(
                slivers: <Widget>[grid],
              ),
            ),
            Container(
              child: buildAddCardButton(context),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 40.0,
              ),
              child: RaisedButton(
                elevation: 0,
                padding: const EdgeInsets.all(24.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  "Pay \$${widget.price}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 10),
                ),
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: _active == null
                    ? null
                    : () async {
                        await sendNotification(
                            "movieU", "Your movie will start in one hour.");
                        await Navigator.pushNamed(
                            context, LoginSuccessScreen.routeName);
                        Navigator.pushNamedAndRemoveUntil(context,
                            TestHomeScreen.routeName, (route) => false);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

// Build the FloatingActionButton
  Container buildAddCardButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      alignment: Alignment.center,
      child: FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                    //
                    // animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation) {
                    return AddCreditCardPage();
                  }));
        },
        // Navigator.pushNamed(context, AddCreditCardPage.routeName),
        backgroundColor: Color(0xFF081603),
        mini: false,
        child: Icon(Icons.add),
      ),
    );
  }
}
