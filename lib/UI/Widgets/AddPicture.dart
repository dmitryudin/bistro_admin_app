import 'dart:io' as dartio;

import 'package:bistro_admin_app/configurations/NetworkConfiguraion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  String url = '';
  late var onFileUploaded, onFileLoaded, onFileDeleted;
  AddPicture(
      {required this.url,
      required void onFileLoaded(String path),
      required void onFileUploaded(String url),
      dynamic onFileDeleted,
      Key? key})
      : super(key: key) {
    this.onFileLoaded = onFileLoaded;
    this.onFileUploaded = onFileUploaded;
    this.onFileDeleted = onFileDeleted;
  }

  @override
  AddPictureState createState() {
    return AddPictureState(this);
  }
}

class AddPictureState extends State<AddPicture> {
  late var basicClass;
  bool isActive = false;
  AddPictureState(this.basicClass);
  double progress = 0.0;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  var myImg;

  void setProgress(double progress) {
    setState(() {
      this.progress = progress;
    });
  }

  void onUploaded(String urln) {
    print(basicClass.url);
    basicClass.url = urln;
    basicClass.onFileUploaded(basicClass.url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (basicClass.url == '') {
      isActive = true;
      myImg = Column(
        children: [
          Text('Нажмите'),
          Icon(Icons.add_a_photo, size: width / 4), //color: Colors.orange,
          Text('Добавить фото', textAlign: TextAlign.center),
        ],
      );
    } else {
      isActive = false;
      myImg = Stack(
        children: [
          Card(
              color: Colors.white,
              child: (basicClass.url.contains('http'))
                  ? CachedNetworkImage(
                      width: width / 2.3,
                      height: height / 5.8,
                      imageUrl: basicClass.url,
                    )
                  : Image.file(
                      dartio.File(basicClass.url),
                      width: width / 2.2,
                      height: height / 5,
                    )),
          Positioned(
              top: 1,
              right: -20,
              child: RawMaterialButton(
                onPressed: () async {
                  if (basicClass.onFileDeleted == null) {
                    basicClass.url = '';
                    basicClass.onFileUploaded(basicClass.url);
                    setState(() {});
                  } else {
                    basicClass.onFileDeleted(basicClass.url);
                  }
                },
                elevation: 2.0,
                fillColor: Color.fromARGB(166, 215, 215, 215),
                child: Icon(
                  Icons.close_sharp,
                  //color: Colors.red,
                  size: 26.0,
                ),
                padding: EdgeInsets.all(5.0),
                shape: CircleBorder(),
              )),
          Positioned(
              top: 100,
              right: 100,
              child: CircularProgressIndicator(
                value: progress,
                semanticsLabel: 'Linear progress indicator',
              )),
        ],
      );
    }
    return GestureDetector(
        onTap: () async {
          print('on tapped');
          if (isActive) {
            basicClass.url == '.';
            image = await _picker
                .pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
            )
                .then((value) async {
              basicClass.url = value!.path;
              basicClass.onFileLoaded(value.path);
              var formData = FormData.fromMap({
                'file': await MultipartFile.fromFile(value.path,
                    filename: 'upload.png')
              });
              Response response = await Dio().post(
                NetworkConfiguration().basicUrl + '/v1/file/upload',
                data: formData,
                onSendProgress: (int sent, int total) {
                  print('$sent $total');
                },
              );
              if (response.statusCode == 200) onUploaded(response.data);
            });
            setState(() {});
          }
        },
        child: Column(
          children: <Widget>[myImg],
        ));
  }
}
