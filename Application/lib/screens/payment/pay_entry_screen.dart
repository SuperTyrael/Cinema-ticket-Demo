import 'package:cinema_tickets/models/movie.dart';
import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:cinema_tickets/screens/payment/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

import 'package:cinema_tickets/components/rounded_bordered_container.dart';
import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/screens/payment/credit_cards_page.dart';

class PayEntryScreen extends HookWidget {
  final int unitPrice;
  final Movie movie;
  final List<Map<String, dynamic>> seats;
  final List<Map<String, dynamic>> normalSeats;

  PayEntryScreen(
      {Key? key,
      required this.unitPrice,
      required this.seats,
      required this.movie})
      : normalSeats = seats.where((seat) => !seat['vip']).toList(),
        super(key: key);

  static String routeName = "/pay_entry_screen.dart";

  @override
  Widget build(BuildContext context) {
    final startTime = useMemoized(() => DateTime.now());
    final normatSeatsType =
        useState(List.filled(normalSeats.length, 0, growable: false));

    final typeSelection = normalSeats.asMap().entries.map((entry) {
      final index = entry.key;
      final seat = entry.value;

      return Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Text(
            "${seat['x']}-${seat['y']}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Spacer(),
          DropdownButton<int>(
            value: normatSeatsType.value[index],
            items: [
              DropdownMenuItem<int>(value: 0, child: Text("Adult")),
              DropdownMenuItem<int>(value: 1, child: Text("Child")),
              DropdownMenuItem<int>(value: 2, child: Text("Elder")),
            ],
            onChanged: (value) {
              normatSeatsType.value[index] = value ?? 0;
              normatSeatsType.notifyListeners();
            },
          ),
          SizedBox(
            width: 16,
          ),
        ],
      );
    }).toList();

    var price = (seats.length - normalSeats.length) * unitPrice * 2; // VIP

    for (var i = 0; i < normalSeats.length; i++) {
      if (normatSeatsType.value[i] == 0) {
        price += unitPrice;
      } else {
        price += (unitPrice * 0.8).round();
      }
    }

    final body = Column(
      children: <Widget>[
        CountdownIndicator(startTime: startTime),
        const SizedBox(height: 16.0),
        Text(
          "Choose payment method",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          "\$$price.00",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        const SizedBox(height: 16.0),
        ...typeSelection,
        const SizedBox(height: 16.0),
        RoundedContainer(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
          child: ListTile(
            onTap: () async {
              var localAuth = LocalAuthentication();
              if (await localAuth.authenticate(
                  localizedReason: 'Please authenticate to use credit cards')) {
                final ticket = TicketBundle(
                    price: price,
                    room: 1,
                    time: movie.timeLong,
                    movieName: movie.title,
                    imageSrc: movie.poster,
                    seat: seats.map((s) => "${s['x']}-${s['y']}").toList(),
                    filmType: "2D",
                    userName: "LIam",
                    ticketType: "Online",
                    startAt: DateTime.parse('2021-04-30 18:30:00'),
                    uuid: "12345678909876");
                addTicket(ticket);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreditCardsPage(
                              price: price,
                              startTime: startTime,
                            )));
              }
            },
            leading: Icon(
              FontAwesomeIcons.ccVisa,
              color: Colors.indigoAccent,
            ),
            title: Text("Credit Card"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        RoundedContainer(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.alipay,
              color: Colors.indigo,
            ),
            title: Text("Alipay"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        RoundedContainer(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.ccApplePay,
              color: Colors.black,
            ),
            title: Text("Apple Pay"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: kGoldenColor,
        ),
      ),
      body: SingleChildScrollView(
        child: body,
      ),
    );
  }
}
