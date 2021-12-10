import 'package:congeo/coordinate-system.entity.dart';
import 'package:congeo/home.viewmodel.dart';
import 'package:congeo/widget/angle-input.widget.dart';
import 'package:congeo/widget/fluttermap.widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proj4dart/proj4dart.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _log = Logger();
  final HomeViewmodel _viewmodel = HomeViewmodelImpl();

  @override
  void initState() {
    _viewmodel.sourceProjection.add(Projection.WGS84);
    // _viewmodel.destinationProjection.add(Projection.GOOGLE);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: StreamBuilder(
              stream: _viewmodel.inputSourcePoint,
              builder: (context, AsyncSnapshot<Point> snapshot) =>
                  FlutterMapWidget(point: snapshot.data),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('WGS 84'),
                  const Icon(Icons.arrow_right_alt),
                  StreamBuilder<CoordinateSystem>(
                    stream: _viewmodel.destinationProjection,
                    builder:
                        (context, AsyncSnapshot<CoordinateSystem> snapshot) {
                      return DropdownButton<CoordinateSystem>(
                        hint: const Text('Select target coordinate system'),
                        value: snapshot.data,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (CoordinateSystem? newValue) {
                          _log.d(newValue?.projection);
                          if (newValue != null) {
                            _viewmodel.destinationProjection.add(newValue);
                          }
                        },
                        items: allCoords
                            .map<DropdownMenuItem<CoordinateSystem>>(
                                (CoordinateSystem cs) {
                          return DropdownMenuItem<CoordinateSystem>(
                            value: cs,
                            child: Text(cs.name),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
              child: AngleInputWidget(viewmodel: _viewmodel),
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: StreamBuilder(
              stream: _viewmodel.inputSourcePoint.stream,
              builder: (context, AsyncSnapshot<Point?> snapshot) =>
                  Text('Lat: ${snapshot.data?.x} | Lon: ${snapshot.data?.y}'),
            ),
          ),
          Expanded(
            flex: 4,
            child: StreamBuilder(
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
          ),
        ],
      ),
    );
  }
}
