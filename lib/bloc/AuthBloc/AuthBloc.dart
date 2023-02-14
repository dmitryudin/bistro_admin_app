import 'dart:async';
import 'dart:convert';
import 'package:bistro_admin_app/bloc/AuthBloc/AuthEvents.dart';
import 'package:bistro_admin_app/bloc/AuthBloc/AuthStates.dart';
import 'package:bistro_admin_app/configurations/NetworkConfiguraion.dart';
import 'package:bistro_admin_app/utils/BlocLibrary/BlocBase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthBloc extends BlocBase {
  static final AuthBloc _authBloc = AuthBloc._instance();

  factory AuthBloc() {
    return _authBloc;
  }

  AuthBloc._instance();
  int id = -1;
  String _login = '';
  String _password = '';
  String accessToken = '';
  String _refreshToken = '';
  int _lifeTimeInSeconds = 1;
  bool isAuthFlag = false;
  String _authUrl = '';
  String _refreshTokenUrl = '';
  late var box;

  void updateToken() {
    //Метод который запускается единожды при загрузке приложения
    // Этот метод периодически (задаётся _lifeTimeInSeconds) с помощью асинхронного таймера
    // обновляет токен доступа
    Timer.periodic(Duration(milliseconds: _lifeTimeInSeconds * 1000),
        (timer) async {
      try {
        Response r = await Dio()
            .get(NetworkConfiguration().getAddress('refresh_access_token'),
                options: Options(
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer $_refreshToken',
                  },
                ));

        if (r.statusCode == 200) {
          Map<String, dynamic> jsonString = r.data;
          accessToken = jsonString['access_token'];
          box.put('accessToken', accessToken);
          print('tokenUpdated');
        }

        if (r.statusCode == 422 || r.statusCode == 401) print('Unauth');
      } catch (e) {
        timer.cancel();
        logIn(
          authEventLogin: AuthEventLogin(login: _login, password: _password),
        );
      }
    });
  }

  Future<String> logIn(
      // Асинхронный методавторизации
      {required AuthEventLogin authEventLogin}) async {
    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${authEventLogin.login}:${authEventLogin.password}'));
    print(basicAuth);
    Response response = await Dio().get(
        NetworkConfiguration().getAddress('login'),
        options:
            Options(headers: <String, String>{'authorization': basicAuth}));
    print(response.data);
    Map jsonString = response.data;

    _lifeTimeInSeconds = jsonString['lifetime'];
    id = jsonString['id'];
    accessToken = jsonString['access_token'];
    _refreshToken = jsonString['refresh_token'];
    _login = authEventLogin.login!;
    _password = authEventLogin.password!;
    // В БД Hive заносятся все учетные данные
    box.put('login', _login);
    box.put('password', _password);
    box.put('accessToken', accessToken);
    box.put('refreshToken', _refreshToken);
    emitState(AuthStateLogin(isAuth: true));

    // Вызывается колбэк, оповещающий приложение обуспешной авторизации

    updateToken();

    return '';
  }

  void logOut() {
    // Фнкция реализует выход из приложения
    // Удаляются внутренние переменные и данные хранилища Hive
    _login = '';
    _password = '';
    _refreshToken = '';
    accessToken = '';
    box.put('login', '');
    box.put('password', '');
    box.put('accessToken', '');
    box.put('refreshToken', '');
  }

  void init() async {
    box = await Hive.openBox('Security');
    _login = box.get('login');
    _password = box.get('password');
    _refreshToken = box.get('refreshToken');
    if ((_login != '') & (_refreshToken != '')) ; //Передаем стейт обратно
    logIn(authEventLogin: AuthEventLogin(login: _login, password: _password));
  }

  @override
  void eventHandler(event) async {
    switch (event.runtimeType) {
      case (AuthEventLogin):
        {
          logIn(authEventLogin: event);
          break;
        }
      case (AuthEventRegister):
        {
          Response? response;
          try {
            response = await Dio()
                .post(NetworkConfiguration().getAddress('register'), data: {
              'firstname': event.firstName,
              'phone_number': event.phone,
              'email': event.email,
              'password': event.password
            });

            emitState(AuthStateLogin(isAuth: true));
          } catch (e) {
            emitState(AuthStateUserExist());
          }
          break;
        }
    }
    // TODO: implement eventHandler
  }
}
