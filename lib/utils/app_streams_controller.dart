import 'dart:async';

class AppStreamController {
  AppStreamController._internal();
  static final AppStreamController _instance = AppStreamController._internal();
  static AppStreamController get instance => _instance;

  StreamController<double> updateNewTripList = StreamController.broadcast();

  Stream<double> get updateNewTripListAction => updateNewTripList.stream;

  void disposeUpdateNewTripListStream() => updateNewTripList.close();

  void rebuildUpdateNewTripListStream() {
    if (updateNewTripList.isClosed) {
      updateNewTripList = StreamController.broadcast();
    }
  }
}
