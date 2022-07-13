// ignore_for_file: public_member_api_docs, sort_constructors_first
enum Types {
  country,
  postcode,
  district,
  place,
  region,
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
    return LatLon(
      (list[1] as num).toDouble(),
      (list[0] as num).toDouble(),
    );
  }

  @override
  String toString() => 'LatLon(latitude: $latitude, longitude: $longitude)';
}
