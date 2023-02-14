import 'dart:async';

abstract class BlocBase {
  StreamController _eventController = StreamController.broadcast();
  StreamController _stateController = StreamController.broadcast();

  Sink get _eventIn => _eventController.sink;
  Stream get state => _stateController.stream;
  Sink get _stateIn => _stateController.sink;

  BlocBase() {
    _eventController.stream.listen(eventHandler);
  }

  void emitState(state) {
    _stateIn.add(state);
  }

  void sendEvent(event) {
    _eventIn.add(event);
  }

  void eventHandler(event);

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
