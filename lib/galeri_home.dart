import 'package:flutter/material.dart';
import 'package:flutter_blue_app/preview_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List_Item = [
    {
      'pic': 'foto/1.jpg',
    },
    {
      'pic': 'foto/2.jpg',
    },
    {
      'pic': 'foto/3.jpg',
    },
    {
      'pic': 'foto/4.jpg',
    },
    {
      'pic': 'foto/5.jpg',
    },
    {
      'pic': 'foto/6.jpg',
    },
    {
      'pic': 'foto/7.jpg',
    },
    {
      'pic': 'foto/8.jpg',
    },
    {
      'pic': 'foto/9.jpg',
    },
    {
      'pic': 'foto/10.jpg',
    },
    {
      'pic': 'foto/11.jpg',
    },
    {
      'pic': 'foto/12.jpg',
    },
    {
      'pic': 'foto/13.jpg',
    },
    {
      'pic': 'foto/14.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gallery'),
      ),
      body: Container(
        child: GridView.builder(
          itemCount: List_Item.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int i) {
            return Product(product_image: List_Item[i]['pic']);
          },
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
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PreviewImage(picDetails_view: product_image)));
            },
            child: GridTile(
              child: Image.asset(
                product_image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
