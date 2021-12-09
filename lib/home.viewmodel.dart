import 'package:congeo/conversion.usecase.dart';
import 'package:logger/logger.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:rxdart/rxdart.dart';

abstract class HomeViewmodel {
  // inputs
  BehaviorSubject<Point> get inputSourcePoint;
  BehaviorSubject<Projection> get sourceProjection;
  BehaviorSubject<Projection> get destinationProjection;
  // output
  BehaviorSubject<Point> get destinationPoint;
}

class HomeViewmodelImpl implements HomeViewmodel {
  final Logger _log = Logger();

  final BehaviorSubject<Point> _inputSourcePoint = BehaviorSubject<Point>();
  final BehaviorSubject<Point> _destinationPoint = BehaviorSubject<Point>();
  final BehaviorSubject<Projection> _srcProj = BehaviorSubject<Projection>();
  final BehaviorSubject<Projection> _dstProj = BehaviorSubject<Projection>();

  HomeViewmodelImpl() {
    Rx.combineLatest3(_srcProj, _dstProj, _inputSourcePoint, (a, b, c) {
      return a != b && a is Projection && b is Projection && c is Point;
    }).listen((event) {
      _log.d(event);
      if (event == true) {
        Point point = ConversionUsecase().convert(
          _srcProj.value,
          _dstProj.value,
          _inputSourcePoint.value,
        );
        _log.wtf(point);
        _destinationPoint.add(point);
      }
      // TODO fill an error stream
    });
  }

  // TODO disposal of dangling streams

  // inputs
  @override
  BehaviorSubject<Projection> get sourceProjection => _srcProj;

  @override
  BehaviorSubject<Projection> get destinationProjection => _dstProj;

  @override
  BehaviorSubject<Point> get inputSourcePoint => _inputSourcePoint;

  // outputs
  @override
  BehaviorSubject<Point> get destinationPoint => _destinationPoint;
}
