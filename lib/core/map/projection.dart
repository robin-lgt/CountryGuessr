import 'dart:math';
import 'dart:ui';

class Projection {
  static const double _maxLat = 85.0;

  Offset project(Offset lonLat, Size size) {
    final lon = lonLat.dx;
    final lat = lonLat.dy.clamp(-_maxLat, _maxLat);

    final x = (lon + 180) / 360 * size.width;

    final latRad = lat * pi / 180;
    final mercN = log(tan(pi / 4 + latRad / 2));
    final maxMercN = log(tan(pi / 4 + (_maxLat * pi / 180) / 2));
    final y = size.height / 2 - (mercN / maxMercN) * (size.height / 2);

    return Offset(x, y);
  }

  Offset unproject(Offset point, Size size) {
    final lon = point.dx / size.width * 360 - 180;

    final maxMercN = log(tan(pi / 4 + (_maxLat * pi / 180) / 2));
    final mercN = (size.height / 2 - point.dy) / (size.height / 2) * maxMercN;
    final lat = (2 * atan(exp(mercN)) - pi / 2) * 180 / pi;

    return Offset(lon, lat);
  }
}
