import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: MyApp() ,
  ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late Future<List<Item>>? _items;

  @override
  void initState() {
    super.initState();
    _items = fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShoppingCart'),
      ),
      body: FutureBuilder<List<Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Image.network(item.image),
                  title: Text(item.name),
                  subtitle: Text('UPC: ${item.upc}'),
                  trailing: Text('Average Rating: ${item.average_rating}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading items from API');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


Future<List<Item>> fetchItems() async {
  final response = await http.get(Uri.parse('http://api.arianb.me:8000/WholeCart'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => Item.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load items from API');
  }
}


class Item {
  final String upc;
  final String name;
  final String image;
  final int average_rating;

  const Item({
    required this.upc,
    required this.name,
    required this.image,
    required this.average_rating
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        upc: json['upc'] as String,
        name: json['name'] as String,
        image: json['image'] as String,
        average_rating: json['average_rating'] as int,
    );
  }
}