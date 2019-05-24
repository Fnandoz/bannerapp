import 'package:flutter/material.dart';
import 'Model/BannerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

Future<List<BannerModel>> fetchBanner() async {
  final response = await http.get('http://10.0.2.2:3000/banner');

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((data) => new BannerModel.fromJson(data))
        .toList();
  } else {
    throw Exception("Failed to load banners.");
  }

}

void main() => runApp(MyApp(banners: fetchBanner()));

class MyApp extends StatelessWidget {
  Future<List<BannerModel>> banners;

  MyApp({Key key, this.banners}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Carousel Slider",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(title: Text("Carousel Slider")),
        body: Center(
          child: FutureBuilder<List<BannerModel>> (
            future: banners,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarouselSlider(
                  autoPlay: true,
                  height: 200.0,
                  items: snapshot.data.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image.network(i.link, fit: BoxFit.fill),
                        );
                      },
                    );
                  }).toList(),
                );
              }
              return CircularProgressIndicator();

            },
          ),
        ),
      ),
    );
  }

}
