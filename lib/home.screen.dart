import 'package:congeo/coordinate-system.entity.dart';
import 'package:congeo/home.viewmodel.dart';
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
  late TextEditingController latController;
  late TextEditingController lonController;

  final HomeViewmodel _viewmodel = HomeViewmodelImpl();

  CoordinateSystem dropdownValue = allCoords[0];

  @override
  void initState() {
    _viewmodel.sourceProjection.add(Projection.WGS84);
    // _viewmodel.destinationProjection.add(Projection.GOOGLE);

    // empty setState forces a re-render
    latController = TextEditingController()
      ..addListener(() {
        double? x = double.tryParse(latController.text);
        double? y = double.tryParse(lonController.text);
        if (x == null) {
          // TODO clear _viewmodel.destinationPoint.stream
          return;
        }
        if (y == null) {
          // TODO clear _viewmodel.destinationPoint.stream
          return;
        }
        Point currentInput = Point(x: x, y: y);
        _log.d(currentInput);
        _viewmodel.inputSourcePoint.add(currentInput);
      });
    lonController = TextEditingController()
      ..addListener(() {
        double? x = double.tryParse(latController.text);
        double? y = double.tryParse(lonController.text);
        if (x == null) {
          // TODO clear _viewmodel.destinationPoint.stream
          return;
        }
        if (y == null) {
          // TODO clear _viewmodel.destinationPoint.stream
          return;
        }
        Point currentInput = Point(x: x, y: y);
        _log.d(currentInput);
        _viewmodel.inputSourcePoint.add(currentInput);
      });
    super.initState();
  }

  @override
  void dispose() {
    latController.dispose();
    lonController.dispose();
    super.dispose();
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
          // const Text(
          //     'TODO Open street map → show location of input coordinates'),
          Container(
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
                    }),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: latController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      hintText: '0.0',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Spacer(flex: 2),
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: lonController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      hintText: '0.0',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          StreamBuilder(
            stream: _viewmodel.inputSourcePoint.stream,
            builder: (context, AsyncSnapshot<Point?> snapshot) =>
                Text('Lat: ${snapshot.data?.x} | Lon: ${snapshot.data?.y}'),
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
