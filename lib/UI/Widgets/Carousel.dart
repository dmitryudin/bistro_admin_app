import 'package:bistro_admin_app/UI/Dialogs/EditCarouselDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  List<String> imageUrls = [];
  Carousel({required List<String> this.imageUrls});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyWidget(imageUrls);
  }
}

class MyWidget extends State<Carousel> {
  List<String> imageUrls = [];
  MyWidget(this.imageUrls);
  int _current = 0;
  final CarouselController _controller = CarouselController();
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<String> imagesPath = imageUrls;
    List<Widget> imagesWidget = imagesPath
        .map((imageUrl) => Container(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fitWidth,
                width: width,
              ),
            ))
        .toList();
    if (imagesWidget.isEmpty) {
      imagesWidget.add(Container(
        child: GestureDetector(
          child: Icon(
            Icons.add_a_photo,
            size: height / 3,
            //color: Colors.red,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditCarouselDialog(imageUrls);
              },
            );
          },
        ),
      ));
    }
    return CarouselSlider(
        items: imagesWidget,
        carouselController: _controller,
        options: CarouselOptions(
          aspectRatio: 2.0,
          viewportFraction: 1.0,
          height: height / 3,
          enlargeCenterPage: false,
          autoPlay: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ));
  }
}
