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
      query: map['query'] != null ? List<dynamic>.from(map['query']) : [],
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
    final props = map['properties'] as Map<String, dynamic>?;
    // Search Box API uses 'feature_type' inside properties instead of 'place_type' at the root.
    final rawPlaceType = map['place_type'] as List<dynamic>?;
    final featureType = props?['feature_type'] as String?;
    final placeType = rawPlaceType != null
        ? rawPlaceType
            .cast<String>()
            .map((t) => PlaceType.values.byName(t))
            .toList()
        : (featureType != null &&
                PlaceType.values.any((e) => e.name == featureType)
            ? [PlaceType.values.byName(featureType)]
            : <PlaceType>[]);

    // Search Box API has no 'center' field; fall back to geometry coordinates.
    LatLon center;
    if (map['center'] != null) {
      center = LatLon.fromList(map['center'] as List<dynamic>);
    } else {
      final geom = map['geometry'] as Map<String, dynamic>;
      center = LatLon.fromList(geom['coordinates'] as List<dynamic>);
    }

    return Feature(
      // Search Box API uses 'mapbox_id' inside properties instead of 'id' at root.
      id: map['id'] as String? ?? props?['mapbox_id'] as String? ?? '',
      type: map['type'] as String? ?? '',
      placeType: placeType,
      relevance: (map['relevance'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] as String? ?? props?['address'] as String?,
      properties: props != null ? Properties.fromMap(props) : null,
      // Search Box API uses 'properties.name' instead of 'text'.
      text: map['text'] as String? ?? props?['name'] as String? ?? '',
      // Search Box API uses 'properties.full_address' instead of 'place_name'.
      placeName: map['place_name'] as String? ??
          props?['full_address'] as String? ??
          '',
      bbox: map['bbox'] != null ? List.from(map['bbox']).cast<double>() : null,
      center: center,
      geometry: Geometry.fromMap(map['geometry'] as Map<String, dynamic>),
      context: map['context'] != null
          ? List<Context>.from(
              (map['context'] as List).map((x) => Context.fromMap(x)))
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
