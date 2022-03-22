enum Types {
  country,
  postcode,
  district,
  place,
  locality,
  neighborhood,
  address,
  poi,
}

class LatLon {
  final double latitude;
  final double longitude;
  LatLon(
    this.latitude,
    this.longitude,
  );

  String toParamStr() {
    return '$longitude,$latitude';
  }

  factory LatLon.fromList(List<dynamic> list) {
    return LatLon(list[1], list[0]);
  }
}
