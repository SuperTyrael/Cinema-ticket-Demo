import 'package:flutter/material.dart';

class MovieTimes {
  final int? price;
  final String? filmTitle, type;
  final DateTime? startAt;
  List<DateTime>? session;
  MovieTimes(
      {this.price,
      this.filmTitle,
        this.type,
      this.startAt,
      this.session});
}

List<MovieTimes> movieTimesBundle = [
  MovieTimes(
    price: 91,
    startAt: DateTime.parse('2021-04-01 18:30:00'),
    session: [
      DateTime.parse('2021-04-01 12:30:00'),
      DateTime.parse('2021-04-01 14:30:00'),
      DateTime.parse('2021-04-01 16:30:00'),
      DateTime.parse('2021-04-01 18:30:00')
    ],
    type: "3D"
  ),
  MovieTimes(
    price: 91,
    startAt: DateTime.parse('2021-04-01 18:30:00'),
      session: [
        DateTime.parse('2021-04-02 12:30:00'),
        DateTime.parse('2021-04-02 14:30:00'),
        DateTime.parse('2021-04-02 16:30:00'),
        DateTime.parse('2021-04-02 18:30:00')
      ],
    type: "2D"
  ),
  MovieTimes(
    price: 91,
    startAt: DateTime.parse('2021-04-01 18:30:00'),
      session: [
        DateTime.parse('2021-04-03 10:30:00'),
        DateTime.parse('2021-04-03 09:30:00'),
        DateTime.parse('2021-04-03 08:30:00'),
        DateTime.parse('2021-04-03 07:30:00')
      ],
      type: "2D"
  ),
  MovieTimes(
    price: 91,
    startAt: DateTime.parse('2021-04-01 18:30:00'),
      session: [
        DateTime.parse('2021-04-04 12:30:00'),
        DateTime.parse('2021-04-04 14:30:00'),
        DateTime.parse('2021-04-04 16:30:00'),
        DateTime.parse('2021-04-04 18:30:00')
      ],
      type: "2D"
  ),
  MovieTimes(
    price: 91,
    startAt: DateTime.parse('2021-04-02 18:30:00'),
      session: [
        DateTime.parse('2021-04-01 12:30:00'),
        DateTime.parse('2021-04-01 14:30:00'),
        DateTime.parse('2021-04-01 16:30:00'),
        DateTime.parse('2021-04-01 18:30:00')
      ],
      type: "2D"
  )
];