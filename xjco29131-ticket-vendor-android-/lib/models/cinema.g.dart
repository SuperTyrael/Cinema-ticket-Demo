// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cinema _$CinemaFromJson(Map<String, dynamic> json) {
  return Cinema(
    id: json['cid'] as int,
    name: json['name'] as String,
    location: json['location'] as String,
    info: json['info'] as String,
    score: json['score'] as int,
  );
}

Map<String, dynamic> _$CinemaToJson(Cinema instance) => <String, dynamic>{
      'cid': instance.id,
      'name': instance.name,
      'location': instance.location,
      'info': instance.info,
      'score': instance.score,
    };
