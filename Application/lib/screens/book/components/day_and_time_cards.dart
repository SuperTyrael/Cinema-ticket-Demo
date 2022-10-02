import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/models/date.dart';
import 'package:cinema_tickets/models/screening.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//单个日期
class MovieDayCard extends StatelessWidget {
  final Date date;
  final bool isActive;
  final VoidCallback onTap;

  const MovieDayCard(
      {Key? key,
      required this.date,
      required this.onTap,
      required this.isActive})
      : super(key: key);

  void _handleTap() {
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final dt = date.asDateTime();
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5, // 5 padding top and bottom
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isActive ? kGoldenColor : Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(DateFormat('dd').format(dt),
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Spacer(),
            Text(
              DateFormat('E').format(dt),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

//场次
class MovieTimeCard extends StatelessWidget {
  final Screening screening;
  final bool isActive;

  final VoidCallback onTap;

  const MovieTimeCard({
    Key? key,
    required this.screening,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  void _handleTap() {
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 20),
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5, // 5 padding top and bottom
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: isActive ? kGoldenColor : Colors.white.withOpacity(0.6),
              width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('kk:mm').format(screening.startAt),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              screening.price.toString(),
              style:
                  TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
              textAlign: TextAlign.right,
            )
          ],
        ),
      ),
    );
  }
}
