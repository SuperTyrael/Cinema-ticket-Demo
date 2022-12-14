import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_tickets/screens/book/book_screen.dart';
import 'package:cinema_tickets/screens/home/components/detail_screen.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'dart:math' as math;

import 'package:flutter_hooks/flutter_hooks.dart';

class SlidingCardsView extends StatefulHookWidget {
  final List<Movie> movieBundle;
  const SlidingCardsView({
    Key? key,
    required this.movieBundle,
  }) : super(key: key);

  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  late PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page!);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.movieBundle.length,
        itemBuilder: (context, index) {
          Movie movie = widget.movieBundle[index];
          double pageOff = pageOffset - index;
          return SlidingCard(
              movie: movie,
              name: movie.title,
              date: movie.releaseTime,
              assetName: movie.poster,
              offset: pageOff);
        },
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final Movie movie;
  final String name;
  final String date;
  final String assetName;
  double offset;

  SlidingCard({
    Key? key,
    required this.movie,
    required this.name,
    required this.date,
    required this.assetName,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
        child: Card(
          margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            movieBundle: movie,
                          ))),
              child: Column(
                children: <Widget>[
                  Container(
                      constraints: BoxConstraints(maxHeight: 290),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(assetName)))),
                  SizedBox(height: 8),
                  Expanded(
                    child: CardContent(
                        name: name, date: date, offset: gauss, movie: movie),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String date;
  final Movie movie;
  final double offset;

  const CardContent(
      {Key? key,
      required this.name,
      required this.date,
      required this.movie,
      required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(
              name,
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(24 * offset, 0),
                    child: Text('Reserve'),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () => _goBuy(context),
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  '21.00 \$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }

  void _goBuy(BuildContext context) async {
    if (!Application.isLogin) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
      if (!Application.isLogin) {
        return;
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookScreen(
                  movie: movie,
                )));
  }
}
