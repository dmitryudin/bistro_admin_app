import 'package:bistro_admin_app/UI/Dialogs/EditCarouselDialog.dart';
import 'package:bistro_admin_app/UI/Widgets/Carousel.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceBloc.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceStates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import "package:collection/collection.dart";

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Это написал я

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Widget> cofWidget = [];
    List<Widget> cakeWidget = [];

    int i = -2;
    // TODO: implement build
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          pinned: false,
          snap: false,
          floating: false,
          expandedHeight: height / 3.7,
          backgroundColor: Colors.white,
          flexibleSpace: Stack(children: [
            Positioned(
                child: FlexibleSpaceBar(
                    title: Text('kjkjk'),
                    background: StreamBuilder(
                        stream: PlaceBloc().state,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<String> images = [];
                          if (snapshot.data.runtimeType ==
                              PlaceStateInformation)
                            images = snapshot.data.placeModel.photos;
                          return Carousel(
                            imageUrls: images,
                          );
                        })),
                top: 0,
                left: 0,
                right: 0,
                bottom: 0),
            Positioned(
              child: IconButton(
                  icon: Icon(Icons.mode_edit_outline_rounded),
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditCarouselDialog([]);
                      },
                    );
                  }),
              top: 25,
              right: 5,
            ),
            Positioned(
              child: Container(
                height: 20,
                //child: Card(),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                ),
              ),
              bottom: 0,
              right: 0,
              left: 0,
            ),
          ])),
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Card(
                child: Column(children: [
              Row(children: [
                StreamBuilder(
                    stream: PlaceBloc().state,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      String text = '';
                      if (snapshot.data.runtimeType == PlaceStateInformation) {
                        text = snapshot.data.placeModel.name;
                      }
                      return Text(
                        text,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      );
                    }),
                StreamBuilder(
                    stream: PlaceBloc().state,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      String text = '';
                      if (snapshot.data.runtimeType == PlaceStateInformation) {
                        text = snapshot.data.placeModel.phone;
                      }
                      return Text(
                        text,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      );
                    }),
              ]),
              Row(children: [
                Text(
                  '    Тут можно что то написать персоналу',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              Row(children: [
                Text(
                  '    ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ])
            ])),
          ],
        ),
      )
    ]);
  }
}
