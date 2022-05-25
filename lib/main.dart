import 'package:flutter/material.dart';
import 'package:flutter_blue_app/anasayfa.dart';

import 'MainPage.dart';
import 'anasayfa.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Anasayfa());
  }
}
