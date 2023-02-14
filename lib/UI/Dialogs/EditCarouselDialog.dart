import 'dart:io';

import 'package:bistro_admin_app/UI/Widgets/AddPicture.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceBloc.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceEvents.dart';
import 'package:bistro_admin_app/configurations/NetworkConfiguraion.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditCarouselDialog extends StatefulWidget {
  List<String> images = [];
  EditCarouselDialog(this.images) {}
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditCarouselD(images);
  }
}

class EditCarouselD extends State<EditCarouselDialog> {
  List<String> images = [];
  List<String> newImages = [];

  bool isCansel = true;
  EditCarouselD(this.images) : super() {
    images = images.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imagesWidget = [];
    for (int i = 0; i < images.length; i++) {
      print('Этот цикл не должен выполняться');
      imagesWidget.add(
        AddPicture(
            onFileUploaded: (String url) {},
            onFileLoaded: (String path) {},
            onFileDeleted: (String uri) async {
              await Dio().get(
                  NetworkConfiguration().basicUrl + '/v1/file/delete',
                  queryParameters: {'url': uri});
              print('FileRemoved $uri');

              setState(() {
                images.remove(uri);
                if (newImages.contains(uri)) {
                  newImages.remove(uri);
                }
              });
            },
            url: images[i],
            key: UniqueKey()),
      );
    }
    imagesWidget.add(AddPicture(
        onFileUploaded: (String url) {
          print('File uploaded $url');

          setState(() {
            images.add(url);
            newImages.add(url);
          });
        },
        onFileLoaded: (String path) {},
        onFileDeleted: null,
        url: '',
        key: UniqueKey()));

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        title: Text("Редактировать галерею"),
        actionsAlignment: MainAxisAlignment.center,
        content: Container(
            height: height * 0.9,
            width: width * 0.96,
            child: ListView(children: [
              GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: imagesWidget),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    elevation: 5,
                    minimumSize: Size(height * 0.65, width * 0.15),
                  ),
                  onPressed: () {
                    // TODO Вызывается колбэк с адресами новых картинок
                    PlaceBloc()
                        .sendEvent(PlaceEventUpdatePhoto(photos: images));
                    isCansel = false;
                    Navigator.pop(context);
                  },
                  child:
                      Text('Отправить', style: TextStyle(color: Colors.black))),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    elevation: 5,
                    minimumSize: Size(height * 0.65, width * 0.15),
                  ),
                  onPressed: () {
                    isCansel = true;
                    Navigator.pop(context);
                  },
                  child:
                      Text('Отменить', style: TextStyle(color: Colors.black)))
            ])),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))));
    // TODO: implement build
  }

  @override
  void dispose() {
    if (isCansel) {
      for (String img in newImages) {
        print(img);
        Dio().get(NetworkConfiguration().basicUrl + '/v1/file/delete',
            queryParameters: {'url': img});

        //TODO реализовать удаеление файла с сервера
      }
    }
    super.dispose();
  }
}
