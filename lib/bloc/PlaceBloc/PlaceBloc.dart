import 'dart:async';
import 'dart:convert';
import 'package:bistro_admin_app/bloc/AuthBloc/AuthEvents.dart';
import 'package:bistro_admin_app/bloc/AuthBloc/AuthStates.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceEvents.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceStates.dart';
import 'package:bistro_admin_app/configurations/NetworkConfiguraion.dart';
import 'package:bistro_admin_app/models/PlaceModel.dart';
import 'package:bistro_admin_app/utils/BlocLibrary/BlocBase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlaceBloc extends BlocBase {
  PlaceModel placeModel = PlaceModel();
  void getInformation(int id) async {
    Response response = await Dio().get(
        NetworkConfiguration().getAddress('get_place_information'),
        queryParameters: {'id': id});
    placeModel = PlaceModel.fromJson(response.data);
    emitState(PlaceStateInformation(placeModel: placeModel));
  }

  void updatePhoto(List<String> photos) {
    placeModel.photos = photos;
    print(placeModel.toJson());
    Dio().put(NetworkConfiguration().getAddress('update_place_information'),
        data: placeModel.toJson());
    print(placeModel.toJson());
  }

  @override
  void eventHandler(event) async {
    switch (event.runtimeType) {
      case (PlaceEventGetInformation):
        {
          getInformation(event.id);
          break;
        }
      case (PlaceEventUpdatePhoto):
        {
          updatePhoto(event.photos);
          break;
        }

      case (PlaceEventTest):
        {
          print('place event handled');
          emitState(PlaceStateTest("sdfasfd"));
          break;
        }
    }
  }
}
