
import 'package:flutter/material.dart';

import 'google_map.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
title:'Map',
theme: ThemeData(

),
home: GoogleMapPage(),
    );
  }
}