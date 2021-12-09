import 'package:proj4dart/proj4dart.dart';

/// Converts between geo coordinates that we can obtain from here:
/// {@link http://epsg.io/4326} with the PROJ.4 definition that we can input
/// into the [Projection] from proj4dart.
class ConversionUsecase {
  Point convert(Projection src, Projection dst, Point srcPoint) {
    return src.transform(dst, srcPoint);
  }

  Point latlon2google(Point srcPoint) {
    return convert(Projection.WGS84, Projection.GOOGLE, srcPoint);
  }

  Point google2latlon(Point srcPoint) {
    return convert(Projection.GOOGLE, Projection.WGS84, srcPoint);
  }
}
