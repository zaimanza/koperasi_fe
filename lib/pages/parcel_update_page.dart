import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/center_button.dart';
import '../components/elevated_text_field_side_text.dart';
import '../middleware/change_to_url.dart';
import '../modules/parcel_module.dart';
import '../providers/internet_connectivity_provider.dart';
import '../providers/store_provider.dart';

class ParcelUpdatePage extends ConsumerStatefulWidget {
  const ParcelUpdatePage({
    Key? key,
    required this.findOneResult,
  }) : super(key: key);
  final Map findOneResult;

  @override
  _ParcelUpdatePageState createState() => _ParcelUpdatePageState();
}

class _ParcelUpdatePageState extends ConsumerState<ParcelUpdatePage> {
  TextEditingController recipientController = TextEditingController();
  bool isRecipientEmpty = false;
  bool isRecipientErr = false;

  TextEditingController recipientPhoneNumberController =
      TextEditingController();
  bool isRecipientPhoneNumberEmpty = false;
  bool isRecipientPhoneNumberErr = false;

  TextEditingController trackingNumberController = TextEditingController();
  bool isTrackingNumberEmpty = false;
  bool isTrackingNumberErr = false;

  TextEditingController courierController = TextEditingController();
  bool isCourierEmpty = false;
  bool isCourierErr = false;

  TextEditingController trackingNumberResultController =
      TextEditingController();
  bool isTrackingNumberResultEmpty = false;
  bool isTrackingNumberResultErr = false;

  TextEditingController phoneNumberController = TextEditingController();
  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberErr = false;

  TextEditingController remarksController = TextEditingController();
  bool isRemarksEmpty = false;
  bool isRemarksErr = false;

  TextEditingController createdDateController = TextEditingController();
  bool isCreatedDateEmpty = false;
  bool isCreatedDateErr = false;

  TextEditingController pickedOutDateController = TextEditingController();
  bool isPickedOutDateEmpty = false;
  bool isPickedOutDateErr = false;

  bool isHoldRecipient = false;
  bool isCanViewResult = false;
  bool isUpdated = false;
  bool isShowCircleIndicator = false;

  setData() {
    print(widget.findOneResult);
    recipientController.text = widget.findOneResult["recipient_name"] ?? "";
    recipientPhoneNumberController.text =
        widget.findOneResult["recipient_phone_number"] ?? "";
    trackingNumberController.text =
        widget.findOneResult["tracking_number"] ?? "";
    courierController.text = widget.findOneResult["courier"] ?? "";
    trackingNumberResultController.text =
        widget.findOneResult["tracking_number"] ?? "";
    phoneNumberController.text = widget.findOneResult["phone_number"] ?? "";
    remarksController.text = widget.findOneResult["remarks"] ?? "";
    createdDateController.text = widget.findOneResult["created_at"] ?? "";
    pickedOutDateController.text = widget.findOneResult["picked_out_at"] ?? "";
  }

  getAdvertisement() {
    if (ref.read(storeProvider).advertisement != "") {
      return "\n\nIKLAN: " + "\n" + ref.read(storeProvider).advertisement;
    }
    return "";
  }

  getNotification() {
    if (ref.read(storeProvider).notification != "") {
      return "\n\nPEMBERITAHUAN: " +
          "\n" +
          ref.read(storeProvider).notification;
    }
    return "";
  }

  getOperationHour() {
    if (ref.read(storeProvider).operationHour != "") {
      return "\n\nWAKTU OPERASI: " +
          "\n" +
          ref.read(storeProvider).operationHour;
    }
    return "";
  }

  getRemarks() {
    if (remarksController.text.isNotEmpty) {
      return "\n\nREMARKS: " + remarksController.text;
    }
    return "";
  }

