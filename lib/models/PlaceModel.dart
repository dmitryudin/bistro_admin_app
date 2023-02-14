import 'dart:convert';

import 'package:bistro_admin_app/models/BasicModel.dart';

class PlaceModel implements BasicModel {
  int id = -1;
  String name = '';
  String phone = '';
  String email = '';
  String description = '';
  String address = '';
  double rating = 5.5;
  List<String> photos = [];

  PlaceModel();

  @override
  PlaceModel.fromJson(json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    rating = json['rating'];
    description = json['description'];
    address = json['address'];
    List d = json['photos'];
    photos = d.map((e) => e.toString()).toList();
  }

  @override
  String toJson() {
    Map<String, dynamic> data = {};
    String address = '';
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['description'] = description;
    data['address'] = address;
    data['photos'] = photos;
    return jsonEncode(data);
  }
}
