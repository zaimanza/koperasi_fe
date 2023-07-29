import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_object/components/center_button.dart';
import 'package:test_object/components/elevated_text_field.dart';
import 'package:test_object/middleware/regex.dart';
import 'package:test_object/modules/parcel_module.dart';
import 'package:test_object/pages/parcel_update_page.dart';
import 'package:test_object/providers/store_provider.dart';

import '../providers/internet_connectivity_provider.dart';

//
class ParcelInPage extends ConsumerStatefulWidget {
  const ParcelInPage({Key? key}) : super(key: key);

  @override
  _ParcelInPageState createState() => _ParcelInPageState();
}

class _ParcelInPageState extends ConsumerState<ParcelInPage> {
  bool isInitialized = false;
  TextEditingController courierController = TextEditingController();
  bool isCourierEmpty = false;
  bool isCourierErr = false;

  TextEditingController trackingNumberController = TextEditingController();
  bool isTrackingNumberEmpty = false;
  bool isTrackingNumberErr = false;

  TextEditingController phoneNumberController = TextEditingController();
  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberErr = false;

  TextEditingController remarksController = TextEditingController();
  bool isRemarksEmpty = false;
  bool isRemarksErr = false;

  bool isHoldCourier = false;
  bool isShowCircleIndicator = false;

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

  onTapClearAll() async {
    setState(() {
      isHoldCourier = false;
      courierController.text = "";
      trackingNumberController.text = "";
      phoneNumberController.text = "";
      remarksController.text = "";
    });
  }

  onChangedCourier() {
    setState(() {
      isCourierEmpty = false;
      isCourierErr = false;
    });
  }

  onTapClearSave() async {
    if (courierController.text.isNotEmpty && isHoldCourier == false) {
      setState(() {
        isHoldCourier = true;
      });
    } else if (isHoldCourier) {
      setState(() {
        isHoldCourier = false;
        courierController.text = "";
      });
    } else if (courierController.text.isEmpty && isHoldCourier == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill courier name to save.'),
        ),
      );
    }
  }

  onChangedTrackingNumber() {
    setState(() {
      isTrackingNumberEmpty = false;
      isTrackingNumberErr = false;
    });
  }

  onTapQR() async {
    List barcodes = [];
    try {
      await FlutterMobileVision.start().then((value) async {
        barcodes = await FlutterMobileVision.scan();
      });
      if (barcodes.isNotEmpty) {
        for (Barcode barcode in barcodes) {
          trackingNumberController.text = barcode.displayValue;
          setState(() {
            isTrackingNumberEmpty = false;
            isTrackingNumberErr = false;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  onChangedPhoneNumber() {
    setState(() {
      isPhoneNumberEmpty = false;
      isPhoneNumberErr = false;
    });
  }

  onChangedRemarks() {
    setState(() {
      isRemarksEmpty = false;
      isRemarksErr = false;
    });
  }

  onTapSaveSendWhatsapp() async {
    if (ref.read(internetConnectivityProvider).connectionStatus == true) {
      setState(() {
        isShowCircleIndicator = true;
      });
      FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
      var isPhoneNumberValid = false;
      if (courierController.text.isEmpty) {
        setState(() {
          isCourierEmpty = true;
        });
      }
      if (trackingNumberController.text.isEmpty) {
        setState(() {
          isTrackingNumberEmpty = true;
        });
      }
      if (phoneNumberController.text.isEmpty) {
        setState(() {
          isPhoneNumberEmpty = true;
        });
      } else {
        isPhoneNumberValid =
            await regexPhoneNumber(phoneNumberController.text, "MY");
        if (isPhoneNumberValid == false) {
          setState(() {
            isPhoneNumberErr = true;
          });
        }
      }
      if (courierController.text.isNotEmpty &&
          trackingNumberController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          isPhoneNumberValid) {
        var newPhoneNumber = phoneNumberController.text;
        if (newPhoneNumber.startsWith("0")) {
          newPhoneNumber = "6" + newPhoneNumber;
        }
        newPhoneNumber = newPhoneNumber.replaceAll(" ", "");
        newPhoneNumber = newPhoneNumber.replaceAll("-", "");
        //fing parcel
        var findOneResult = await findOneParcel(
          trackingNumberController.text,
        );

        if (findOneResult.isEmpty) {
          //TODO: filter from mongo if value has exceed amount

          var isAdd = await addParcel(
            courierController.text,
            trackingNumberController.text,
            newPhoneNumber,
            remarksController.text,
          );
          if (isAdd == true) {
            if (isHoldCourier == false) {
              courierController.text = "";
            }
            trackingNumberController.text = "";
            phoneNumberController.text = "";
            remarksController.text = "";
          } else if (isAdd?.isNotEmpty && isAdd.runtimeType == String) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isAdd),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tracking number already exists."),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Tracking number already exists.",
              ),
              action: SnackBarAction(
                label: 'Update',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ParcelUpdatePage(
                        findOneResult: findOneResult,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
      setState(() {
        isShowCircleIndicator = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection."),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((value) {
      setState(() {
        isInitialized = true;
      });
    });
    ref.read(internetConnectivityProvider).startConnectionProvider();
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(internetConnectivityProvider).disposeConnectionProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcel In"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CenterButton(
                    backgroundColor: Colors.red,
                    onTap: onTapClearAll,
                    title: "Clear all",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextField(
                    hintText: 'Courier',
                    onChanged: onChangedCourier,
                    controller: courierController,
                  ),
                  if (isCourierEmpty || isCourierErr) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Needs to contain courier name.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 30,
                  ),
                  CenterButton(
                    backgroundColor: isHoldCourier ? Colors.red : Colors.green,
                    onTap: onTapClearSave,
                    title: isHoldCourier ? "Clear" : "Save",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ElevatedTextField(
                          hintText: 'Tracking number',
                          onChanged: onChangedTrackingNumber,
                          controller: trackingNumberController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: onTapQR,
                          child: const SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.qr_code,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isTrackingNumberEmpty || isTrackingNumberErr) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Needs to contain tracking number.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextField(
                    hintText: 'Phone number',
                    onChanged: onChangedPhoneNumber,
                    controller: phoneNumberController,
                  ),
                  if (isPhoneNumberEmpty || isPhoneNumberErr) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "invalid phone number.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextField(
                    hintText: 'Remarks',
                    onChanged: onChangedRemarks,
                    controller: remarksController,
                  ),
                  if (isRemarksEmpty || isRemarksErr) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Needs to contain remarks.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 30,
                  ),
                  CenterButton(
                    backgroundColor: Colors.green,
                    onTap: onTapSaveSendWhatsapp,
                    title: 'Add Parcel',
                  )
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
