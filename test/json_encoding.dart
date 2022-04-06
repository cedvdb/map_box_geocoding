import 'package:map_box_geocoder/src/map_box_response.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Should decode json response', () {
    final responseJson = '''
{"type":"FeatureCollection","query":["pa"],"features":[{"id":"country.13545879598622050","type":"Feature","place_type":["country"],"relevance":1,"properties":{"wikidata":"Q55","short_code":"nl"},"text":"Netherlands","place_name":"Netherlands","matching_text":"Холандија","matching_place_name":"Холандија","bbox":[3.33390071158434,50.7503661060614,7.22749998189678,53.6436329908026],"center":[5.61349061168593,51.9724664894952],"geometry":{"type":"Point","coordinates":[5.61349061168593,51.9724664894952]}},{"id":"place.14749210607497330","type":"Feature","place_type":["region","place"],"relevance":1,"properties":{"short_code":"FR-75","wikidata":"Q90"},"text":"Paris","place_name":"Paris, France","bbox":[2.22422400085346,48.8156060108013,2.46976999462145,48.9020129995121],"center":[2.35183,48.85658],"geometry":{"type":"Point","coordinates":[2.35183,48.85658]},"context":[{"id":"country.19008108158641660","wikidata":"Q142","short_code":"fr","text":"France"}]},{"id":"region.13761801799111630","type":"Feature","place_type":["region"],"relevance":1,"properties":{"short_code":"US-PA","wikidata":"Q1400"},"text":"Pennsylvania","place_name":"Pennsylvania, United States","bbox":[-80.6176229,39.7197980002265,-74.6895010663323,42.4558884495783],"center":[-78.2907462468837,41.0911397651],"geometry":{"type":"Point","coordinates":[-78.2907462468837,41.0911397651]},"context":[{"id":"country.19678805456372290","wikidata":"Q30","short_code":"us","text":"United States"}]},{"id":"region.9882499685836130","type":"Feature","place_type":["region"],"relevance":1,"properties":{"short_code":"FR-76","wikidata":"Q12758"},"text":"Seine-Maritime","place_name":"Seine-Maritime, France","matching_text":"Pajūrio Sena","matching_place_name":"Pajūrio Sena, France","bbox":[-0.033835691006841,49.2509210000393,1.79060599958289,50.1213178852323],"center":[0.83333,49.66667],"geometry":{"type":"Point","coordinates":[0.83333,49.66667]},"context":[{"id":"country.19008108158641660","wikidata":"Q142","short_code":"fr","text":"France"}]},{"id":"locality.8740283744465570","type":"Feature","place_type":["locality"],"relevance":1,"properties":{"wikidata":"Q191066"},"text":"15th arrondissement of Paris","place_name":"15th arrondissement of Paris, Paris, France","matching_text":"Paris femtonde arrondissement","matching_place_name":"Paris femtonde arrondissement, Paris, France","bbox":[2.262685,48.825397,2.324717,48.858347],"center":[2.30029,48.84133],"geometry":{"type":"Point","coordinates":[2.30029,48.84133]},"context":[{"id":"place.14749210607497330","short_code":"FR-75","wikidata":"Q90","text":"Paris"},{"id":"country.19008108158641660","wikidata":"Q142","short_code":"fr","text":"France"}]}],"attribution":"NOTICE: © 2022 Mapbox and its suppliers. All rights reserved. Use of this data is subject to the Mapbox Terms of Service (https://www.mapbox.com/about/maps/). This response and the information it contains may not be retained. POI(s) provided by Foursquare."}
''';
    MapBoxResponse.fromJson(responseJson);
  });
}
