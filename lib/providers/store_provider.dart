import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreProvider extends ChangeNotifier {
  StoreProvider(this.ref) : super();
  final Ref ref;
  String storeName = "";
  String advertisement = "";
  String operationHour = "";
  String notification = "";
  String parcelCharge = "";
  bool initialPrefCall = false;

  initState() async {
    if (initialPrefCall == false) {
      getSharedPreference();
    }
  }

  setStore(storeName, advertisement, operationHour, notification,
      parcelCharge) async {
    this.storeName = storeName;
    this.advertisement = advertisement;
    this.operationHour = operationHour;
    this.notification = notification;
    this.parcelCharge = parcelCharge;
    notifyListeners();
    syncSharedPreference();
  }

  Future getSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('storeName') != null) {
      storeName = sharedPreferences.getString('storeName')!;
    }
    if (sharedPreferences.getString('advertisement') != null) {
      advertisement = sharedPreferences.getString('advertisement')!;
    }
    if (sharedPreferences.getString('operationHour') != null) {
      operationHour = sharedPreferences.getString('operationHour')!;
    }
    if (sharedPreferences.getString('notification') != null) {
      notification = sharedPreferences.getString('notification')!;
    }
    if (sharedPreferences.getString('parcelCharge') != null) {
      parcelCharge = sharedPreferences.getString('parcelCharge')!;
    }

    initialPrefCall = true;
    notifyListeners();
  }

  syncSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('storeName', storeName);
    await sharedPreferences.setString('advertisement', advertisement);
    await sharedPreferences.setString('operationHour', operationHour);
    await sharedPreferences.setString('notification', notification);
    await sharedPreferences.setString('parcelCharge', parcelCharge);
  }
}

final storeProvider = ChangeNotifierProvider<StoreProvider>((ref) {
  return StoreProvider(ref);
});
