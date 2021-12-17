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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300.0,
            child: StreamBuilder(
              stream: _viewmodel.latLngSourcePoint,
              builder: (context, AsyncSnapshot<LatLng> snapshot) =>
                  FlutterMapWidget(point: snapshot.data),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                StreamBuilder<CoordinateSystem>(
                  stream: _viewmodel.sourceProjection,
                  builder: (context, AsyncSnapshot<CoordinateSystem> snapshot) {
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
                          _viewmodel.sourceProjection.add(newValue);
                        }
                      },
                      items: allCoords.map<DropdownMenuItem<CoordinateSystem>>(
                          (CoordinateSystem cs) {
                        return DropdownMenuItem<CoordinateSystem>(
                          value: cs,
                          child: SizedBox(
                              width: 200.0,
                              child: Text(
                                cs.name,
                                overflow: TextOverflow.ellipsis,
                              )),
                        );
                      }).toList(),
                    );
                  },
                ),
                const Icon(Icons.arrow_right_alt),
                StreamBuilder<CoordinateSystem>(
                  stream: _viewmodel.destinationProjection,
                  builder: (context, AsyncSnapshot<CoordinateSystem> snapshot) {
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
                          _viewmodel.destinationProjection.add(newValue);
                        }
                      },
                      items: allCoords.map<DropdownMenuItem<CoordinateSystem>>(
                          (CoordinateSystem cs) {
                        return DropdownMenuItem<CoordinateSystem>(
                          value: cs,
                          child: SizedBox(
                              width: 200.0,
                              child: Text(
                                cs.name,
                                overflow: TextOverflow.ellipsis,
                              )),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          // const Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
            child: AngleInputWidget(viewmodel: _viewmodel),
          ),
          const Divider(),
          StreamBuilder(
            stream: _viewmodel.destinationPoint,
            builder: (context, AsyncSnapshot<Point> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  return Text('Result: ${snapshot.data}');
                case ConnectionState.waiting:
                  return const Text('Not ready to convert yet.');
                default:
                  return const Text('Unknown state');
              }
            },
          ),
        ],
      ),
    );
  }
}
