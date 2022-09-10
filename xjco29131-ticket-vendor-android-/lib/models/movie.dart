import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  @JsonKey(name: "film_id")
  final int id;
  final String starring;

  @JsonKey(name: "running_time")
  final int timeLong;
  @JsonKey(name: "release_time")
  final String releaseTime;
  final String title, blurb, poster;
  final List<String> classification;
  final double rank;
  final String? bbfc;

  List<String> get actor => starring.split(",");
  int get stars => 5;

  Movie({
    required this.id,
    required this.timeLong,
    required this.releaseTime,
    required this.title,
    required this.blurb,
    required this.poster,
    required this.classification,
    required this.starring,
    required this.rank,
    required this.bbfc,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
