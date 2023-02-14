import 'dart:convert';

import 'package:bistro_admin_app/models/BasicModel.dart';
import 'package:bistro_admin_app/models/MenuModel.dart';

class OrderObject implements BasicModel {
  int idPayment = -1;
  int ids = -1;
  bool onPlace = false;
  String requiredDateTime = '';
  String serviceStatus = '';
  String usersStatus = '';
  String adminsStatus = '';
  int userId = -1;
  String userPhone = '';
  double totalCost = 0.0;
  List<Position> unpackedCoffe = [];

  OrderObject();

  OrderObject.fromJson(String json) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    idPayment = jsonMap['id_payment'];
    ids = jsonMap['id'];
    userId = jsonMap['user_id'];
    serviceStatus = jsonMap['service_status'];
    adminsStatus = jsonMap['admins_status'];

    requiredDateTime = jsonMap['required_datetime'];
    userPhone = jsonMap['user_phone'];
    onPlace = jsonMap['on_place'];
    usersStatus = jsonMap['users_status'];
    totalCost = jsonMap['total_cost'];

    unpackedCoffe = (jsonMap['positions'] as List)
        .map((item) => Position.fromJson(jsonEncode(item)))
        .toList();
  }

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
