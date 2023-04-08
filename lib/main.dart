import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Item> fetchItem() async {
  final response = await http
      .get(Uri.parse('http://api.arianb.me:8000/WholeCart'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Item.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Item {
  final String upc;
  final String name;
  final String image;
  final String link;
  final int average_rating;

  const Item({
    required this.upc,
    required this.name,
    required this.image,
    required this.link,
    required this.average_rating
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      upc: json['userId'],
      name: json['id'],
      image: json['title'],
      link: json['link'],
      average_rating: json['rating']
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyApp() ,
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget shoppingButton = Row(

        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 30, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: const Color(0xffA9C52F),
            ),

            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShoppingCart()),
                  );
                }
            ),
          ),
        ]
    );

    Widget eShopLogo = const Image(
      image: AssetImage('assets/images/eshop_logo.png'),
      width: 256,
      height: 235,
    );

    Widget eShopTextA = const SizedBox(
      height: 64,
      width: 154,
      child: Text(
          "eShop",
          style: TextStyle(color: Color(0xffA9C52F), fontSize: 48)
      ),
    );

    Widget eShopTextB = const SizedBox(
      height: 77,
      width: 275,
      child: Text(
          "Sustainability in your Pocket: Scan barcodes to view a product's sustainability score",
          style: TextStyle(color: Color(0xffA9C52F), fontSize: 18)
      ),
    );

    Widget cameraButton = SizedBox(
      height: 82,
      width: 232,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xffA9C52F),
        ),
        onPressed: () {
        },
        child: const Text('Open Camera', style: TextStyle(color: Colors.white)),
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        backgroundColor: const Color(0xff283739),
        appBar: AppBar(
          title: const Text('eShop iOS Demo'),
        ),
        body: Column(
          children: [
            shoppingButton,
            eShopLogo,
            eShopTextA,
            eShopTextB,
            cameraButton
          ],
        ),
      ),
    );
  }
}

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShoppingCart'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}