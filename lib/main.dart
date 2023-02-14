import 'package:bistro_admin_app/UI/Pages/HomePage/HomePage.dart';
import 'package:bistro_admin_app/UI/Pages/LoginPage/LoginPage.dart';
import 'package:bistro_admin_app/UI/Pages/ManageClientPage.dart/ManageClientPage.dart';
import 'package:bistro_admin_app/UI/Pages/ManageHallPage/ManageHallPage.dart';
import 'package:bistro_admin_app/UI/Pages/OrderPage/OrderPage.dart';
import 'package:bistro_admin_app/bloc/AuthBloc/AuthBloc.dart';
import 'package:bistro_admin_app/bloc/AuthBloc/AuthStates.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceBloc.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceEvents.dart';
import 'package:bistro_admin_app/bloc/UserBloc/UserBloc.dart';
import 'package:bistro_admin_app/tast_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'UI/Widgets/CreateHallWidget.dart';

class BlocProvider extends InheritedWidget {
  late UserBloc userBloc;
  late PlaceBloc placeBloc;
  BlocProvider({required Widget child}) : super(child: child) {
    userBloc = UserBloc();
    placeBloc = PlaceBloc();
  }
  static BlocProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BlocProvider>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }
}

void main() async {
  await Hive.initFlutter();
  AuthBloc().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(child: TestPage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthBloc().state,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data.runtimeType == AuthStateLogin) {
            if (snapshot.data.isAuth == true) return MainPage();
          }
          return LoginPage();
        });
  }
}

class MainPage extends StatefulWidget {
  MainPage() {
    /* _receivePort?.listen((message) {
      if (message == 'onNotificationPressed') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Orders()));
      }
    });*/
  }
  @override
  MyWidget createState() {
    // TODO: implement createState
    return MyWidget();
  }
}

class MyWidget extends State {
  void _onItemTapped(ind) {
    setState(() {
      index = ind;
      if (ind == 0) {
        PlaceBloc().sendEvent(PlaceEventGetInformation(id: 1));
      }
    });
  }

  int index = 0;
  List<Widget> Screens = [
    HomePage(),
    OrderPage(),
    ManageHallPage(),
    ManageClientPage()
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Center(child: Screens[index]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 38, 38, 38),
        currentIndex: index,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Меню',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Заказы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_bar),
            label: 'Залы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'Админ',
          ),
        ],
      ),
    );
  }
}
