import 'dart:convert';
import 'dart:io';

import 'package:cinema_tickets/api/movie.dart';
import 'package:cinema_tickets/models/cinema.dart';
import 'package:cinema_tickets/models/date.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'package:cinema_tickets/models/screening.dart';
import 'package:cinema_tickets/screens/payment/pay_entry_screen.dart';
import 'package:cinema_tickets/utils/server/server.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'day_and_time_cards.dart';

const _LOCAL_DEBUG = false;

class BookTicketBody extends StatefulWidget {
  final Movie movie;
  final Cinema cinema;

  BookTicketBody({required this.movie, required this.cinema});

  @override
  createState() => new BookTicketBodyState();
}

class BookTicketBodyState extends State<BookTicketBody> {
  WebViewController? _webViewController;
  int _selectedDayIndex = 0;
  int _selectedTimeIndex = 0;
  List<Map<String, dynamic>> _selectedSeats = [];
  late Future<HttpServer> _httpServer;

  List<Screening>? screenings;
  List<Date>? dates;

  @override
  initState() {
    super.initState();
    _httpServer = createAssetsServer(prefix: 'assets/dist/');
    MovieApi.getScreenings(1, 1).then((screenings) {
      final dates = <Date>[];
      for (final screening in screenings) {
        final date = Date.fromDateTime(screening.startAt);
        if (!dates.contains(date)) {
          dates.add(date);
        }
      }

      setState(() {
        this.screenings = screenings;
        this.dates = dates;
      });
    });
  }

  String _convertSeatMap() {
    final List<Map<String, dynamic>> ret = [];
    int id = 0;
    for (int x = 1; x <= 6; x++) {
      for (int y = 1; y <= 9; y++) {
        ret.add({
          "id": id,
          "x": x,
          "y": y,
          "vip": y == 6,
          "hasChosen": false,
          "hasOccupied": x == 2
        });
        id++;
      }
    }
    return jsonEncode(ret);
  }

  @override
  Widget build(BuildContext context) {
    final webView = WebView(
      initialUrl: _LOCAL_DEBUG ? "http://192.168.1.180:8080/" : null,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) async {
        _webViewController = controller;
        if (!_LOCAL_DEBUG) {
          controller.loadUrl("http://127.0.0.1:${(await _httpServer).port}/");
        }
      },
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'ChooseSeat',
            onMessageReceived: (JavascriptMessage message) {
              final decoded =
                  jsonDecode(message.message).cast<Map<String, dynamic>>();
              setState(() {
                _selectedSeats = decoded;
              });
            })
      ]),
      onPageFinished: (url) {
        final script = "window.setSeatMap(${_convertSeatMap()})";
        _webViewController!.evaluateJavascript(script);
      },
    );

    if (screenings == null) {
      return Container();
    }

    final currentDate = dates![_selectedDayIndex];
    final sessions =
        screenings!.where((s) => currentDate.contains(s.startAt)).toList();

    final currentSession = sessions[_selectedTimeIndex];

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        dayList(),
        sessionList(sessions),
        Expanded(child: webView),
        _BuyButton(
          movie: widget.movie,
          screening: currentSession,
          cinema: widget.cinema,
          date: currentSession.startAt,
          selectedSeats: _selectedSeats,
          unitPrice: currentSession.price,
        )
      ],
    );

    return SafeArea(
      child: body,
    );
  }

  Widget sessionList(List<Screening> sessions) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sessions.length,
        itemBuilder: (context, index) => MovieTimeCard(
          screening: sessions[index],
          isActive: _selectedTimeIndex == index,
          onTap: () {
            setState(() {
              _selectedTimeIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget dayList() {
    final dates = this.dates!;

    return Container(
      padding: EdgeInsets.all(10),
      height: 96,
      decoration: BoxDecoration(
          color: Color(0xFF131313), borderRadius: BorderRadius.circular(10)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) => MovieDayCard(
          date: dates[index],
          isActive: _selectedDayIndex == index,
          onTap: () {
            setState(() {
              _selectedDayIndex = index;
              _selectedTimeIndex = 0;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _httpServer.then((server) => server.close(force: true));
  }
}

class _BuyButton extends StatefulWidget {
  final DateTime date;
  final Movie movie;
  final Cinema cinema;
  final Screening screening;
  final int unitPrice;
  final List<Map<String, dynamic>> selectedSeats;
  late int totalPrice;

  _BuyButton(
      {Key? key,
      required this.date,
      required this.movie,
      required this.cinema,
      required this.screening,
      required this.unitPrice,
      required this.selectedSeats})
      : super(key: key) {
    final normalSeats = [];
    final vipSeats = [];
    for (final seat in selectedSeats) {
      if (seat["vip"]) {
        vipSeats.add(seat);
      } else {
        normalSeats.add(seat);
      }
    }

    totalPrice =
        normalSeats.length * unitPrice + vipSeats.length * unitPrice * 2;
  }

  @override
  _BuyButtonState createState() => _BuyButtonState();
}

class _BuyButtonState extends State<_BuyButton> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final seatCount = widget.selectedSeats.length;

    final ticketInfo = Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //字间距为负可能出现显示错误
          Text(
            "$seatCount Tickets",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: -1),
            textAlign: TextAlign.left,
          ),
          Text(
            DateFormat('dd MMM, kk:mm').format(widget.date),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );

    final buyButton = Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 15),
      child: Ink(
        decoration: BoxDecoration(
          color: seatCount == 0 ? Colors.grey : Color(0xFFFFAC4B),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          onTap: () {
            onSubmit(context);
          },
          highlightColor: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              color: (seatCount == 0 || processing)
                  ? Colors.grey
                  : Color(0xFFFFAC4B),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    processing
                        ? "Locking Seats"
                        : "Buy \$${widget.totalPrice}.000",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: -1),
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[ticketInfo, Expanded(child: buyButton)],
          )),
    );
  }

  onSubmit(BuildContext context) async {
    if (widget.selectedSeats.isEmpty || processing) {
      return;
    }

    setState(() {
      processing = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      processing = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PayEntryScreen(
                unitPrice: widget.unitPrice,
                seats: widget.selectedSeats,
                movie: widget.movie)));
  }
}