  sendWhatsapp() async {
    var message = changeToUrl(
      "ASSALAMULAIKUM DAN SALAM SEJAHTERA DARI: " +
          ref.read(storeProvider).storeName +
          getNotification() +
          getAdvertisement() +
          "\n\n" +
          "TRACKING PARCEL ANDA: " +
          trackingNumberController.text +
          "\n\n" +
          "COURIER: " +
          courierController.text +
          "\n\n" +
          "SILA BUKA PAUTAN UNTUK KOD QR TRACKING ANDA. PAUTAN: " +
          "\n" +
          "https://chart.apis.google.com/chart?cht=qr&chs=300x300&chl=" +
          changeToUrl(trackingNumberController.text) +
          "&chld=H|2" +
          getRemarks() +
          "\n\n" +
          "CAJ ANDA: RM2.00" +
          getOperationHour() +
          "\n\n" +
          "TERIMA KASIH",
    );

    var whatsapp = phoneNumberController.text;
    if (whatsapp.startsWith("0")) {
      whatsapp = "+6" + whatsapp;
    }
    whatsapp = whatsapp.replaceAll(" ", "");
    whatsapp = whatsapp.replaceAll("-", "");
    var whatsappURLAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=$message";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse(message)}";
    if (Platform.isIOS) {
      if (await canLaunch(whatsappURLIos)) {
        await launch(whatsappURLIos);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Whatsapp no installed"),
          ),
        );
      }
    } else {
      if (await canLaunch(whatsappURLAndroid)) {
        await launch(whatsappURLAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Whatsapp no installed"),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(internetConnectivityProvider).startConnectionProvider();
    setData();
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(internetConnectivityProvider).disposeConnectionProvider();
  }

  ScrollController pageScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcel Update"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            controller: pageScrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Recipient',
                    onChanged: () {
                      setState(() {
                        isRecipientEmpty = false;
                        isRecipientErr = false;
                      });
                    },
                    controller: recipientController,
                    enabled: false,
                    titleText: 'Recipient',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Recipient phone number',
                    onChanged: () {
                      setState(() {
                        isRecipientPhoneNumberEmpty = false;
                        isRecipientPhoneNumberErr = false;
                      });
                    },
                    controller: recipientPhoneNumberController,
                    enabled: false,
                    titleText: 'Recipient phone number',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Courier',
                    onChanged: () {
                      setState(() {
                        isCourierEmpty = false;
                        isCourierErr = false;
                      });
                    },
                    controller: courierController,
                    enabled: false,
                    titleText: 'Courier',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Tracking number',
                    onChanged: () {
                      setState(() {
                        isTrackingNumberResultEmpty = false;
                        isTrackingNumberResultErr = false;
                      });
                    },
                    controller: trackingNumberResultController,
                    enabled: false,
                    titleText: 'Tracking number',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Phone number',
                    onChanged: () {
                      setState(() {
                        isPhoneNumberEmpty = false;
                        isPhoneNumberErr = false;
                      });
                    },
                    controller: phoneNumberController,
                    enabled: true,
                    titleText: 'Phone number',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Remarks',
                    onChanged: () {
                      setState(() {
                        isRemarksEmpty = false;
                        isRemarksErr = false;
                      });
                    },
                    controller: remarksController,
                    enabled: true,
                    titleText: 'Remarks',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Created date',
                    onChanged: () {
                      setState(() {
                        isCreatedDateEmpty = false;
                        isCreatedDateErr = false;
                      });
                    },
                    controller: createdDateController,
                    enabled: false,
                    titleText: 'Created date',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextFieldSideText(
                    hintText: 'Picked out date',
                    onChanged: () {
                      setState(() {
                        isPickedOutDateEmpty = false;
                        isPickedOutDateErr = false;
                      });
                    },
                    controller: pickedOutDateController,
                    enabled: false,
                    titleText: 'Picked out date',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CenterButton(
                    backgroundColor: Colors.green,
                    onTap: () async {
                      var newPhoneNumber = phoneNumberController.text;
                      if (newPhoneNumber.startsWith("0")) {
                        newPhoneNumber = "6" + newPhoneNumber;
                      }
                      newPhoneNumber = newPhoneNumber.replaceAll(" ", "");
                      newPhoneNumber = newPhoneNumber.replaceAll("-", "");
                      setState(() {
                        isShowCircleIndicator = true;
                      });
                      var response = await updateOneParcel({
                        "tracking_number": trackingNumberController.text,
                        "phone_number": newPhoneNumber,
                        "remarks": remarksController.text,
                      });
                      setState(() {
                        isShowCircleIndicator = false;
                        isUpdated = true;
                        pageScrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      });
                    },
                    title: "Update Parcel",
                  ),
                  if (isUpdated) ...[
                    const SizedBox(
                      height: 30,
                    ),
                    CenterButton(
                      backgroundColor: Colors.green,
                      onTap: () async {
                        sendWhatsapp();
                        Navigator.pop(context);
                      },
                      title: "Send whatsapp",
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isShowCircleIndicator) ...[
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}
