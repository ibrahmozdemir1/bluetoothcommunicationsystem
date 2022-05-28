// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_app/preview_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
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

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    getImage();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(requestIndex.length.toString()),
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
            Container(
              child: Text((requestIndex.length).toString()),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Product(product_image: imageData[widget._index]);
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
  final product_image;

  Product({this.product_image});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_image,
        child: Material(
          child: GridTile(
            child: Image.asset(
              product_image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
