import 'package:flutter/material.dart';
import '../theme/app_themes.dart';

abstract class MapLayer {
  bool visible;
  final String id;

  MapLayer({required this.id, this.visible = true});

  void paint(Canvas canvas, Size size, Matrix4 transform, MapThemeData theme);

  int? hitTest(Offset localPosition, Matrix4 transform);
}
