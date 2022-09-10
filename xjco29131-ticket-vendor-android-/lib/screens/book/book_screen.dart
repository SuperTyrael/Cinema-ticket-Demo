import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/models/cinema.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'package:flutter/material.dart';
import 'components/bookbody.dart';

class BookScreen extends StatelessWidget {
  static String routeName = "/book";
  final Movie movie;
  const BookScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text(
          '${movie.title}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: Text(
              "${movie.timeLong} mins",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
      ),
      body: BookTicketBody(
          movie: movie,
          cinema: Cinema(
              id: 0, name: "Cinema A", location: "", info: "", score: 0)),
    );
  }
}
