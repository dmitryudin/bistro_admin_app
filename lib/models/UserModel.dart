import 'dart:convert';

import 'package:bistro_admin_app/models/BasicModel.dart';

class UserModel implements BasicModel {
  String firstName = '';
  String email = '';
  String phoneNumber = '';
  int placeId = 0;

  UserModel.fromJson(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    firstName = json['firstname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    placeId = json['place_id'];
  }

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
