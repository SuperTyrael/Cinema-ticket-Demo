import 'package:cinema_tickets/screens/home/components/body.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class CinemaScreen extends StatelessWidget {
  static String routeName = "/cinema_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        title: Text(
          "Cinema",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold, color: kGoldenColor),
        ),
      ),
      body: CinemaScreenBody(),
    );
  }
}

class CinemaScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[

      ],
    );
  }
}
