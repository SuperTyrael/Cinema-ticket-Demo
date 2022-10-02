import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:cinema_tickets/screens/ticket/components/remaind_ticket.dart';
import 'package:cinema_tickets/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListedTicketView extends StatelessWidget {
  final TicketBundle ticketBundle;
  const ListedTicketView({Key? key, required this.ticketBundle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool flag = false;
    DateTime now = new DateTime.now();
    if (ticketBundle.startAt.difference(now).inHours < 12 &&
        ticketBundle.startAt.difference(now).inHours > 0) {
      flag = true;
    }

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TicketsScreen(
                      ticketBundle: ticketBundle,
                    ))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: flag ? Color(0xFF0f4c81) : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                          height: 8,
                          width: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade400,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Text(
                        "${ticketBundle.movieName}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kGoldenColor),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${ticketBundle.time} Mins",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DateFormat('kk:mm').format(ticketBundle.startAt),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                height: 24,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                      children: List.generate(
                                          (constraints.constrainWidth() / 6)
                                              .floor(),
                                          (index) => SizedBox(
                                                height: 1,
                                                width: 3,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              )),
                                      direction: Axis.horizontal,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    );
                                  },
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.timelapse,
                                  color: Colors.indigo,
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('kk:mm').format(ticketBundle.startAt
                            .add(new Duration(minutes: ticketBundle.time))),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DateFormat('MMMMEEEEd').format(ticketBundle.startAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Movie Type : ",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "${ticketBundle.filmType}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.grey.shade200),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            children: List.generate(
                                (constraints.constrainWidth() / 10).floor(),
                                (index) => SizedBox(
                                      height: 1,
                                      width: 5,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade400),
                                      ),
                                    )),
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: Colors.grey.shade200),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24))),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.home, color: Colors.amber),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text("Room ${ticketBundle.room}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 120),
                    child: TextButton(
                      onPressed: () {
                        cancelTicket(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFFF4500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular((5)),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
                  // Expanded(child: Text("\u0024 ${ticketBundle.price}",textAlign: TextAlign.end,style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cancelTicket(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Cancel this ticket? All payments will be refunded within 2 days.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      removeTicket(ticketBundle);
      sendNotification("Cancel successful", "Your ticket has been cancelled.");
    }
  }
}
