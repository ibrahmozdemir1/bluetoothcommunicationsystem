import 'package:flutter/material.dart';
import 'package:flutter_blue_app/galeri_home.dart';

//Bu modül preview_image.dart ve galeri_home.dart ile birlikte çalışmakta
//ancak preview_image üzerindeki hatayı henüz çözümleyemediğim için
// bunu çalıştırmak mümkün değil ancak en güzel görünüme sahip olan modül bu
//eğer becerebliirsek bunu kullanmamız daha iyi olur

class GaleriBen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
