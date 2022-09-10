import 'package:json_annotation/json_annotation.dart';

part 'screening.g.dart';

@JsonSerializable()
class Screening {
  @JsonKey(name: "sid")
  final int id;
  @JsonKey(name: "venue_id")
  final int venueId;
  @JsonKey(name: "film_id")
  final int filmId;
  @JsonKey(name: "cid")
  final int cinemaId;

  @JsonKey(name: "v_name")
  final String name;
  final String location;

  final int price;

  @JsonKey(name: "start_at")
  final String startAtStr;

  final DateTime startAt;

  Screening({
    required this.id,
    required this.venueId,
    required this.filmId,
    required this.cinemaId,
    required this.name,
    required this.location,
    required this.price,
    required this.startAtStr,
  }) : startAt = DateTime.parse(startAtStr);

  factory Screening.fromJson(Map<String, dynamic> json) =>
      _$ScreeningFromJson(json);
  Map<String, dynamic> toJson() => _$ScreeningToJson(this);
}
