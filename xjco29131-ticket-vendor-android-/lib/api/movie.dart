import 'package:cinema_tickets/api/common.dart';
import 'package:cinema_tickets/models/cinema.dart';
import 'package:cinema_tickets/models/movie.dart';
import 'package:cinema_tickets/models/screening.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class MovieApi {
  static Future<List<Movie>> getAll() async {
    final response = await dio.get("/guest/films_info");
    final films = response.data["data"]["films"] as List<dynamic>;
    return films
        .map((data) {
          try {
            return Movie.fromJson(data);
          } catch (e) {
            print(e);
            return null;
          }
        })
        .where((film) => film != null)
        .map((film) => film!)
        .toList();
  }

  static Future<List<Cinema>> getCinemasByFilm(int filmId) async {
    final response =
        await dio.post("/guest/cinema_film", data: {"film_id": filmId});

    final cinemas = response.data["data"]["cinemas"] as List<dynamic>;
    return cinemas
        .map((data) {
          try {
            return Cinema.fromJson(data);
          } catch (e) {
            print(e);
            return null;
          }
        })
        .where((film) => film != null)
        .map((film) => film!)
        .toList();
  }

  static Future<List<Screening>> getScreenings(int filmId, int cinemaId) async {
    final response = await dio.post("/guest/screenings_film",
        data: {"film_id": filmId, "cinema_id": cinemaId});

    final screenings = response.data["data"]["screenings"] as List<dynamic>;
    return screenings
        .map((data) {
          try {
            return Screening.fromJson(data);
          } catch (e) {
            print(e);
            return null;
          }
        })
        .where((film) => film != null)
        .map((film) => film!)
        .toList();
  }
}

final allMoviesProvider = FutureProvider((ref) => MovieApi.getAll());
final currentCinemaSubject = BehaviorSubject.seeded(0);
final currentCinemaProvider =
    StreamProvider((ref) => currentCinemaSubject.stream);

final currentMoviesProvider = Provider((ref) {
  final movies = ref.watch(allMoviesProvider);
  final currentCinema = ref.watch(currentCinemaProvider).data?.value ?? 0;

  return movies.when(
      data: (movies) {
        return movies.sublist(currentCinema * 5);
      },
      loading: () => <Movie>[],
      error: (e, s) => <Movie>[]);
});

final favoriteMoviesSubject = BehaviorSubject.seeded(<Movie>[]);
final favoriteMoviesProvider =
    StreamProvider((ref) => favoriteMoviesSubject.stream);

void addFavorite(Movie movie) {
  final favMovies = favoriteMoviesSubject.value!;
  favoriteMoviesSubject.add(favMovies..add(movie));
}

void removeFavorite(Movie movie) {
  final favMovies = favoriteMoviesSubject.value!;
  favoriteMoviesSubject.add(favMovies..remove(movie));
}
