import 'dart:convert';

import 'package:map_box_geocoder/src/values.dart';

class MapBoxResponse {
  final String type;
  final List<dynamic> query;
  final List<Feature> features;
  final String attribution;
  MapBoxResponse({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  factory MapBoxResponse.fromMap(Map<String, dynamic> map) {
    return MapBoxResponse(
      type: map['type'] ?? '',
      query: List<dynamic>.from(map['query']),
      features:
          List<Feature>.from(map['features'].map((x) => Feature.fromMap(x))),
      attribution: map['attribution'] ?? '',
    );
  }

  factory MapBoxResponse.fromJson(String source) =>
      MapBoxResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MapBoxResponse(type: $type, query: $query, features: $features, attribution: $attribution)';
  }
}

class Feature {
  final String id;
  final String type;
  final List<PlaceType> placeType;
  final double relevance;
  final String? address;
  final Properties? properties;
  final String text;
  final String placeName;
  final List<double>? bbox;
  final LatLon center;
  final Geometry geometry;
  final List<Context> context;
  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.relevance,
    this.address,
    required this.properties,
    required this.text,
    required this.placeName,
    required this.bbox,
    required this.center,
    required this.geometry,
    required this.context,
  });

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      placeType: (map['place_type'] as List<dynamic>)
          .cast<String>()
          .map(PlaceType.values.byName)
          .toList(),
      relevance: map['relevance']?.toDouble() ?? 0.0,
      address: map['address'],
      properties: map['properties'] != null
          ? Properties.fromMap(map['properties'])
          : null,
      text: map['text'] ?? '',
      placeName: map['placeName'] ?? '',
      bbox: map['bbox'] != null ? List.from(map['bbox']).cast<double>() : null,
      center: LatLon.fromList(map['center']),
      geometry: Geometry.fromMap(map['geometry']),
      context: map['context'] != null
          ? List<Context>.from(map['context'].map((x) => Context.fromMap(x)))
          : [],
    );
  }

  factory Feature.fromJson(String source) =>
      Feature.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Feature(id: $id, type: $type, placeType: $placeType, relevance: $relevance, address: $address, properties: $properties, text: $text, placeName: $placeName, bbox: $bbox, center: $center, geometry: $geometry, context: $context)';
  }
}

class Properties {
  final String? accuracy;
  final String? address;
  final String? category;
  final String? wikidata;
  final String? shortCode;
  Properties({
    this.accuracy,
    this.address,
    this.category,
    this.wikidata,
    this.shortCode,
  });

  factory Properties.fromMap(Map<String, dynamic> map) {
    return Properties(
      accuracy: map['accuracy'],
      address: map['address'],
      category: map['category'],
      wikidata: map['wikidata'],
      shortCode: map['shortCode'],
    );
  }

  factory Properties.fromJson(String source) =>
      Properties.fromMap(json.decode(source));
}

class Geometry {
  final String type;
  final LatLon coordinates;
  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromMap(Map<String, dynamic> map) {
    return Geometry(
      type: map['type'] ?? '',
      coordinates: LatLon.fromList(map['coordinates']),
    );
  }

  factory Geometry.fromJson(String source) =>
      Geometry.fromMap(json.decode(source));

  @override
  String toString() => 'Geometry(type: $type, coordinates: $coordinates)';
}

class Context {
  final String id;
  final String wikidata;
  final String text;
  final String? shortCode;

  Context({
    required this.id,
    required this.wikidata,
    required this.text,
    this.shortCode,
  });

  factory Context.fromMap(Map<String, dynamic> map) {
    return Context(
      id: map['id'] ?? '',
      wikidata: map['wikidata'] ?? '',
      text: map['text'] ?? '',
      shortCode: map['short_code'],
    );
  }

  factory Context.fromJson(String source) =>
      Context.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Context(id: $id, wikidata: $wikidata, text: $text, shortCode: $shortCode)';
  }
}
