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

  late Point currentInput;

  @override
  void initState() {
    _viewmodel.sourceProjection.add(Projection.WGS84);
    _viewmodel.destinationProjection.add(Projection.GOOGLE);

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
        currentInput = Point(x: x, y: y);
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
        currentInput = Point(x: x, y: y);
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
                  return Text('Google coordinates: ${snapshot.data}');
                case ConnectionState.waiting:
                  return const Text(
                      'Not ready to convert yet. Add an input point!');
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
