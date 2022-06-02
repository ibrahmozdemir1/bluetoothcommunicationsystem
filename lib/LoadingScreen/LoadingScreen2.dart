import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../ImagePages/galeri_home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ImagePages/DataHolder.dart';

int imageSize = 0;

getImage() async {
    imageData = {};
  requestIndex =  [];
  imageSize = 0;
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
        imageSize++
      });
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
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
      Navigator.pushReplacement(
        context,
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
              "Fotoğraf Siliniyor...",
              style: GoogleFonts.nunito(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
