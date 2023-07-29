import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Connectivity connectivity = Connectivity();

class InternetConnectivityProvider extends ChangeNotifier {
  InternetConnectivityProvider(this.ref) : super();
  final Ref ref;
  late bool connectionStatus;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  startConnectionProvider() async {
    await initConnectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  disposeConnectionProvider() {
    connectivitySubscription.cancel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
      updateConnectionStatus(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return;
    // }
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        connectionStatus = true;
        notifyListeners();
        break;
      case ConnectivityResult.none:
      default:
        connectionStatus = false;
        notifyListeners();
        break;
    }
  }
}

final internetConnectivityProvider =
    ChangeNotifierProvider<InternetConnectivityProvider>((ref) {
  return InternetConnectivityProvider(ref);
});
