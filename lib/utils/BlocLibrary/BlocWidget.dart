import 'package:flutter/material.dart';

class BlocSubscriptor extends StatefulWidget {
  Stream stream;
  Widget initialWidget;
  dynamic state;
  dynamic buider;
  BlocSubscriptor(
      {required this.stream,
      required this.state,
      required this.initialWidget,
      required this.buider});

  @override
  State<BlocSubscriptor> createState() =>
      _BlocSubscriptorState(stream, state, initialWidget, buider);
}

class _BlocSubscriptorState extends State<BlocSubscriptor> {
  Stream? stream;
  late Widget child;
  Widget initialWidget;
  dynamic state;
  dynamic builder;
  Widget? temp;
  _BlocSubscriptorState(
      this.stream, this.state, this.initialWidget, this.builder);

  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data.runtimeType == state) {
      print(builder);
      temp = builder;
      return builder(snapshot.data);
    }
    if (temp == null) return initialWidget;
    return temp!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: stream, builder: _builder);
  }
}
