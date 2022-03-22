import 'values.dart';

class ForwardQueryParams {
  final bool? autocomplete;
  final List<double>? bbox;
  final String? country;
  final bool? fuzzyMatch;
  final String? language;
  final int? limit;
  final LatLon? proximity;
  final bool? routing;
  final List<Types>? types;
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
    if (autocomplete != null) map['autocomplete'] = autocomplete;
    if (bbox != null) map['bbox'] = bbox;
    if (country != null) map['country'] = country;
    if (fuzzyMatch != null) map['fuzzyMatch'] = fuzzyMatch;
    if (language != null) map['language'] = language;
    if (limit != null) map['limit'] = limit;
    if (proximity != null) map['proximity'] = proximity!.toParamStr();
    if (routing != null) map['routing'] = routing;
    if (types != null) map['types'] = types!.map((type) => type.name).toList();
    if (worldview != null) map['worldview'] = worldview;
    return map;
  }
}

class ReverseQueryParams {
  final String? country;
  final String? language;
  final int? limit;
  final bool? routing;
  final List<Types>? types;
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
    if (limit != null) map['limit'] = limit;
    if (routing != null) map['routing'] = routing;
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
