import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_tickets/api/movie.dart';
import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'package:cinema_tickets/screens/book/book_screen.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _BBFC_ASSET_MAP = {
  '12': 'assets/bbfc/BBFC_12_2019.svg',
  '12A': 'assets/bbfc/BBFC_12A_2019.svg',
  '15': "assets/bbfc/BBFC_15_2019.svg",
  '18': "assets/bbfc/BBFC_18_2019.svg",
  'PG': "assets/bbfc/BBFC_PG_2019.svg",
  'U': "assets/bbfc/BBFC_U_2019.svg"
};

class DetailScreen extends StatelessWidget {
  final Movie? movieBundle;
  static String routeName = "/detail";

  const DetailScreen({Key? key, this.movieBundle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailBody(
        movieBundle: movieBundle,
      ),
    );
  }
}

class DetailBody extends HookWidget {
  final Movie? movieBundle;

  const DetailBody({Key? key, this.movieBundle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: true,
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _backAndRating(size, movieBundle!),
          _title(context, movieBundle!),
          _actorView(movieBundle!),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Text(
              "Plot Summary",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: new BoxConstraints(maxHeight: 190),
              child:
                  ListView(padding: EdgeInsets.only(top: 0), children: <Widget>[
                Text(
                  movieBundle!.blurb,
                  style: TextStyle(
                    color: Color(0xFF737599),
                  ),
                  softWrap: true,
                ),
              ]),
            ),
          ),
          Spacer(),
          Center(
            child: Container(
              width: size.width*0.6,
              margin: EdgeInsets.symmetric(horizontal: 20),
                child: RaisedButton(
                  color: kGoldenColor,
                    child: Text('Buy'),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () => _goBuy(context),
                ),
              ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _actorView(Movie movieBundle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieBundle.actor.length,
            itemBuilder: (context, index) =>
                ActorCard(actor: movieBundle.actor[index])),
      ),
    );
  }

  Padding _title(BuildContext context, Movie movieBundle) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${movieBundle.title}',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    '${movieBundle.releaseTime}',
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${movieBundle.timeLong} mins',
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                '${movieBundle.classification}',
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Container _backAndRating(Size size, Movie movieBundle) {
    final bbfc = movieBundle.bbfc?.toUpperCase() ?? "U";
    final favMovies = useProvider(favoriteMoviesProvider).data?.value ?? [];
    final isSaved = favMovies.contains(movieBundle);

    return Container(
      height: size.height * 0.4,
      child: Stack(
        children: <Widget>[
          //poster display on the top
          Container(
            height: size.height * 0.4 - 50,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(50)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(movieBundle.poster))),
          ),

          Positioned(
              top: 46,
              right: 10,
              child: IconButton(
                color: Colors.white,
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  isSaved
                      ? removeFavorite(movieBundle)
                      : addFavorite(movieBundle);
                },
              )
              // child: Container(
              //   child:
              //       //用这个
              // //   Icon(
              // // alreadySaved ? Icons.favorite : Icons.favorite_border,
              // //   color: Colors.red
              // // )
              // ),
              ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size.width * 0.5,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 50,
                      color: Color(0xff12153d).withOpacity(0.2),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.star, color: kGoldenColor),
                        SizedBox(
                          height: 5,
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: "${movieBundle.stars}/",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              TextSpan(text: "5\n"),
                              TextSpan(
                                  text: "1234",
                                  style: TextStyle(color: Colors.grey))
                            ]))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          _BBFC_ASSET_MAP[bbfc]!,
                          width: 32,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "BBFC: $bbfc",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
              child: BackButton(
            color: Colors.white,
          ))
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
              movie: movieBundle!,
            )));
  }
}

class ActorCard extends StatelessWidget {
  final String? actor;

  const ActorCard({Key? key, this.actor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5, // 5 padding top and bottom
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        actor!,
        style: TextStyle(color: kTextColor.withOpacity(0.8), fontSize: 16),
      ),
    );
  }
}
