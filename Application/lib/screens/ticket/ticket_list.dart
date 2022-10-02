import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:cinema_tickets/screens/ticket/components/listed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TicketListScreen extends HookWidget {
  static String routeName = "/ticket_list_screen";

  @override
  Widget build(BuildContext context) {
    final tickets =
        useStream<List<TicketBundle>>(ticketsSubject.stream, initialData: [])
                .data ??
            [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          "My Tickets",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: ListView.builder(
            itemCount: tickets.length,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            itemBuilder: (context, index) {
              return ListedTicketView(
                ticketBundle: tickets[index],
              );
            }),
      ),
    );
  }
}
