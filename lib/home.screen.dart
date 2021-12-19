import 'package:congeo/coordinate-system.entity.dart';
import 'package:congeo/home.viewmodel.dart';
import 'package:congeo/widget/angle-input.widget.dart';
import 'package:congeo/widget/fluttermap.widget.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:proj4dart/proj4dart.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  final Logger _log = Logger();
  final HomeViewmodel _viewmodel = HomeViewmodelImpl();

  HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: _viewmodel.latLngSourcePoint,
              builder: (context, AsyncSnapshot<LatLng> snapshot) =>
                  FlutterMapWidget(point: snapshot.data),
            ),
          ),
          Expanded(
            flex: 3,
            // CONVERSION PANEL
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(12.0),
                  elevation: 4.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // SOURCE CONVERSION PANEL
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.white, Colors.blue],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 12.0, 8.0, 8.0),
                                child: AngleInputWidget(viewmodel: _viewmodel),
                              ),
                              StreamBuilder<CoordinateSystem>(
                                stream: _viewmodel.sourceProjection,
                                builder: (context,
                                    AsyncSnapshot<CoordinateSystem> snapshot) {
                                  return DropdownButton<CoordinateSystem>(
                                    hint: const Text(
                                      'Source coordinate system',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: snapshot.data,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onChanged: (CoordinateSystem? newValue) {
                                      _log.d(newValue?.projection);
                                      if (newValue != null) {
                                        _viewmodel.sourceProjection
                                            .add(newValue);
                                      }
                                    },
                                    items: allCoords.map<
                                            DropdownMenuItem<CoordinateSystem>>(
                                        (CoordinateSystem cs) {
                                      return DropdownMenuItem<CoordinateSystem>(
                                        value: cs,
                                        child: Text(
                                          cs.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // DESTINATION CONVERSION PANEL
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StreamBuilder<CoordinateSystem>(
                                stream: _viewmodel.destinationProjection,
                                builder: (context,
                                    AsyncSnapshot<CoordinateSystem> snapshot) {
                                  return DropdownButton<CoordinateSystem>(
                                    hint: const Text(
                                      'Target coordinate system',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: snapshot.data,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onChanged: (CoordinateSystem? newValue) {
                                      _log.d(newValue?.projection);
                                      if (newValue != null) {
                                        _viewmodel.destinationProjection
                                            .add(newValue);
                                      }
                                    },
                                    items: allCoords.map<
                                            DropdownMenuItem<CoordinateSystem>>(
                                        (CoordinateSystem cs) {
                                      return DropdownMenuItem<CoordinateSystem>(
                                        value: cs,
                                        child: Text(
                                          cs.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 12.0, 8.0, 8.0),
                                child: StreamBuilder(
                                  stream: _viewmodel.destinationPoint,
                                  builder:
                                      (context, AsyncSnapshot<Point> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.active:
                                        if (snapshot.hasData) {
                                          Point result = snapshot.data!;
                                          return Text(
                                              'x: ${result.x} | y: ${result.y}');
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                        return const Text('Unknow error');
                                      case ConnectionState.waiting:
                                        return const Text(
                                            'Not ready to convert yet.');
                                      default:
                                        return const Text('Unknown state');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  child: Icon(
                    Icons.compare_arrows,
                    size: 24.0,
                  ),
                  left: 42.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
