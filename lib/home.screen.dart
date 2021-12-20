import 'package:congeo/coordinate-system.entity.dart';
import 'package:congeo/home.viewmodel.dart';
import 'package:congeo/theme/constants.dart';
import 'package:congeo/widget/angle-input.widget.dart';
import 'package:congeo/widget/fluttermap.widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            double height = MediaQuery.of(context).size.height -
                (kToolbarHeight + kBottomNavigationBarHeight);
            // portrait mode
            return SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 250.0,
                      maxHeight: height / 2.0,
                    ),
                    child: buildFlutterMap(context, orientation),
                  ),
                  Container(
                    constraints:
                        BoxConstraints.tightForFinite(height: height / 2.0),
                    child: buildConversionPanel(context),
                  ),
                ],
              ),
            );
          } else {
            // landscape mode
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: buildFlutterMap(context, orientation)),
                Container(
                  constraints:
                      const BoxConstraints.tightForFinite(width: 450.0),
                  child: buildConversionPanel(context),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildFlutterMap(BuildContext context, Orientation orientation) {
    return PhysicalModel(
      borderRadius: BorderRadius.only(
        bottomLeft: orientation == Orientation.portrait
            ? const Radius.elliptical(48, 24)
            : Radius.zero,
        topRight: orientation == Orientation.landscape
            ? const Radius.elliptical(48, 24)
            : Radius.zero,
        bottomRight: const Radius.elliptical(48, 24),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).backgroundColor,
      elevation: 4.0,
      child: FlutterMapWidget(
        viewmodel: _viewmodel,
      ),
    );
  }

  Widget buildConversionPanel(BuildContext context) {
    return
        // Stack(
        // alignment: AlignmentDirectional.centerStart,
        // children: [
        Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildSourceCard()),
        Expanded(child: _buildDestinationCard()),
      ],
      //   ),
      //   Positioned(
      //     child: SizedBox(
      //       width: 64,
      //       height: 64,
      //       child: PhysicalModel(
      //         color: Theme.of(context).primaryColorDark,
      //         borderRadius: BorderRadius.circular(defaultBorderRadius),
      //         elevation: 2.0,
      //         child: const Icon(
      //           Icons.compare_arrows,
      //           size: 24.0,
      //           // color: Theme.of(context).primaryColorLight,
      //         ),
      //       ),
      //     ),
      //     left: MediaQuery.of(context).size.width / 6 - 11,
      //   ),
      // ],
    );
  }

  Card _buildSourceCard() {
    return Card(
      child: Padding(
        padding: kDefaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AngleInputWidget(viewmodel: _viewmodel),
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
    );
  }

  _buildDestinationCard() {
    return Card(
      child: Padding(
        padding: kDefaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
              child: StreamBuilder(
                stream: _viewmodel.destinationPoint,
                builder: (context, AsyncSnapshot<Point> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        Point result = snapshot.data!;
                        return Text('x: ${result.x} | y: ${result.y}');
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return const Text('Unknown error');
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
      ),
    );
  }
}
