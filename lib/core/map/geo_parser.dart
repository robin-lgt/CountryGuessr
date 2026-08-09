import 'dart:convert';
import 'dart:ui';

class GeoCountry {
  final int id;
  final String name;
  final List<List<Offset>> polygons;
  final Offset centroid;

  GeoCountry({required this.id, required this.name, required this.polygons, required this.centroid});
}

class GeoParser {
  static const _iso3Fallback = {
    'FRA': 250, 'NOR': 578, 'XKX': 383, 'KOS': 383,
    'GRL': 208,
  };

  // Pacific islands that should appear on the right side of the map
  static const _pacificWrapIds = {242, 776, 882, 548, 90}; // Fiji, Tonga, Samoa, Vanuatu, Solomon

  static List<GeoCountry> parseGeoJson(String jsonString, Map<String, String> countryNames) {
    final data = json.decode(jsonString);
    final features = data['features'] as List;
    final countries = <GeoCountry>[];

    for (final feature in features) {
      final props = feature['properties'] as Map<String, dynamic>? ?? {};
      final id = _extractId(feature, props);
      if (id == null) continue;

      final name = countryNames[id.toString()];
      if (name == null) continue;

      final geometry = feature['geometry'];
      var polygons = _parseGeometry(geometry);
      if (polygons.isEmpty) continue;

      // For Pacific islands, shift negative longitudes to right side
      if (_pacificWrapIds.contains(id)) {
        polygons = polygons.map((ring) => ring.map((p) {
          return p.dx < 0 ? Offset(p.dx + 360, p.dy) : p;
        }).toList()).toList();
      } else {
        // For other countries, split polygons crossing antimeridian
        final fixed = <List<Offset>>[];
        for (final ring in polygons) {
          fixed.addAll(_fixAntimeridian(ring));
        }
        polygons = fixed;
      }

      final centroid = _computeCentroid(polygons);
      countries.add(GeoCountry(id: id, name: name, polygons: polygons, centroid: centroid));
    }

    return countries;
  }

  static int? _extractId(Map<String, dynamic> feature, Map<String, dynamic> props) {
    final isoN3Eh = props['ISO_N3_EH'];
    if (isoN3Eh != null) {
      final parsed = int.tryParse(isoN3Eh.toString());
      if (parsed != null && parsed > 0) return parsed;
    }
    final unA3 = props['UN_A3'];
    if (unA3 != null) {
      final parsed = int.tryParse(unA3.toString());
      if (parsed != null && parsed > 0) return parsed;
    }
    final isoN3 = props['ISO_N3'] ?? props['iso_n3'];
    if (isoN3 != null) {
      final parsed = int.tryParse(isoN3.toString());
      if (parsed != null && parsed > 0) return parsed;
    }
    final isoA3 = props['ISO_A3_EH'] ?? props['ISO_A3'] ?? props['ADM0_A3'];
    if (isoA3 != null && _iso3Fallback.containsKey(isoA3)) {
      return _iso3Fallback[isoA3];
    }
    final rawId = feature['id'] ?? props['id'];
    if (rawId == null) return null;
    final parsed = int.tryParse(rawId.toString());
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  static List<List<Offset>> _parseGeometry(Map<String, dynamic> geometry) {
    final type = geometry['type'] as String;
    final coords = geometry['coordinates'];
    final polygons = <List<Offset>>[];
    if (type == 'Polygon') {
      for (final ring in coords) {
        polygons.add(_parseRing(ring));
      }
    } else if (type == 'MultiPolygon') {
      for (final polygon in coords) {
        for (final ring in polygon) {
          polygons.add(_parseRing(ring));
        }
      }
    }
    return polygons;
  }

  static List<Offset> _parseRing(List<dynamic> ring) {
    return ring.map<Offset>((point) {
      final lon = (point[0] as num).toDouble();
      final lat = (point[1] as num).toDouble();
      return Offset(lon, lat);
    }).toList();
  }

  static List<List<Offset>> _fixAntimeridian(List<Offset> ring) {
    if (ring.length < 3) return [ring];
    bool crosses = false;
    for (int i = 0; i < ring.length - 1; i++) {
      if ((ring[i + 1].dx - ring[i].dx).abs() > 180) {
        crosses = true;
        break;
      }
    }
    if (!crosses) return [ring];

    final left = <Offset>[];
    final right = <Offset>[];
    for (final p in ring) {
      if (p.dx < 0) {
        left.add(p);
      } else {
        right.add(p);
      }
    }
    final result = <List<Offset>>[];
    if (left.length >= 3) result.add(left);
    if (right.length >= 3) result.add(right);
    return result.isEmpty ? [ring] : result;
  }

  static Offset _computeCentroid(List<List<Offset>> polygons) {
    double sumX = 0, sumY = 0;
    int count = 0;
    for (final poly in polygons) {
      for (final p in poly) {
        sumX += p.dx;
        sumY += p.dy;
        count++;
      }
    }
    if (count == 0) return Offset.zero;
    return Offset(sumX / count, sumY / count);
  }
}
