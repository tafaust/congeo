import 'package:proj4dart/proj4dart.dart';

List<CoordinateSystem> allCoords = [
  CoordinateSystem(
    epsgCode: 'EPSG:4088',
    name: 'World Equidistant Cylindrical',
    description:
        'Uses spherical development. It is not a recognised geodetic system. Relative to an ellipsoidal development (see WGS 84 / World Equidistant Cylindrical (CRS code 4087)) errors of up to 800 metres in position and 0.7% in scale may arise. ',
    unit: 'meter',
  ),
  CoordinateSystem(
    epsgCode: 'EPSG:4087',
    name: 'WGS 84 / World Equidistant Cylindrical',
    description:
        'Origin is at intersection of equator and Greenwich meridian. Note: this is not the same as plotting unrectified graticule coordinates on a computer display using the so-called pseudo Plate Carrée method: here the grid units are metres.',
    unit: 'meter',
  ),
  CoordinateSystem(
    epsgCode: 'EPSG:4326',
    name: 'WGS 84',
    description:
        'Horizontal component of 3D system. Used by the GPS satellite navigation system and for NATO military geodetic surveying. ',
    unit: 'degree',
  ),
  CoordinateSystem(
    epsgCode: 'EPSG:3395',
    name: 'WGS 84 / World Mercator',
    description: 'Euro-centric view of world excluding polar areas.',
    unit: 'meter',
  ),
  CoordinateSystem(
    epsgCode: 'EPSG:6893',
    name: 'WGS 84 / World Mercator + EGM2008 height',
    description:
        'Visualisation of initial concept in civil engineering design.',
    unit: 'meter',
  ),
  CoordinateSystem(
    epsgCode: 'EPSG:3857',
    name: 'WGS 84 / Pseudo-Mercator',
    description:
        'Uses spherical development of ellipsoidal coordinates. Relative to WGS 84 / World Mercator (CRS code 3395) errors of 0.7 percent in scale and differences in northing of up to 43km in the map (equivalent to 21km on the ground) may arise. ',
    unit: 'meter',
  ),
  CoordinateSystem(
    epsgCode: 'EPSG:7789',
    name: 'International Terrestrial Reference Frame 2014',
    description: 'TODO',
    unit: 'meter',
  ),
]
    .where((CoordinateSystem coord) => Projection.get(coord.epsgCode) != null)
    .toList();

class CoordinateSystem {
  final String epsgCode;
  final String name;
  final String description;
  final String unit;
  late final Projection? projection;

  CoordinateSystem({
    required this.epsgCode,
    required this.name,
    required this.description,
    required this.unit,
    projection,
  }) {
    this.projection = projection ?? Projection.get(epsgCode);
  }
}
