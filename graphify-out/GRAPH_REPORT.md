# Graph Report - .  (2026-08-08)

## Corpus Check
- Corpus is ~7,101 words - fits in a single context window. You may not need a graph.

## Summary
- 247 nodes · 265 edges · 21 communities (18 shown, 3 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 6 edges (avg confidence: 0.92)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Country Layer Rendering
- App Icons & Assets
- Game Logic & State
- Map Widget & Interaction
- Home Screen & Navigation
- Flutter Framework Core
- Theme & Color System
- Map Controller & Data Loading
- GeoJSON Parser
- CI/CD Pipeline
- Web Manifest Config
- Map Projection
- Country Data Store
- iOS Launch Images
- Android Main Activity
- Widget Testing
- iOS Launch Screen Docs

## God Nodes (most connected - your core abstractions)
1. `Flutter Default App Icon` - 26 edges
2. `CountryGuessr Flutter Project` - 9 edges
3. `AppDelegate` - 5 edges
4. `Build & Distribute CI Pipeline` - 4 edges
5. `Flutter Default Launch Image (Blank White)` - 4 edges
6. `Flutter` - 3 edges
7. `RunnerTests` - 3 edges
8. `CountryLayer` - 3 edges
9. `MapController` - 3 edges
10. `InteractiveMap` - 3 edges

## Surprising Connections (you probably didn't know these)
- `Flutter APK Build Step` --references--> `CountryGuessr Flutter Project`  [INFERRED]
  .github/workflows/build-and-distribute.yml → pubspec.yaml
- `CountryGuessr README` --references--> `CountryGuessr Flutter Project`  [INFERRED]
  README.md → pubspec.yaml
- `Web Entry Point (index.html)` --implements--> `CountryGuessr Flutter Project`  [INFERRED]
  web/index.html → pubspec.yaml
- `Flutter Default App Icon` --coexists_with--> `Flutter Default Launch Image (Blank White)`  [INFERRED]
  android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png → ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png
- `iOS App Icon 1024x1024` --is_density_variant_of--> `Flutter Default App Icon`  [EXTRACTED]
  ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png → android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **CI/CD Build and Distribution Pipeline** — _github_workflows_build_and_distribute_yml_ci_pipeline, _github_workflows_build_and_distribute_yml_flutter_action, _github_workflows_build_and_distribute_yml_flutter_build_apk, _github_workflows_build_and_distribute_yml_google_auth, _github_workflows_build_and_distribute_yml_firebase_app_distribution [EXTRACTED 1.00]
- **Project Dependencies** — pubspec_yaml_country_guessr, pubspec_yaml_flutter_sdk, pubspec_yaml_cupertino_icons, pubspec_yaml_flutter_lints, pubspec_yaml_dart_sdk_constraint [EXTRACTED 1.00]
- **Multi-Platform Deployment Targets** — web_index_html_entry, ios_runner_assets_xcassets_launchimage_imageset_readme_md_launch_screen, _github_workflows_build_and_distribute_yml_flutter_build_apk [INFERRED 0.85]

## Communities (21 total, 3 thin omitted)

### Community 0 - "Country Layer Rendering"
Cohesion: 0.07
Nodes (27): int?, _buildPath, _colorForCountry, correctIds, countries, CountryLayer, _getBounds, highlightedId (+19 more)

### Community 1 - "App Icons & Assets"
Cohesion: 0.08
Nodes (26): Android App Icon hdpi, Android App Icon mdpi, Android App Icon xhdpi, Android App Icon xxhdpi, Android App Icon xxxhdpi, Flutter Default App Icon, iOS App Icon 1024x1024, iOS App Icon 20x20 1x (+18 more)

### Community 2 - "Game Logic & State"
Cohesion: 0.09
Nodes (22): ../../core/data/country_data.dart, ../../core/map/map_controller.dart, ../../core/map/map_widget.dart, build, _buildGameOver, _buildHud, _buildQueue, createState (+14 more)

### Community 3 - "Map Widget & Interaction"
Cohesion: 0.10
Nodes (21): country_layer.dart, CustomPainter, build, _controller, createState, dispose, InteractiveMap, _InteractiveMapState (+13 more)

### Community 4 - "Home Screen & Navigation"
Cohesion: 0.10
Nodes (19): core/theme/app_themes.dart, features/home/home_screen.dart, ../game/game_screen.dart, IconData, build, HomeScreen, icon, label (+11 more)

### Community 5 - "Flutter Framework Core"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 6 - "Theme & Color System"
Cohesion: 0.11
Nodes (17): Color, AppThemes, background, capitalMarker, correctFill, countryBorder, countryFill, dark (+9 more)

### Community 7 - "Map Controller & Data Loading"
Cohesion: 0.12
Nodes (16): ChangeNotifier, CountryLayer get, geo_parser.dart, _countryLayer, getCountryName, highlight, layers, loadGeoData (+8 more)

### Community 8 - "GeoJSON Parser"
Cohesion: 0.12
Nodes (16): dart:convert, centroid, _computeCentroid, _extractId, GeoCountry, GeoParser, id, _iso3Fallback (+8 more)

### Community 9 - "CI/CD Pipeline"
Cohesion: 0.15
Nodes (15): Build & Distribute CI Pipeline, Firebase App Distribution, Flutter GitHub Action (subosito/flutter-action@v2), Flutter APK Build Step, Google Cloud Auth Action, Dart Analysis Options Configuration, CountryGuessr Flutter Project, Cupertino Icons Package (+7 more)

### Community 10 - "Web Manifest Config"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 11 - "Map Projection"
Cohesion: 0.25
Nodes (7): dart:math, dart:ui, _maxLat, project, Projection, unproject, static const double

### Community 12 - "Country Data Store"
Cohesion: 0.40
Nodes (4): continents, CountryData, names, static const Map

### Community 13 - "iOS Launch Images"
Cohesion: 0.50
Nodes (4): Flutter Default Launch Image (Blank White), iOS Launch Image 1x, iOS Launch Image 2x, iOS Launch Image 3x

## Knowledge Gaps
- **146 isolated node(s):** `XCTest`, `CountryData`, `names`, `continents`, `countries` (+141 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Flutter Default App Icon` connect `App Icons & Assets` to `iOS Launch Images`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `MapThemeData` connect `Theme & Color System` to `Map Widget & Interaction`, `Map Controller & Data Loading`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `MapController` connect `Map Controller & Data Loading` to `Game Logic & State`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `CountryGuessr Flutter Project` (e.g. with `Flutter APK Build Step` and `CountryGuessr README`) actually correct?**
  _`CountryGuessr Flutter Project` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `CountryData`, `names` to the rest of the system?**
  _146 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Country Layer Rendering` be split into smaller, more focused modules?**
  _Cohesion score 0.07389162561576355 - nodes in this community are weakly interconnected._
- **Should `App Icons & Assets` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._