import 'package:congeo/home.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:proj4dart/proj4dart.dart';

/// Interface for X and Y input.
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
      children: [
        Expanded(
          flex: 6,
          child: TextField(
            controller: latController,
            decoration: const InputDecoration(
              labelText: 'X',
              hintText: '0.0',
              border: OutlineInputBorder(),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        const Spacer(flex: 2),
        Expanded(
          flex: 6,
          child: TextField(
            controller: lonController,
            decoration: const InputDecoration(
              labelText: 'Y',
              hintText: '0.0',
              border: OutlineInputBorder(),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
