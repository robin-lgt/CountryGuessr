import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import 'country_layer.dart';
import 'map_layer.dart';

class InteractiveMap extends StatefulWidget {
  final List<MapLayer> layers;
  final MapThemeData mapTheme;
  final void Function(int countryId)? onCountryTap;

  const InteractiveMap({
    super.key,
    required this.layers,
    required this.mapTheme,
    this.onCountryTap,
  });

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InteractiveViewer(
          transformationController: _controller,
          minScale: 0.8,
          maxScale: 50.0,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: GestureDetector(
            onTapUp: _onTapUp,
            child: CustomPaint(
              painter: _MapPainter(
                layers: widget.layers,
                theme: widget.mapTheme,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          ),
        );
      },
    );
  }

  void _onTapUp(TapUpDetails details) {
    final transform = _controller.value;
    for (final layer in widget.layers) {
      if (!layer.visible) continue;
      final id = layer.hitTest(details.localPosition, transform);
      if (id != null) {
        widget.onCountryTap?.call(id);
        return;
      }
    }
  }
}

class _MapPainter extends CustomPainter {
  final List<MapLayer> layers;
  final MapThemeData theme;

  _MapPainter({
    required this.layers,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = theme.waterColor,
    );

    final identity = Matrix4.identity();
    for (final layer in layers) {
      if (layer.visible) {
        if (layer is CountryLayer) {
          layer.updatePaintedSize(size);
        }
        layer.paint(canvas, size, identity, theme);
      }
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) => true;
}
