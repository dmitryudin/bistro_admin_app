import 'package:bistro_admin_app/bloc/AuthBloc/AuthBloc.dart';
import 'package:bistro_admin_app/configurations/NetworkConfiguraion.dart';
import 'package:bistro_admin_app/models/UserModel.dart';
import 'package:bistro_admin_app/utils/BlocLibrary/BlocBase.dart';
import 'package:dio/dio.dart';

class UserBloc extends BlocBase {
  static final UserBloc _userBloc = UserBloc._instance();

  UserModel? userModel;

  factory UserBloc() {
    return _userBloc;
  }

  UserBloc._instance();

  void init() async {
    Response response = await Dio().get(
        NetworkConfiguration().getAddress('get_admin_information'),
        queryParameters: {'id': AuthBloc().id});
    userModel = UserModel.fromJson(response.data);
  }

  @override
  void eventHandler(event) {
    // TODO: implement eventHandler
  }
}
