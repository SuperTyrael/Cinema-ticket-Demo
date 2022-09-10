import 'package:json_annotation/json_annotation.dart';

part 'cinema.g.dart';

@JsonSerializable()
class Cinema {
  @JsonKey(name: "cid")
  final int id;
  final String name;
  final String location;
  final String info;
  final int score;

  Cinema({
    required this.id,
    required this.name,
    required this.location,
    required this.info,
    required this.score,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) => _$CinemaFromJson(json);
  Map<String, dynamic> toJson() => _$CinemaToJson(this);
}
