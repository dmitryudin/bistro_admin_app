import 'package:flutter/cupertino.dart';

class CreateHallWidget extends StatefulWidget {
  late String url;
  CreateHallWidget({required this.url, super.key});

  @override
  State<CreateHallWidget> createState() => _CreateHallWidgetState(url);
}

class _CreateHallWidgetState extends State<CreateHallWidget> {
  late String url;
  _CreateHallWidgetState(this.url);
  @override
  Widget build(BuildContext context) {
    return Image.network(url);
  }
}
