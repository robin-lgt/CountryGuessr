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
    'GRL': 208, // Greenland -> Denmark
  };

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
      final polygons = _parseGeometry(geometry);
      if (polygons.isEmpty) continue;

      final centroid = _computeCentroid(polygons);
      countries.add(GeoCountry(id: id, name: name, polygons: polygons, centroid: centroid));
    }

    return countries;
  }

  static int? _extractId(Map<String, dynamic> feature, Map<String, dynamic> props) {
    // ISO_N3_EH is the most reliable field (always correct even for disputed territories)
    final isoN3Eh = props['ISO_N3_EH'];
    if (isoN3Eh != null) {
      final parsed = int.tryParse(isoN3Eh.toString());
      if (parsed != null && parsed > 0) return parsed;
    }

    // Try UN_A3
    final unA3 = props['UN_A3'];
    if (unA3 != null) {
      final parsed = int.tryParse(unA3.toString());
      if (parsed != null && parsed > 0) return parsed;
    }

    // Try ISO_N3
    final isoN3 = props['ISO_N3'] ?? props['iso_n3'];
    if (isoN3 != null) {
      final parsed = int.tryParse(isoN3.toString());
      if (parsed != null && parsed > 0) return parsed;
    }

    // Fallback: ISO_A3_EH -> hardcoded mapping
    final isoA3 = props['ISO_A3_EH'] ?? props['ISO_A3'] ?? props['ADM0_A3'];
    if (isoA3 != null && _iso3Fallback.containsKey(isoA3)) {
      return _iso3Fallback[isoA3];
    }

    // Last resort: feature id
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
    return Offset(sumX / count, sumY / count);
  }
}
