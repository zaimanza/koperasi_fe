import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/center_button.dart';
import '../components/elevated_text_field_side_text.dart';
import '../modules/parcel_module.dart';
import '../providers/internet_connectivity_provider.dart';

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
    recipientController.text =
        widget.findOneResult["recipient_name"].toString() ?? "";
    recipientPhoneNumberController.text =
        widget.findOneResult["recipient_phone_number"].toString() == 0
            ? ""
            : widget.findOneResult["recipient_phone_number"].toString() ?? "";
    trackingNumberController.text = widget.findOneResult["parcelId"] ?? "";
    courierController.text = widget.findOneResult["courier"] ?? "";
    trackingNumberResultController.text =
        widget.findOneResult["parcelId"] ?? "";
    phoneNumberController.text = widget.findOneResult["phone_number"] ?? "";
    remarksController.text = widget.findOneResult["remarks"] ?? "";

    createdDateController.text = widget.findOneResult["created_at"] ?? "";
    pickedOutDateController.text = widget.findOneResult["picked_out_at"] ?? "";
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
                        "parcelId": trackingNumberController.text,
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
                        Navigator.pop(context);
                      },
                      title: "Back to home",
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
