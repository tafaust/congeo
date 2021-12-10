import 'package:congeo/plugin/zoom-buttons.plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';

class FlutterMapWidget extends StatelessWidget {
  final Point? point;

  const FlutterMapWidget({Key? key, required this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Point p = point ?? Point(x: 0, y: 0);
    return FlutterMap(
      options: MapOptions(
        center: point2latlng(p),
        zoom: 2.0,
        plugins: [
          ZoomButtonsPlugin(),
        ],
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
              width: 10.0,
              height: 10.0,
              point: point2latlng(p),
              builder: (ctx) => const FlutterLogo(),
            ),
          ],
        ),
      ],
      nonRotatedLayers: [
        ZoomButtonsPluginOption(
          minZoom: 4,
          maxZoom: 19,
          mini: true,
          padding: 10,
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }

  LatLng point2latlng(Point point) {
    return LatLng(point.x, point.y);
  }
}
