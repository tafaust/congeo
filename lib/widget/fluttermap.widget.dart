import 'dart:async';

import 'package:congeo/home.viewmodel.dart';
import 'package:congeo/plugin/zoom-buttons.plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class FlutterMapWidget extends StatefulWidget {
  final HomeViewmodel vm;

  const FlutterMapWidget({Key? key, required viewmodel})
      : vm = viewmodel,
        super(key: key);

  @override
  State<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends State<FlutterMapWidget> {
  final Logger _log = Logger();
  final MapControllerImpl _controller = MapControllerImpl();
  late StreamSubscription _ss;

  @override
  void initState() {
    _ss = widget.vm.latLngSourcePoint.listen(
      (value) {
        _log.d('Adjusting FlutterMap center!');
        _controller.move(value, _controller.zoom);
      },
      onError: _log.e,
    );
    super.initState();
  }

  @override
  void dispose() {
    _ss.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LatLng>(
        stream: widget.vm.latLngSourcePoint,
        builder: (context, snapshot) {
          LatLng p = snapshot.data ?? LatLng(0, 0);
          return FlutterMap(
            mapController: _controller,
            options: MapOptions(
              center: p,
              zoom: 2.0,
              plugins: [
                ZoomButtonsPlugin(),
              ],
              onTap: (_, LatLng point) {
                // TODO update the map point here (need to contact home.viewmodel)
              },
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                // attributionBuilder: (_) {
                //   return const Text("© OpenStreetMap contributors");
                // },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 8.5,
                    height: 8.5,
                    point: p,
                    builder: (ctx) => const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
            nonRotatedLayers: [
              ZoomButtonsPluginOption(
                minZoom: 1,
                maxZoom: 10,
                mini: true,
                padding: 10,
                alignment: Alignment.bottomRight,
              ),
            ],
          );
        });
  }
}
