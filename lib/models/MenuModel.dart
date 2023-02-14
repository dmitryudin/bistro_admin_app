import 'dart:convert';

import 'package:bistro_admin_app/models/BasicModel.dart';

class Option implements BasicModel {
  Option();
  double price = 0.0;
  String name = '';
  int count = 1;
  bool isSelected = false;

  @override
  String toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['price'] = price;
    data['is_selected'] = isSelected;
    String json = jsonEncode(data);
    return json;
  }

  Option.fromJson(String json) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    name = jsonMap['name'];
    price = jsonMap['price'];
    isSelected = jsonMap['is_selected'];
  }
}

class Switch {
  String name = '';
  List<Option> fields = [];
  Option selectedField = Option();
  Switch();

  String toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['name'] = name;
    jsonMap['fields'] = fields.map((e) => jsonDecode(e.toJson())).toList();
    jsonMap['selected_field'] = jsonDecode(selectedField.toJson());
    String json = jsonEncode(jsonMap);
    return json;
  }

  Switch.fromJson(String json) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    name = jsonMap['name'];
    selectedField = Option.fromJson(jsonEncode(jsonMap['selected_field']));
    List<dynamic> temp = jsonMap['fields'];
    fields = temp.map((e) => (Option.fromJson(jsonEncode(e)))).toList();
  }
}

class Position {
  Position();
  int id = -1;
  String category = '';
  String subcategory = '';
  String name = '';
  String description = '';
  String picture = '';
  double amount = 0.0; // Число (объем для напитков, вес для блюд)
  double basePrice = 0.0;
  double totalCost = 0.0;
  int count = 1;

  Switch switchField = Switch();
  List<Option> options = [];

  String toJson() {
    Map<String, dynamic> data = {};
    data['category'] = category;
    data['subcategory'] = subcategory;
    data['name'] = name;
    data['description'] = description;
    data['picture'] = picture;
    data['amount'] = amount;
    data['base_price'] = basePrice;
    data['total_cost'] = totalCost;
    data['count'] = count;
    data['options'] = options.map((e) => jsonDecode(e.toJson())).toList();
    if (!switchField.fields.isEmpty)
      data['switchField'] = jsonDecode(switchField.toJson());
    else
      data['field_selection'] = [];
    return jsonEncode(data);
  }

  Position.fromJson(String data) {
    Map<String, dynamic> jsonMap = jsonDecode(data);
    try {
      id = jsonMap['id'];
    } catch (e) {}
    category = jsonMap['category'];
    subcategory = jsonMap['subcategory'];
    name = jsonMap['name'];

    description = jsonMap['description'];
    picture = jsonMap['picture'];
    amount = jsonMap['amount'];
    basePrice = jsonMap['base_price'];
    try {
      totalCost = jsonMap['total_cost'];
      count = jsonMap['count'];
    } catch (e) {}

    switchField = Switch.fromJson(jsonEncode(jsonMap['switch_field']));

    List<dynamic> temp = jsonMap['options'];
    options = temp.map((e) => (Option.fromJson(jsonEncode(e)))).toList();
  }

  Position getDeepCopy() {
    Position deepDishCopy = Position();
    deepDishCopy.id = this.id;
    deepDishCopy.category = this.category;
    deepDishCopy.picture = this.picture;
    deepDishCopy.name = this.name;
    deepDishCopy.amount = this.amount;
    deepDishCopy.count = int.parse(this.count.toString());
    deepDishCopy.description = this.description;
    deepDishCopy.options = this.options;
    deepDishCopy.switchField = this.switchField;
    return deepDishCopy;
  }
}
