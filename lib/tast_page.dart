import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceEvents.dart';
import 'package:bistro_admin_app/bloc/PlaceBloc/PlaceStates.dart';
import 'package:bistro_admin_app/main.dart';
import 'package:bistro_admin_app/utils/BlocLibrary/BlocWidget.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSubscriptor(
            initialWidget: Column(),
            stream: BlocProvider.of(context).placeBloc.state,
            state: PlaceStateTest,
            buider: (PlaceStateTest data) {
              return Text(data.text!);
            }),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of(context).placeBloc.sendEvent(PlaceEventTest());
            },
            child: Text('нажми'))
      ],
    );
  }
}
