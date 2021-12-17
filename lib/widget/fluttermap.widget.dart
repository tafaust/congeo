import 'package:congeo/plugin/zoom-buttons.plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class FlutterMapWidget extends StatelessWidget {
  final Logger _log = Logger();
  final LatLng? point;

  FlutterMapWidget({Key? key, required this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng p = point ?? LatLng(0, 0);
    return FlutterMap(
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
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
  }
}
