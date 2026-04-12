# map_box_geocoder

A Dart/Flutter wrapper around the [Mapbox Geocoding](https://docs.mapbox.com/api/search/geocoding/) and [Mapbox Search Box](https://docs.mapbox.com/api/search/search-box/) APIs.

## Features

- **Forward geocoding** – convert a place name or address into geographic coordinates.
- **Reverse geocoding** – convert coordinates into a human-readable place name.
- **Search Box forward search** – search with POI category filtering via the newer Search Box API.
- **Autocomplete (suggest / retrieve)** – keystroke-by-keystroke suggestions with session-based billing.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  map_box_geocoder: ^2.0.0
```

Then run:

```sh
flutter pub get
# or, for pure Dart projects:
dart pub get
```

## Usage

This package exposes two focused API clients that mirror Mapbox's own API structure:

| Class | Mapbox API | Methods |
|-------|-----------|---------|
| `MapBoxGeocoding` | [Geocoding API](https://docs.mapbox.com/api/search/geocoding/) | `forwardSearch`, `reverseSearch` |
| `MapBoxSearchBox` | [Search Box API](https://docs.mapbox.com/api/search/search-box/) | `forward`, `suggest`, `retrieve` |

You can use them directly or through the `MapBoxGeocoder` facade.

### Using the facade

```dart
import 'package:map_box_geocoder/map_box_geocoder.dart';

final geocoder = MapBoxGeocoder('YOUR_MAPBOX_ACCESS_TOKEN');

// Legacy Geocoding API
final result = await geocoder.geocoding.forwardSearch('Paris, France');

// Search Box API
final suggestions = await geocoder.searchBox.suggest(
  'Eiffel',
  params: SuggestQueryParams(sessionToken: mySessionToken, language: 'en'),
);
```

### Using the clients directly

```dart
import 'package:map_box_geocoder/map_box_geocoder.dart';

final geocoding = MapBoxGeocoding('YOUR_MAPBOX_ACCESS_TOKEN');
final searchBox = MapBoxSearchBox('YOUR_MAPBOX_ACCESS_TOKEN');
```

---

### Forward geocoding

Convert a place name / address string into geographic coordinates.

```dart
final response = await geocoding.forwardSearch(
  'Paris, France',
  params: ForwardQueryParams(
    language: 'en',
    limit: 5,
  ),
);

for (final feature in response.features) {
  print('${feature.placeName} → ${feature.center}');
}
```

**`ForwardQueryParams` options**

| Parameter | Type | Description |
|-----------|------|-------------|
| `autocomplete` | `bool?` | Enable autocomplete behaviour (default: `true`). |
| `bbox` | `List<double>?` | Bounding box `[minLon, minLat, maxLon, maxLat]` to restrict results. |
| `country` | `String?` | ISO 3166-1 alpha-2 country code(s) to restrict results. |
| `fuzzyMatch` | `bool?` | Enable fuzzy-matching for typo tolerance (default: `true`). |
| `language` | `String?` | IETF language tag for response text (e.g. `'en'`, `'fr'`). |
| `limit` | `int?` | Maximum number of results (1–10, default: `5`). |
| `proximity` | `LatLon?` | Bias results toward a specific location. |
| `routing` | `bool?` | Include routable points in the response. |
| `types` | `List<PlaceType>?` | Filter by place type (e.g. `[PlaceType.country, PlaceType.place]`). |
| `worldview` | `String?` | Returns features for a specific worldview (e.g. `'cn'`, `'us'`). |

---

### Reverse geocoding

Convert geographic coordinates into a human-readable place name.

```dart
final response = await geocoding.reverseSearch(
  LatLon(48.8566, 2.3522), // latitude, longitude
  params: ReverseQueryParams(
    language: 'en',
    types: [PlaceType.place],
  ),
);

for (final feature in response.features) {
  print(feature.placeName);
}
```

**`ReverseQueryParams` options**

| Parameter | Type | Description |
|-----------|------|-------------|
| `country` | `String?` | ISO 3166-1 alpha-2 country code(s) to restrict results. |
| `language` | `String?` | IETF language tag for response text. |
| `limit` | `int?` | Maximum number of results (1–5, default: `1`). |
| `routing` | `bool?` | Include routable points in the response. |
| `types` | `List<PlaceType>?` | Filter by place type. |
| `worldview` | `String?` | Returns features for a specific worldview. |
| `reverseMode` | `ReverseMode?` | `ReverseMode.distance` (default) or `ReverseMode.score`. |

---

### Search Box forward search

Uses the newer [Mapbox Search Box API](https://docs.mapbox.com/api/search/search-box/) which supports POI category filtering.

```dart
final response = await searchBox.forward(
  'coffee shop',
  params: SearchBoxQueryParams(
    proximity: LatLon(48.8566, 2.3522),
    poiCategories: ['coffee_shop'],
    limit: 10,
  ),
);

for (final feature in response.features) {
  print('${feature.text} – ${feature.placeName}');
}
```

**`SearchBoxQueryParams` options**

| Parameter | Type | Description |
|-----------|------|-------------|
| `language` | `String?` | IETF language tag for response text. |
| `country` | `String?` | ISO 3166-1 alpha-2 country code(s) to restrict results. |
| `limit` | `int?` | Maximum number of results (1–10). |
| `proximity` | `LatLon?` | Bias results toward a specific location. |
| `types` | `List<PlaceType>?` | Filter by place type. |
| `poiCategories` | `List<String>?` | Filter by POI category (e.g. `['restaurant', 'cafe']`). |

---

### Autocomplete – suggest & retrieve

Use `suggest` for keystroke-by-keystroke suggestions (lightweight, no geometry), then `retrieve` to get the full feature once the user selects a result. Grouping both calls under the same `sessionToken` (a random UUID) counts as a single billable Mapbox session.

```dart
import 'package:uuid/uuid.dart'; // any UUID generator

final sessionToken = const Uuid().v4();

// 1. Get suggestions as the user types
final suggestResponse = await searchBox.suggest(
  'Eiffel',
  params: SuggestQueryParams(
    sessionToken: sessionToken,
    language: 'en',
    limit: 5,
  ),
);

for (final suggestion in suggestResponse.suggestions) {
  print('${suggestion.name} – ${suggestion.placeFormatted}');
}

// 2. Retrieve full feature after the user picks a suggestion
final mapboxId = suggestResponse.suggestions.first.mapboxId;
final fullResponse = await searchBox.retrieve(
  mapboxId,
  sessionToken: sessionToken,
);

print(fullResponse.features.first.center);
```

**`SuggestQueryParams` options**

| Parameter | Type | Description |
|-----------|------|-------------|
| `sessionToken` | `String` | **Required.** A stable UUID grouping suggest + retrieve into one billing session. |
| `language` | `String?` | IETF language tag for response text. |
| `country` | `String?` | ISO 3166-1 alpha-2 country code(s) to restrict results. |
| `limit` | `int?` | Maximum number of suggestions (1–10). |
| `proximity` | `LatLon?` | Bias results toward a specific location. |
| `types` | `List<PlaceType>?` | Filter by place type. |
| `poiCategories` | `List<String>?` | Filter by POI category. |

---

### PlaceType values

`PlaceType.country`, `PlaceType.region`, `PlaceType.postcode`, `PlaceType.district`, `PlaceType.place`, `PlaceType.locality`, `PlaceType.neighborhood`, `PlaceType.address`, `PlaceType.poi`

---

## Response structure

Both `forwardSearch`, `reverseSearch`, `forward`, and `retrieve` return a `MapBoxResponse`:

```
MapBoxResponse
 ├── type: String
 ├── query: List<dynamic>
 ├── attribution: String
 └── features: List<Feature>
       ├── id: String
       ├── type: String
       ├── placeType: List<PlaceType>
       ├── relevance: double
       ├── text: String           // short name (e.g. "Paris")
       ├── placeName: String      // full name (e.g. "Paris, France")
       ├── center: LatLon
       ├── geometry: Geometry
       ├── bbox: List<double>?
       ├── address: String?
       ├── context: List<Context>
       └── properties: Properties?
```

`suggest` returns a `SuggestResponse`:

```
SuggestResponse
 ├── attribution: String
 ├── responseUuid: String
 └── suggestions: List<MapBoxSuggestion>
       ├── mapboxId: String
       ├── name: String
       ├── address: String?
       ├── fullAddress: String?
       ├── placeFormatted: String?
       ├── featureType: String
       ├── language: String?
       ├── maki: String?
       └── poiCategories: List<String>
```

## Additional resources

- [Mapbox Geocoding API docs](https://docs.mapbox.com/api/search/geocoding/)
- [Mapbox Search Box API docs](https://docs.mapbox.com/api/search/search-box/)
- [Mapbox access tokens](https://docs.mapbox.com/help/getting-started/access-tokens/)
