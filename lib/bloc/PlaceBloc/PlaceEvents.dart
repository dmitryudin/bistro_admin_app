class PlaceEvent {}

class PlaceEventTest {}

class PlaceEventGetInformation extends PlaceEvent {
  int? id;
  PlaceEventGetInformation({required this.id});
}

class PlaceEventUpdatePhoto extends PlaceEvent {
  List<String> photos;
  PlaceEventUpdatePhoto({required this.photos});
}
