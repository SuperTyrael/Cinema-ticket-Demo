// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['film_id'] as int,
    timeLong: json['running_time'] as int,
    releaseTime: json['release_time'] as String,
    title: json['title'] as String,
    blurb: json['blurb'] as String,
    poster: json['poster'] as String,
    classification: (json['classification'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    starring: json['starring'] as String,
    rank: (json['rank'] as num).toDouble(),
    bbfc: json['bbfc'] as String?,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'film_id': instance.id,
      'starring': instance.starring,
      'running_time': instance.timeLong,
      'release_time': instance.releaseTime,
      'title': instance.title,
      'blurb': instance.blurb,
      'poster': instance.poster,
      'classification': instance.classification,
      'rank': instance.rank,
      'bbfc': instance.bbfc,
    };
