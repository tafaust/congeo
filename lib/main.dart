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

    const primary = Colors.blue;
    const white = Colors.white;
    const black = Colors.black;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: primary,
        primaryColorDark: black,
        primaryColorLight: white,
        backgroundColor: white,
        scaffoldBackgroundColor: white,

        /// Input theming
        inputDecorationTheme: const InputDecorationTheme(
          isCollapsed: false,
          isDense: true,
          fillColor: white,
          labelStyle: TextStyle(color: black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: black,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: primary,
            ),
          ),
        ),

        /// Card theming
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 4.0,
          color: white,
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          shadowColor: black,
        ),

        /// Icon theming
        iconTheme: const IconThemeData(
          color: white,
          size: 24.0,
        ),
      ),
      home: HomeScreen(title: title),
    );
  }
}
