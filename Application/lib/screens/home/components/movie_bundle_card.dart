import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_tickets/screens/book/book_screen.dart';
import 'package:cinema_tickets/screens/home/components/detail_screen.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:flutter/material.dart';
import 'package:cinema_tickets/models/movie.dart';
import '../../../constants.dart';

class MovieBundleCard extends StatelessWidget {
  final Movie movieBundle;
  const MovieBundleCard({
    Key? key,
    required this.movieBundle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final poster = AspectRatio(
      aspectRatio: 0.65,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: movieBundle.poster,
          fit: BoxFit.cover,
        ),
      ),
    );

    return AspectRatio(
      aspectRatio: 1.65,
      child: Ink(
        decoration: BoxDecoration(
            color: Color(0xFFB0C4DE).withOpacity(0.25),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        movieBundle: movieBundle,
                      ))),
          highlightColor: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                poster,
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          movieBundle.title,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        timeCovert(movieBundle.timeLong),
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      buildStarRow(movieBundle.stars),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.25),
                        child: _buyButton(context),
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
        ),
      ),
    );
  }

  String timeCovert(int timelong) {
    var d = Duration(minutes: timelong);
    List<String> parts = d.toString().split(':');
    return "${parts[0]}H ${parts[1]}Mins";
  }

  Row buildStarRow(int stars) {
    if (stars < 1 || stars > 5) {
      return Row(
        children: [Text("Not available")],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Icon(Icons.star, color: 1 >= stars ? Colors.black : kGoldenColor),
          new Icon(Icons.star, color: 2 >= stars ? Colors.black : kGoldenColor),
          new Icon(Icons.star, color: 3 >= stars ? Colors.black : kGoldenColor),
          new Icon(Icons.star, color: 4 >= stars ? Colors.black : kGoldenColor),
          new Icon(Icons.star, color: 5 >= stars ? Colors.black : kGoldenColor),
        ],
      );
    }
  }

  Widget _buyButton(BuildContext context) {
    return TextButton(
        onPressed: () => _goBuy(context),
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
                  "Buy",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )),
          ],
        ));
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
                  movie: movieBundle,
                )));
  }
}
