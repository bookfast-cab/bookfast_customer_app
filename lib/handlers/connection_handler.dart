import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart' as c_plus;
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionHandler {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionHandler _singleton = ConnectionHandler._internal();
  ConnectionHandler._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionHandler getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = new StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
   void _connectionChange(List< ConnectivityResult> result) {
//  void _connectionChange( ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   hasConnection = true;
      // } else {
      //   hasConnection = false;
      // }
      final connectivityResult = await (c_plus.Connectivity().checkConnectivity());
      if (connectivityResult == c_plus.ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        hasConnection = true;
      } else if (connectivityResult == c_plus.ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        hasConnection = true;
      } else if (connectivityResult == c_plus.ConnectivityResult.ethernet) {
        // I am connected to a ethernet network.
        hasConnection = true;
      } else if (connectivityResult == c_plus.ConnectivityResult.vpn) {
        hasConnection = true;
        // I am connected to a vpn network.
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
      } else if (connectivityResult == c_plus.ConnectivityResult.bluetooth) {
        hasConnection = true;
        // I am connected to a bluetooth.
      } else if (connectivityResult == c_plus.ConnectivityResult.other) {
        hasConnection = true;
        // I am connected to a network which is not in the above mentioned networks.
      } else if (connectivityResult == c_plus.ConnectivityResult.none) {
        // I am not connected to any network.
        hasConnection = false;
      }

      // return isConnected;
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
