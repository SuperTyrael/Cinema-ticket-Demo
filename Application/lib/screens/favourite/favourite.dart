import 'package:cinema_tickets/api/movie.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'package:cinema_tickets/screens/home/components/movie_bundle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavouriteScreen extends HookWidget {
  static String routeName = "/favourite";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final movies = useProvider(favoriteMoviesProvider).data?.value ?? [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          "My Favourite Movie",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: 30,left: size.width * 0.075, right: size.width * 0.075),
          child: CustomScrollView(
            slivers: <Widget>[
              Body(movies: movies)
            ],
          ),
        ),
          // child: SliverGrid(
          //   delegate: SliverChildBuilderDelegate(
          //         (BuildContext context, int index) {
          //       return MovieBundleCard(movieBundle: movies[index]);
          //     },
          //     childCount: movies.length,
          //   ),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 1,
          //     mainAxisSpacing: 20,
          //     childAspectRatio: 1.65,
          //   ),
          // )
        // child: ListView.builder(
        //     itemCount: movies.length,
        //     padding: EdgeInsets.only(top: 8, bottom: 8),
        //     itemBuilder: (context, index) {
        //       return MovieBundleCard(movieBundle: movies[index]);
        //     }),
      ),
    );
  }
}

class Body extends StatelessWidget{
  final List<Movie> movies;
  Body({
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return MovieBundleCard(movieBundle: movies[index]);
        },
        childCount: movies.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        childAspectRatio: 1.65,
      ),
    );
  }
}
