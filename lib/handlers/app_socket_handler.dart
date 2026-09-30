import 'dart:convert';

import 'package:bookfast_customer/handlers/session_handler/session_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../services/networking/api_constants.dart';
import '../utils/app_functions.dart';

class AppSocketHandler {
  var searchingMessage = "Finding a driver...";
  late socket_io.Socket socket;
  bool isInitialized = false;

  Future<bool> init({Function? onConnect}) async {

    String? token = await SessionManager.getAuthToken();

    print('AppSocketHandler: init');
    socket = socket_io.io(
    ApiConstants.socketBaseUrl,
    socket_io.OptionBuilder()
        .enableMultiplex()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect() // disable auto-connection
        .setExtraHeaders({"authorization":token})
        .build());
    isInitialized = true;
    socket.connect();
    socket.onConnect((data) {
      if (onConnect != null) {
        onConnect();
      }
      print('AppSocketHandler: Connect, $data');
      socket.onAny((event, data) {
        // print("Driver received event: $event with data: $data");
      });
    });
    // socket.onConnecting((data) {
    //   print('AppSocketHandler: Connecting, $data');
    // });
    socket.onDisconnect((_) {
      print('AppSocketHandler: Disconnected');
    });
    socket.onConnectError((err) {
      print("AppSocketHandler: onConnectError $err");
    });
    socket.onError((err) {
      print("AppSocketHandler: onError $err");
    });
    return true;
  }

  void checkConnection() {
    if (socket.disconnected) {
      socket.disconnect();
      socket.connect();
    }
  }

  socket_io.Socket getSocket() {
    return socket;
  }

  void disposeSocket() {
    if(socket != null) {
      socket.disconnect();
      socket.dispose();
      print('Socket disposed');
    }
  }

  Future<void> emitUpdateLocation(Map<String, dynamic> map) async {
    if (socket.disconnected) {
      socket.connect();
    }
    print('AppSocketHandler: updateUserLocation => $map');
    socket.emit(ApiConstants.ioCustomerSocket, map);
  }

  Future<void> listenUpdateLocation({required Function(dynamic)? data, required String userId}) async {
    print("\n\nunder listenUpdateLocation --> ${ApiConstants.ioListenUpdatedLocation(userId)}");
    if (!socket.hasListeners(ApiConstants.ioListenUpdatedLocation(userId))) {
      socket.on(ApiConstants.ioListenUpdatedLocation(userId /*await AppFunctions.getUserId()*/), (messages) {
        print("\n\nunder listenUpdateLocation listener data --> $messages");
        if (data != null) data(messages);
      });
    }
  }

  // void listenDriverLocationUpdate({required Function(dynamic) onData,}) {
  //   const eventName = "driverLocationUpdate";
  //   print("Listening to $eventName");
  //   if (!socket.hasListeners(eventName)) {
  //     socket.on(eventName, (data) {
  //       print("Received driverLocationUpdate: $data");
  //       onData(data);
  //     });
  //   }
  // }
  }
