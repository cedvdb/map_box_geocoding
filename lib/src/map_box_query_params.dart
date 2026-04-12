import 'values.dart';

class ForwardQueryParams {
  final bool? autocomplete;
  final List<double>? bbox;

  /// isecode
  final String? country;
  final bool? fuzzyMatch;
  final String? language;
  final int? limit;
  final LatLon? proximity;
  final bool? routing;
  final List<PlaceType>? types;
  final String? worldview;

  const ForwardQueryParams({
    this.autocomplete,
    this.bbox,
    this.country,
    this.fuzzyMatch,
    this.language,
    this.limit,
    this.proximity,
    this.routing,
    this.types,
    this.worldview,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    // we have nullables so defaults values are respected
    if (autocomplete != null) map['autocomplete'] = autocomplete.toString();
    if (bbox != null) {
      map['bbox'] =
          bbox != null ? bbox!.map((value) => value.toString()) : null;
    }
    if (country != null) map['country'] = country;
    if (fuzzyMatch != null) map['fuzzyMatch'] = fuzzyMatch.toString();
    if (language != null) map['language'] = language;
    if (limit != null) map['limit'] = limit.toString();
    if (proximity != null) map['proximity'] = proximity!.toParamStr();
    if (routing != null) map['routing'] = routing.toString();
    if (types != null) map['types'] = types!.map((type) => type.name).toList();
    if (worldview != null) map['worldview'] = worldview;
    return map;
  }
}

class ReverseQueryParams {
  /// isocode
  final String? country;
  final String? language;
  final int? limit;
  final bool? routing;
  final List<PlaceType>? types;
  final String? worldview;
  final ReverseMode? reverseMode;
  const ReverseQueryParams({
    this.country,
    this.language,
    this.limit,
    this.routing,
    this.types,
    this.worldview,
    this.reverseMode,
  });
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    // we have nullables so defaults values are respected
    if (country != null) map['country'] = country;
    if (language != null) map['language'] = language;
    if (limit != null) map['limit'] = limit.toString();
    if (routing != null) map['routing'] = routing.toString();
    if (types != null) map['types'] = types!.map((type) => type.name).toList();
    if (worldview != null) map['worldview'] = worldview;
    if (reverseMode != null) map['reverseMode'] = reverseMode!.name;
    return map;
  }
}

enum ReverseMode {
  distance,
  score,
}

class SearchBoxQueryParams {
  final String? language;
  final String? country;
  final int? limit;
  final LatLon? proximity;
  final List<PlaceType>? types;
  final List<String>? poiCategories;

  const SearchBoxQueryParams({
    this.language,
    this.country,
    this.limit,
    this.proximity,
    this.types,
    this.poiCategories,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (language != null) map['language'] = language;
    if (country != null) map['country'] = country;
    if (limit != null) map['limit'] = limit.toString();
    if (proximity != null) map['proximity'] = proximity!.toParamStr();
    if (types != null) map['types'] = types!.map((type) => type.name).join(',');
    if (poiCategories != null && poiCategories!.isNotEmpty) {
      map['poi_category'] = poiCategories!.join(',');
    }
    return map;
  }
}

/// Query parameters for the Search Box `/suggest` endpoint.
///
/// The [sessionToken] should be a random UUID that is kept stable for the
/// duration of a single autocomplete session (from the first keystroke until
/// the user picks a result with [MapBoxSearchBox.retrieve]). Mapbox bills each
/// session — rather than each individual request — as a single unit when a
/// [sessionToken] is supplied.
class SuggestQueryParams {
  final String? language;
  final String? country;
  final int? limit;
  final LatLon? proximity;
  final List<PlaceType>? types;
  final List<String>? poiCategories;

  /// A random UUID that groups the `/suggest` and `/retrieve` calls for a
  /// single autocomplete session into one billable unit.
  final String sessionToken;

  const SuggestQueryParams({
    required this.sessionToken,
    this.language,
    this.country,
    this.limit,
    this.proximity,
    this.types,
    this.poiCategories,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['session_token'] = sessionToken;
    if (language != null) map['language'] = language;
    if (country != null) map['country'] = country;
    if (limit != null) map['limit'] = limit.toString();
    if (proximity != null) map['proximity'] = proximity!.toParamStr();
    if (types != null) map['types'] = types!.map((type) => type.name).join(',');
    if (poiCategories != null && poiCategories!.isNotEmpty) {
      map['poi_category'] = poiCategories!.join(',');
    }
    return map;
  }
}
