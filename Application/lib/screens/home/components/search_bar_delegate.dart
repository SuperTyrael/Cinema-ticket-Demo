import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cinema_tickets/api/movie.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'package:cinema_tickets/screens/home/components/movie_bundle_card.dart';

class SearchBarDelegate extends SearchDelegate<String?> {
  late List<Movie> movies;

  SearchBarDelegate(BuildContext context) {
    movies = context.read(allMoviesProvider).data?.value ?? [];
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = searchMovies(context, query);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.075, right: size.width * 0.075),
                child: CustomScrollView(
                  slivers: <Widget>[_MovieList(movies: suggestionList)],
                )))
      ],
    );
  }

  //模糊搜索的提示
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = searchMovies(context, query);

    return ListView.builder(
      itemCount: suggestionList.length == 0 ? 0 : suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: InkWell(
          onTap: () {
            query = suggestionList[index].title;
          },
          child: RichText(
            text: TextSpan(
                text: suggestionList[index].title.substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].title.substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  List<Movie> searchMovies(BuildContext context, String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) {
      return [];
    }

    final movies = context.read(allMoviesProvider).data?.value ?? [];
    return movies
        .where((movie) => movie.title.toLowerCase().startsWith(lowerQuery))
        .toList();
  }
}

class _MovieList extends HookWidget {
  final List<Movie> movies;
  _MovieList({
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
