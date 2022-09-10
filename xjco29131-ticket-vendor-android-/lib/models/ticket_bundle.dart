import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class TicketBundle {
  final int price, room, time;
  final String movieName, filmType, userName, ticketType, imageSrc, uuid;
  final DateTime startAt;
  List<String> seat;
  TicketBundle(
      {required this.price,
      required this.room,
      required this.time,
      required this.movieName,
      required this.imageSrc,
      required this.seat,
      required this.filmType,
      required this.userName,
      required this.ticketType,
      required this.startAt,
      required this.uuid});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TicketBundle &&
        other.time == time &&
        other.uuid == uuid &&
        other.startAt == startAt &&
        listEquals(other.seat, seat);
  }

  @override
  int get hashCode {
    return time.hashCode ^ uuid.hashCode ^ startAt.hashCode ^ seat.hashCode;
  }
}

final ticketsSubject = BehaviorSubject<List<TicketBundle>>.seeded([]);

addTicket(TicketBundle ticket) {
  ticketsSubject.add(ticketsSubject.value!..add(ticket));
}

removeTicket(TicketBundle ticket) {
  ticketsSubject.add(ticketsSubject.value!..remove(ticket));
}
