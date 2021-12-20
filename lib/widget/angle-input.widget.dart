import 'package:congeo/coordinate-system.entity.dart';
import 'package:congeo/home.viewmodel.dart';
import 'package:congeo/widget/get-location.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:logger/logger.dart';
import 'package:proj4dart/proj4dart.dart';

/// Interface for latitude and longitude input.
class AngleInputWidget extends StatefulWidget {
  final HomeViewmodel vm;

  const AngleInputWidget({
    Key? key,
    required HomeViewmodel viewmodel,
  })  : vm = viewmodel,
        super(key: key);

  @override
  State<AngleInputWidget> createState() => _AngleInputWidgetState();
}

class _AngleInputWidgetState extends State<AngleInputWidget> {
  final Logger _log = Logger();

  late TextEditingController latController;
  late TextEditingController lonController;

  @override
  void initState() {
    // empty setState forces a re-render
    latController = TextEditingController()
      ..addListener(() {
        double? x = double.tryParse(latController.text);
        double? y = double.tryParse(lonController.text);
        if (x == null) {
          // TODO clear vm.destinationPoint.stream
          return;
        }
        if (y == null) {
          // TODO clear vm.destinationPoint.stream
          return;
        }
        Point currentInput = Point(x: x, y: y);
        _log.d(currentInput);
        widget.vm.inputSourcePoint.add(currentInput);
      });
    lonController = TextEditingController()
      ..addListener(() {
        double? x = double.tryParse(latController.text);
        double? y = double.tryParse(lonController.text);
        if (x == null) {
          // TODO clear vm.destinationPoint.stream
          return;
        }
        if (y == null) {
          // TODO clear vm.destinationPoint.stream
          return;
        }
        Point currentInput = Point(x: x, y: y);
        _log.d(currentInput);
        widget.vm.inputSourcePoint.add(currentInput);
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: TextField(
            controller: latController,
            autofocus: false,
            decoration: const InputDecoration(
              labelText: 'Latitude',
              hintText: '0.0',
              border: OutlineInputBorder(),
            ),
            inputFormatters: <TextInputFormatter>[
              // FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.allow(RegExp(r'[\.,0-9]')),
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16.0),
        Flexible(
          fit: FlexFit.loose,
          child: TextField(
            controller: lonController,
            autofocus: false,
            decoration: const InputDecoration(
              labelText: 'Longitude',
              hintText: '0.0',
              border: OutlineInputBorder(),
            ),
            inputFormatters: <TextInputFormatter>[
              // FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.allow(RegExp(r'[\.,0-9]')),
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16.0),
        GetLocationWidget(
          onLocation: onLocation,
        ),
      ],
    );
  }

  void onLocation(LocationData location) {
    _log.d(location);
    if (location.latitude is double && location.longitude is double) {
      latController.text = location.latitude.toString();
      lonController.text = location.longitude.toString();

      Point currentInput = Point(
        x: location.latitude!,
        y: location.longitude!,
      );
      widget.vm.inputSourcePoint.add(currentInput);
      widget.vm.sourceProjection.add(
        allCoords.where((element) => element.epsgCode == 'EPSG:4326').first,
      );
    }
  }
}
