
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/helper/AssetStrings.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:progressive_image/progressive_image.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _getCarousel()
          ],
        ),
      ),
    );
  }




  Widget _getCarousel({bool enlargeCenterPage = false}) {
    return CarouselSlider.builder(
        itemCount: 10 ?? 0,
        itemBuilder: (BuildContext context, int itemIndex) => Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(color: Colors.white),
            child: InkWell(
              onTap: () {

              },
              child: getNetworkImage(
                  url: "",
                  height: 170,
                  width: getScreenSize(context: context).width),
            )),
        options: CarouselOptions(
          height: 170,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: enlargeCenterPage,
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget getNetworkImage(
      {@required String url,
        BoxFit fit,
        double width = 100,
        double height = 100}) {
    return ProgressiveImage(
      placeholder: AssetImage(AssetStrings.placeHolder),
      // size: 1.87KB
      thumbnail: NetworkImage(url),
      // size: 1.29MB
      image: NetworkImage(url),
      height: height,
      width: width,
      fit: BoxFit.fill,
    );

  }
}
