import 'dart:math';
import 'dart:ui';

class Projection {
  static const double _maxLat = 85.0;
  static const double _minLon = -180.0;
  static const double _maxLon = 190.0;
  static const double _lonRange = _maxLon - _minLon;
  static final double _maxMercN = log(tan(pi / 4 + (_maxLat * pi / 180) / 2));
  static double get aspectRatio => (2 * _maxMercN * (180 / pi)) / _lonRange;

  Offset project(Offset lonLat, Size size) {
    final lon = lonLat.dx;
    final lat = lonLat.dy.clamp(-_maxLat, _maxLat);
    final x = (lon - _minLon) / _lonRange * size.width;
    final latRad = lat * pi / 180;
    final mercN = log(tan(pi / 4 + latRad / 2));
    final y = (1 - (mercN / _maxMercN + 1) / 2) * size.height;
    return Offset(x, y);
  }
}
