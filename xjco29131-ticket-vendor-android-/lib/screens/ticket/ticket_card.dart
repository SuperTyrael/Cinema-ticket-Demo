import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:cinema_tickets/screens/ticket/components/remaind_ticket.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final TicketBundle ticketBundle;
  const TicketCard({Key? key, required this.ticketBundle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0f4c81),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.65,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  ticketBundle.imageSrc,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      ticketBundle.movieName,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                      DateFormat('yyyy-MM-dd\nkk:mm')
                          .format(ticketBundle.startAt),
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.20),
                    child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketsScreen(
                                      ticketBundle: ticketBundle,
                                    ))),
                        style: TextButton.styleFrom(
                          backgroundColor: kGoldenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular((5)),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Check",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                )),
                          ],
                        )),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
