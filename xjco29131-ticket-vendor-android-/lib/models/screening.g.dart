// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screening.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Screening _$ScreeningFromJson(Map<String, dynamic> json) {
  return Screening(
    id: json['sid'] as int,
    venueId: json['venue_id'] as int,
    filmId: json['film_id'] as int,
    cinemaId: json['cid'] as int,
    name: json['v_name'] as String,
    location: json['location'] as String,
    price: json['price'] as int,
    startAtStr: json['start_at'] as String,
  );
}

Map<String, dynamic> _$ScreeningToJson(Screening instance) => <String, dynamic>{
      'sid': instance.id,
      'venue_id': instance.venueId,
      'film_id': instance.filmId,
      'cid': instance.cinemaId,
      'v_name': instance.name,
      'location': instance.location,
      'price': instance.price,
      'start_at': instance.startAtStr,
    };
