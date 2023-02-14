import 'package:bistro_admin_app/models/MenuModel.dart';

class MenuEvent {}

class GetMenu extends MenuEvent {}

class AddPosition extends MenuEvent {
  Position? position;
  AddPosition(this.position);
}
