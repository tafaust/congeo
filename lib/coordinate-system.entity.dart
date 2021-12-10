import 'package:proj4dart/proj4dart.dart';

List<CoordinateSystem> allCoords = [
  CoordinateSystem(
      epsgCode: 'EPSG:4326',
      name: 'World Geodetic System 84',
      description: 'Used for GPS and stuff.',
      proj4: null),
  CoordinateSystem(
      epsgCode: 'EPSG:3857',
      name: 'Web Mercator Projection',
      description: 'TODO',
      proj4: null),
  CoordinateSystem(
      epsgCode: 'EPSG:7789',
      name: 'International Terrestrial Reference Frame 2014',
      description: 'TODO',
      proj4: null),
]
    .where((CoordinateSystem coord) => Projection.get(coord.epsgCode) != null)
    .toList();

class CoordinateSystem {
  final String epsgCode;
  final String name;
  final String description;
  final String? proj4;
  late final Projection projection;

  CoordinateSystem({
    required this.epsgCode,
    required this.name,
    required this.description,
    required this.proj4,
  }) {
    // TODO refactor code so that I don't have to vomit looking at this
    Projection? p = Projection.get(epsgCode);
    if (p == null && proj4 != null) {
      p = Projection.parse(proj4!);
    }
    projection = p!;
  }
}
