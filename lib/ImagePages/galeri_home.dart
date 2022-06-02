import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'DataHolder.dart';
import '../LoadingScreen/LoadingScreen2.dart';



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
                child: Container(
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

  Future<String> getPhotoDate() async {
    Reference ref = FirebaseStorage.instance.refFromURL(productImage);
    var date = await ref.getMetadata();
    photoDate = date.timeCreated.toString();
    return photoDate;
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
                            .delete().whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => Loading())));
                      },
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future: getPhotoDate(),
                      initialData: "Loading Date...",
                      builder: (context, AsyncSnapshot text){
                        return Text("Fotoğrafın Çekilme Tarihi :" + text.data);
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
