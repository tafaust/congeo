import 'package:congeo/home.screen.dart';
import 'package:flutter/material.dart';
import 'package:proj4dart/proj4dart.dart';

void addProjections() {
  for (var e in [
    {
      'epsg': '4088',
      'proj4':
          '+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +a=6371007 +b=6371007 +units=m +no_defs',
    },
    {
      'epsg': '4087',
      'proj4':
          '+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs',
    },
    {
      'epsg': '3395',
      'proj4':
          '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs',
    },
    {
      'epsg': '6893',
      'proj4':
          '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +geoidgrids=egm08_25.gtx +vunits=m +no_defs'
    },
  ]) {
    Projection.add('EPSG:${e['epsg']!}', e['proj4']!);
  }
}

void main() {
  addProjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String title = 'Geo converter';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: title),
    );
  }
}
