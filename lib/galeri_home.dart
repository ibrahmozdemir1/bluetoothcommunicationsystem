import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'DataHolder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

int imageSize = 0;

getImage() async {
  requestIndex.clear();
  imageData.clear();
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

// ignore: must_be_immutable
class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Çekilen Fotoğraflar"),
      ),
      body: Container(
        child: GridView.builder(
          itemCount: requestIndex.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return ImageGridItem(index);
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageGridItem extends StatefulWidget {
  int _index;

  ImageGridItem(int index) {
    this._index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  Widget decideGridTileWidget() {
    if (imageData[widget._index] == null) {
      return Center(child: Text("Fotoğraf Yüklenemedi"));
    } else {
      return Image.network(imageData[widget._index], fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: widget._index,
        child: Column(
          children: <Widget>[
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Product(productImage: imageData[widget._index]);
                  }));
                },
                child: GridTile(
                  child: decideGridTileWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product extends StatelessWidget {
  Product({this.productImage});
  final productImage;
  var date;
  String photoDate;

  Future<Widget> getPhotoDate() async {
    Reference ref = FirebaseStorage.instance.refFromURL(productImage);
    var date = await ref.getMetadata();
    photoDate = date.timeCreated.toString();
    return Text("Foto tarih : " + photoDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarOpacity: 0.7,
          bottomOpacity: 0.2,
          backgroundColor: Colors.lightBlue,
        ),
        body: Card(
          child: Hero(
            tag: productImage,
            child: Material(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      productImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: ElevatedButton(
                      child: Text("Fotoğrafı Sil"),
                      onPressed: () {
                        FirebaseStorage.instance
                            .refFromURL(productImage)
                            .delete()
                            .then((value) => Splash());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
