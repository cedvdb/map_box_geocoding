import 'package:map_box_geocoder/src/map_box_query_params.dart';
import 'package:map_box_geocoder/src/map_box_response.dart';
import 'package:map_box_geocoder/src/values.dart';
import 'package:test/test.dart';

void main() {
  test('Should decode json response', () {
    final responseJson = '''
{"type":"FeatureCollection","query":["pa"],"features":[{"id":"country.13545879598622050","type":"Feature","place_type":["country"],"relevance":1,"properties":{"wikidata":"Q55","short_code":"nl"},"text":"Netherlands","place_name":"Netherlands","matching_text":"Холандија","matching_place_name":"Холандија","bbox":[3.33390071158434,50.7503661060614,7.22749998189678,53],"center":[5.61349061168593,51],"geometry":{"type":"Point","coordinates":[5.61349061168593,51.9724664894952]}},{"id":"place.14749210607497330","type":"Feature","place_type":["region","place"],"relevance":1,"properties":{"short_code":"FR-75","wikidata":"Q90"},"text":"Paris","place_name":"Paris, France","bbox":[2.22422400085346,48.8156060108013,2.46976999462145,48.9020129995121],"center":[2.35183,48.85658],"geometry":{"type":"Point","coordinates":[2.35183,48.85658]},"context":[{"id":"country.19008108158641660","wikidata":"Q142","short_code":"fr","text":"France"}]},{"id":"region.13761801799111630","type":"Feature","place_type":["region"],"relevance":1,"properties":{"short_code":"US-PA","wikidata":"Q1400"},"text":"Pennsylvania","place_name":"Pennsylvania, United States","bbox":[-80.6176229,39.7197980002265,-74.6895010663323,42.4558884495783],"center":[-78.2907462468837,41.0911397651],"geometry":{"type":"Point","coordinates":[-78.2907462468837,41.0911397651]},"context":[{"id":"country.19678805456372290","wikidata":"Q30","short_code":"us","text":"United States"}]},{"id":"region.9882499685836130","type":"Feature","place_type":["region"],"relevance":1,"properties":{"short_code":"FR-76","wikidata":"Q12758"},"text":"Seine-Maritime","place_name":"Seine-Maritime, France","matching_text":"Pajūrio Sena","matching_place_name":"Pajūrio Sena, France","bbox":[-0.033835691006841,49.2509210000393,1.79060599958289,50.1213178852323],"center":[0.83333,49.66667],"geometry":{"type":"Point","coordinates":[0.83333,49.66667]},"context":[{"id":"country.19008108158641660","wikidata":"Q142","short_code":"fr","text":"France"}]},{"id":"locality.8740283744465570","type":"Feature","place_type":["locality"],"relevance":1,"properties":{"wikidata":"Q191066"},"text":"15th arrondissement of Paris","place_name":"15th arrondissement of Paris, Paris, France","matching_text":"Paris femtonde arrondissement","matching_place_name":"Paris femtonde arrondissement, Paris, France","bbox":[2.262685,48.825397,2.324717,48.858347],"center":[2.30029,48.84133],"geometry":{"type":"Point","coordinates":[2.30029,48.84133]},"context":[{"id":"place.14749210607497330","short_code":"FR-75","wikidata":"Q90","text":"Paris"},{"id":"country.19008108158641660","wikidata":"Q142","short_code":"fr","text":"France"}]}],"attribution":"NOTICE: © 2022 Mapbox and its suppliers. All rights reserved. Use of this data is subject to the Mapbox Terms of Service (https://www.mapbox.com/about/maps/). This response and the information it contains may not be retained. POI(s) provided by Foursquare."}
''';
    MapBoxResponse.fromJson(responseJson);
  });

  test('Should decode Search Box json response (no query field)', () {
    final responseJson = '''
{"type":"FeatureCollection","features":[{"id":"poi.123456","type":"Feature","place_type":["poi"],"relevance":1,"properties":{"category":"coffee_shop"},"text":"Blue Bottle Coffee","place_name":"Blue Bottle Coffee, 300 Webster St, Oakland, California 94609, United States","center":[-122.2711,37.8079],"geometry":{"type":"Point","coordinates":[-122.2711,37.8079]},"context":[{"id":"place.987654","wikidata":"Q","text":"Oakland"}]}],"attribution":"NOTICE: © 2024 Mapbox and its suppliers. All rights reserved."}
''';
    final result = MapBoxResponse.fromJson(responseJson);
    expect(result.query, isEmpty);
    expect(result.features, isNotEmpty);
  });

  test('Should decode real Search Box API response (no place_type / center / text fields)', () {
    // Mirrors the actual Search Box API response shape from /search/searchbox/v1/forward
    final responseJson = '''
{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"coordinates":[2.351499,48.857163],"type":"Point"},"properties":{"name":"Hötel de ville","mapbox_id":"dXJuOm1ieHBvaTplYTAxOTIxLTI0YTYtNDc4YS1iOGI0LTlkMWU4N2E5NjUyMQ","feature_type":"poi","address":"8 Pl. de l\'Hôtel de Ville","full_address":"8 Pl. de l\'Hôtel de Ville, 75004 Paris, France","place_formatted":"75004 Paris, France","coordinates":{"latitude":48.857163,"longitude":2.351499},"language":"","maki":"cafe","poi_category":["café","coffee"],"poi_category_ids":["cafe","coffee_shop"],"external_ids":{},"metadata":{},"distance":81}}],"attribution":"© 2026 Mapbox and its suppliers. All rights reserved."}
''';
    final result = MapBoxResponse.fromJson(responseJson);
    expect(result.query, isEmpty);
    expect(result.features, hasLength(1));
    final feature = result.features.first;
    expect(feature.text, equals('Hötel de ville'));
    expect(feature.placeName, equals('8 Pl. de l\'Hôtel de Ville, 75004 Paris, France'));
    expect(feature.placeType, equals([PlaceType.poi]));
    expect(feature.center.latitude, closeTo(48.857163, 0.0001));
    expect(feature.center.longitude, closeTo(2.351499, 0.0001));
  });

  test('Should decode properties.context from Search Box retrieve response', () {
    // Mirrors the actual /retrieve response shape from the issue report.
    final responseJson = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {"coordinates": [4.396115, 50.81745958], "type": "Point"},
      "properties": {
        "name": "Silversquare Delta",
        "mapbox_id": "dXJuOm1ieHBvaTozZGZlMGJkOS1jZThkLTRkZGEtYjVjYi1lOTMyOGE3Y2JkZTc",
        "feature_type": "poi",
        "address": "Av. Arnaud Fraiteur 15/23",
        "full_address": "Av. Arnaud Fraiteur 15/23, 1050 Ixelles, Belgium",
        "place_formatted": "1050 Ixelles, Belgium",
        "context": {
          "country": {
            "id": "",
            "name": "Belgium",
            "country_code": "BE",
            "country_code_alpha_3": "BEL"
          },
          "postcode": {"id": "dXJuOm1ieHBsYzpyaFU", "name": "1050"},
          "place": {"id": "dXJuOm1ieHBsYzpJS2dW", "name": "Ixelles"},
          "locality": {"id": "dXJuOm1ieHBsYzpPV29W", "name": "Elsene"},
          "address": {
            "id": "",
            "name": "Av. Arnaud Fraiteur 15/23",
            "address_number": "15/23",
            "street_name": "av. arnaud fraiteur"
          },
          "street": {"id": "", "name": "av. arnaud fraiteur"}
        },
        "coordinates": {"latitude": 50.81745958, "longitude": 4.396115},
        "language": "en",
        "maki": "building-alt1",
        "poi_category": ["coworking space", "office"],
        "poi_category_ids": ["coworking_space", "office"],
        "external_ids": {},
        "metadata": {"wheelchair_accessible": true},
        "operational_status": "active"
      }
    }
  ],
  "attribution": "© 2026 Mapbox and its suppliers. All rights reserved."
}
''';
    final result = MapBoxResponse.fromJson(responseJson);
    expect(result.features, hasLength(1));
    final props = result.features.first.properties!;
    final ctx = props.context!;

    // country
    expect(ctx.country, isNotNull);
    expect(ctx.country!.name, equals('Belgium'));
    expect(ctx.country!.countryCode, equals('BE'));
    expect(ctx.country!.countryCodeAlpha3, equals('BEL'));

    // postcode
    expect(ctx.postcode, isNotNull);
    expect(ctx.postcode!.id, equals('dXJuOm1ieHBsYzpyaFU'));
    expect(ctx.postcode!.name, equals('1050'));

    // place
    expect(ctx.place, isNotNull);
    expect(ctx.place!.name, equals('Ixelles'));

    // locality
    expect(ctx.locality, isNotNull);
    expect(ctx.locality!.name, equals('Elsene'));

    // address
    expect(ctx.address, isNotNull);
    expect(ctx.address!.name, equals('Av. Arnaud Fraiteur 15/23'));
    expect(ctx.address!.addressNumber, equals('15/23'));
    expect(ctx.address!.streetName, equals('av. arnaud fraiteur'));

    // street
    expect(ctx.street, isNotNull);
    expect(ctx.street!.name, equals('av. arnaud fraiteur'));

    // absent entries should be null
    expect(ctx.region, isNull);
    expect(ctx.neighborhood, isNull);
  });

  group('SuggestResponse', () {
    test('Should decode /suggest response', () {
      final json = '''
{
  "suggestions": [
    {
      "mapbox_id": "dXJuOm1ieHBvaToxMjM0NTY",
      "name": "Starbucks",
      "address": "123 Main St",
      "full_address": "123 Main St, Seattle, WA 98101, United States",
      "place_formatted": "Seattle, Washington 98101, United States",
      "feature_type": "poi",
      "language": "en",
      "maki": "cafe",
      "poi_category": ["coffee", "cafe"]
    },
    {
      "mapbox_id": "dXJuOm1ieHBvaTp3eHl6",
      "name": "Starbucks Reserve",
      "full_address": "1124 Pike St, Seattle, WA 98101, United States",
      "place_formatted": "Seattle, Washington 98101, United States",
      "feature_type": "poi",
      "maki": "cafe",
      "poi_category": []
    }
  ],
  "attribution": "© 2026 Mapbox",
  "response_uuid": "abc-123"
}
''';
      final result = SuggestResponse.fromJson(json);
      expect(result.suggestions, hasLength(2));
      expect(result.attribution, equals('© 2026 Mapbox'));
      expect(result.responseUuid, equals('abc-123'));

      final first = result.suggestions.first;
      expect(first.mapboxId, equals('dXJuOm1ieHBvaToxMjM0NTY'));
      expect(first.name, equals('Starbucks'));
      expect(first.address, equals('123 Main St'));
      expect(first.fullAddress, equals('123 Main St, Seattle, WA 98101, United States'));
      expect(first.placeFormatted, equals('Seattle, Washington 98101, United States'));
      expect(first.featureType, equals('poi'));
      expect(first.language, equals('en'));
      expect(first.maki, equals('cafe'));
      expect(first.poiCategories, equals(['coffee', 'cafe']));

      final second = result.suggestions[1];
      expect(second.mapboxId, equals('dXJuOm1ieHBvaTp3eHl6'));
      expect(second.name, equals('Starbucks Reserve'));
      expect(second.address, isNull);
      expect(second.language, isNull);
      expect(second.poiCategories, isEmpty);
    });

    test('Should decode empty suggestions list', () {
      final json = '{"suggestions":[],"attribution":"© 2026 Mapbox","response_uuid":"uuid-1"}';
      final result = SuggestResponse.fromJson(json);
      expect(result.suggestions, isEmpty);
    });
  });

  group('SuggestQueryParams', () {
    test('toMap should include only non-null fields', () {
      const params = SuggestQueryParams(
        sessionToken: 'my-uuid',
        language: 'en',
        country: 'us',
        limit: 5,
      );
      final map = params.toMap();
      expect(map['language'], equals('en'));
      expect(map['country'], equals('us'));
      expect(map['limit'], equals('5'));
      expect(map['session_token'], equals('my-uuid'));
      expect(map.containsKey('proximity'), isFalse);
      expect(map.containsKey('types'), isFalse);
      expect(map.containsKey('poi_category'), isFalse);
    });

    test('toMap always includes session_token', () {
      const params = SuggestQueryParams(sessionToken: 'tok', language: 'fr');
      final map = params.toMap();
      expect(map['session_token'], equals('tok'));
    });

    test('toMap includes poi_category as comma-separated string', () {
      const params = SuggestQueryParams(
        sessionToken: 'tok',
        poiCategories: ['coffee_shop', 'cafe'],
      );
      final map = params.toMap();
      expect(map['poi_category'], equals('coffee_shop,cafe'));
    });

    test('toMap includes types as comma-separated names', () {
      const params = SuggestQueryParams(
        sessionToken: 'tok',
        types: [PlaceType.poi, PlaceType.place],
      );
      final map = params.toMap();
      expect(map['types'], equals('poi,place'));
    });

    test('toMap omits poi_category when empty list', () {
      const params = SuggestQueryParams(sessionToken: 'tok', poiCategories: []);
      final map = params.toMap();
      expect(map.containsKey('poi_category'), isFalse);
    });
  });
}
