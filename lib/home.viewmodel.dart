import 'package:congeo/conversion.usecase.dart';
import 'package:congeo/coordinate-system.entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:rxdart/rxdart.dart';

abstract class HomeViewmodel {
  // inputs
  BehaviorSubject<Point> get inputSourcePoint;
  BehaviorSubject<CoordinateSystem> get sourceProjection;
  BehaviorSubject<CoordinateSystem> get destinationProjection;
  // output
  BehaviorSubject<LatLng> get latLngSourcePoint;
  BehaviorSubject<Point> get destinationPoint;
}

class HomeViewmodelImpl implements HomeViewmodel {
  final Logger _log = Logger();

  final BehaviorSubject<Point> _sourcePoint = BehaviorSubject<Point>();
  final BehaviorSubject<LatLng> _latLngSourcePoint = BehaviorSubject<LatLng>();
  final BehaviorSubject<Point> _destinationPoint = BehaviorSubject<Point>();
  final BehaviorSubject<CoordinateSystem> _sourceProjection =
      BehaviorSubject<CoordinateSystem>();
  final BehaviorSubject<CoordinateSystem> _destinationProjection =
      BehaviorSubject<CoordinateSystem>();

  /// Initiates all use cases based on its stream {in,out}puts.
  HomeViewmodelImpl() {
    // input point + {in,out}put transformation → conversion!
    populateConvertedPoint();
    // input point + input transformation → set location pin on map
    populateMapLocationPin();
  }

  void populateConvertedPoint() {
    // input point + {in,out}put transformation → conversion!
    Rx.combineLatest3(
      _sourceProjection,
      _destinationProjection,
      _sourcePoint,
      (a, b, c) =>
          // a != b &&
          a is CoordinateSystem &&
          a.projection != null &&
          b is CoordinateSystem &&
          b.projection != null &&
          c is Point,
    ).listen((event) {
      if (event == true) {
        _log.d('We are converting!');
        Point point = ConversionUsecase().convert(
          _sourceProjection.value.projection!,
          _destinationProjection.value.projection!,
          _sourcePoint.value,
        );
        _destinationPoint.add(point);
      }
      /*
      else {
        _log.d('We are not converting... :(');
        String message;
        if (_sourceProjection.value.projection is! Projection) {
          message = 'Select a source coordinate system.';
        } else if (_sourcePoint.value is! Point) {
          message = 'Select a source coordinate.';
        } else if (_destinationProjection.value.projection is! Projection) {
          message = 'Select a destination coordinate system.';
        } else {
          message = 'An unknown error occurred!';
        }
        // TODO introduce a [ConversionResult] entity for the output stream that holds a point and a message
        _destinationPoint.addError(message);
      }
       */
    });
  }

  void populateMapLocationPin() {
    // input point + input transformation → set location pin on map
    Rx.combineLatest2(
      _sourceProjection,
      _sourcePoint,
      (a, b) => a is CoordinateSystem && a.projection != null && b is Point,
    ).listen((event) {
      _log.d(event ? 'Positioning location pin!' : 'Location pin dead! x.x');
      // convert from _srcProj to WGS84
      Point point = ConversionUsecase().convert(
          _sourceProjection.value.projection!,
          Projection.WGS84,
          _sourcePoint.value);
      _latLngSourcePoint.add(LatLng(point.x, point.y));
    });
  }

  // TODO disposal of dangling streams

  // inputs
  @override
  BehaviorSubject<CoordinateSystem> get sourceProjection => _sourceProjection;

  @override
  BehaviorSubject<CoordinateSystem> get destinationProjection =>
      _destinationProjection;

  @override
  BehaviorSubject<Point> get inputSourcePoint => _sourcePoint;

  // outputs
  @override
  BehaviorSubject<LatLng> get latLngSourcePoint => _latLngSourcePoint;

  @override
  BehaviorSubject<Point> get destinationPoint => _destinationPoint;
}
