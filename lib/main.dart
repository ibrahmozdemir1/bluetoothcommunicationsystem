import 'package:flutter/material.dart';
import 'package:flutter_blue_app/Pages/anasayfa.dart';
import 'Pages/anasayfa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ImagePages/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(new ExampleApplication());
}

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Anasayfa());
  }
}
