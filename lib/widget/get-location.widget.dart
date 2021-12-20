import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class GetLocationWidget extends StatefulWidget {
  final void Function(LocationData location) onLocation;
  final void Function(String error)? onError;

  const GetLocationWidget({Key? key, required this.onLocation, this.onError})
      : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {
  final Location location = Location();

  bool _loading = false;

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      widget.onLocation(_locationResult);
    } on PlatformException catch (err) {
      // not a typo here, errohr is perfectly fine
      (widget.onError ?? (errohr) {})(err.code);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   'Location: ' + (_error ?? '${_location ?? "unknown"}'),
        //   style: Theme.of(context).textTheme.bodyText1,
        // ),
        Row(
          children: <Widget>[
            ElevatedButton(
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.gps_fixed),
              onPressed: _getLocation,
            )
          ],
        ),
      ],
    );
  }
}
