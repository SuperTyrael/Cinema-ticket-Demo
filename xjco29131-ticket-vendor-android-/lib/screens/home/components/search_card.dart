import 'package:cinema_tickets/screens/home/components/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinema_tickets/models/movie.dart';
import '../../../constants.dart';

class SearchCard extends StatelessWidget {
  final Movie? movieBundle;
  const SearchCard({Key? key, this.movieBundle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
      child: Ink(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
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
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 0.65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1),
                    child: Image.asset(
                      movieBundle!.poster,
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
                          movieBundle!.title,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        movieBundle!.releaseTime,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      buildStarRow(movieBundle!.stars),
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
}
