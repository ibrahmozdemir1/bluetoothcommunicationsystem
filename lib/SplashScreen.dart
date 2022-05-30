import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'galeri_home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'DataHolder.dart';

int imageSize = 0;

getImage() async {
  var storageRef = FirebaseStorage.instance.ref().child("data");
  storageRef.listAll().then((result) => {
        result.items.forEach((imageRef) {
          displayImage(imageRef);
        })
      });
}

void displayImage(imageRef) async {
  imageRef.getDownloadURL().then((url) => {
        imageData[imageSize] = url.toString(),
        requestIndex.add(imageSize),
        print(url),
        print(imageSize),
        print(imageData[imageSize]),
        print(requestIndex.length),
        imageSize++
      });
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  SpinKitSquareCircle spinkit;

  @override
  void initState() {
    super.initState();
    getImage();

    spinkit = SpinKitSquareCircle(
      color: Colors.black87,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1000)),
    );

    Future.delayed(const Duration(seconds: 6), () async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PhotoPage();
          },
        ),
      );
    });
  }

  @override
  dispose() {
    spinkit.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            spinkit,
            //Image.asset('assets/images/flutterlogo.png', width: 40, height: 40,),
            SizedBox(
              height: 25,
            ),
            Text(
              "Yükleniyor",
              style: GoogleFonts.nunito(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
