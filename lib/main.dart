import 'package:flutter/material.dart';
import 'package:tcpdeliver/pages/delivery.dart';
import 'package:tcpdeliver/pages/detail.dart';
import 'package:tcpdeliver/pages/home.dart';
import 'package:tcpdeliver/pages/loading.dart';
import 'package:tcpdeliver/pages/sign.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOA-CHUGOKU PAINTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange[400],
        accentColor: Colors.red[400],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/loading': (context) => LoadingPage(),
        '/sign': (context)  => SignPage(),
        '/delivery': (context) => DeliveryPage(),
        '/detail': (context) => DetailPage(),
        //'/product': (context) => ProductPage(),
      },
    );
  }
}

class ProductPage {
}
