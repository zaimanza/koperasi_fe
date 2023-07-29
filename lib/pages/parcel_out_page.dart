import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test_object/components/center_button.dart';
import 'package:test_object/components/elevated_text_field.dart';
import 'package:test_object/components/elevated_text_field_side_text.dart';
import 'package:test_object/modules/parcel_module.dart';

import '../providers/internet_connectivity_provider.dart';

class ParcelOutPage extends ConsumerStatefulWidget {
  const ParcelOutPage({Key? key}) : super(key: key);

  @override
  _ParcelOutPageState createState() => _ParcelOutPageState();
}

class _ParcelOutPageState extends ConsumerState<ParcelOutPage> {
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
  Map findOneResult = {};
  bool isCanViewResult = false;
  bool isShowCircleIndicator = false;

  @override
  void initState() {
    super.initState();
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
        title: const Text("Parcel Out"),
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
                  ElevatedTextField(
                    hintText: 'Recipient',
                    onChanged: () {
                      setState(() {
                        isRecipientEmpty = false;
                        isRecipientErr = false;
                      });
                    },
                    controller: recipientController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedTextField(
                    hintText: 'Recipient phone number',
                    onChanged: () {
                      setState(() {
                        isRecipientPhoneNumberEmpty = false;
                        isRecipientPhoneNumberErr = false;
                      });
                    },
                    controller: recipientPhoneNumberController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CenterButton(
                    backgroundColor:
                        isHoldRecipient ? Colors.red : Colors.green,
                    onTap: () async {
                      if (recipientController.text.isNotEmpty &&
                          isHoldRecipient == false) {
                        setState(() {
                          isHoldRecipient = true;
                        });
                      } else if (isHoldRecipient) {
                        setState(() {
                          isHoldRecipient = false;
                          recipientController.text = "";
                          recipientPhoneNumberController.text = "";
                        });
                      } else if ((recipientController.text.isEmpty) &&
                          isHoldRecipient == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fill recipient name to save.'),
                          ),
                        );
                      }
                    },
                    title: isHoldRecipient ? "Clear" : "Save",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ElevatedTextField(
                          hintText: 'Tracking number',
                          onChanged: () {
                            setState(() {
                              isTrackingNumberEmpty = false;
                              isTrackingNumberErr = false;
                            });
                          },
                          controller: trackingNumberController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            List barcodes = [];
                            try {
                              await FlutterMobileVision.start()
                                  .then((value) async {
                                barcodes = await FlutterMobileVision.scan();
                              });
                              if (barcodes.isNotEmpty) {
                                for (Barcode barcode in barcodes) {
                                  trackingNumberController.text =
                                      barcode.displayValue;
                                  setState(() {
                                    isTrackingNumberEmpty = false;
                                    isTrackingNumberErr = false;
                                  });
                                }
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
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
                  CenterButton(
                    backgroundColor: Colors.blue,
                    onTap: () async {
                      if (ref
                              .read(internetConnectivityProvider)
                              .connectionStatus ==
                          true) {
                        setState(() {
                          isShowCircleIndicator = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        FocusScope.of(context).unfocus();

                        if (trackingNumberController.text.isNotEmpty) {
                          findOneResult = await findOneParcel(
                            trackingNumberController.text,
                          );

                          if (findOneResult.isNotEmpty) {
                            print("HI_AIMAN_1");
                            print(findOneResult);
                            courierController.text =
                                findOneResult["courier"] ?? "";
                            trackingNumberResultController.text =
                                findOneResult["parcelId"] ?? "";
                            phoneNumberController.text =
                                findOneResult["phone_number"] ?? "";
                            remarksController.text =
                                findOneResult["remarks"] ?? "";
                            createdDateController.text =
                                findOneResult["created_at"] != null
                                    ? DateFormat('dd-MM-yyyy, H:m:s').format(
                                        DateTime.parse(
                                          findOneResult["created_at"],
                                        ),
                                      )
                                    : "";
                            pickedOutDateController.text =
                                findOneResult["picked_out_at"] != null
                                    ? DateFormat('dd-MM-yyyy, H:m:s').format(
                                        DateTime.parse(
                                          findOneResult["picked_out_at"] ?? "",
                                        ),
                                      )
                                    : "";
                            isCanViewResult = true;
                          } else {
                            isCanViewResult = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No result found."),
                              ),
                            );
                          }
                          setState(() {});
                        } else {
                          setState(() {
                            isTrackingNumberEmpty = true;
                          });
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
                    },
                    title: 'Search in database',
                  ),
                  if (isCanViewResult) ...[
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
                      enabled: false,
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
                      enabled: false,
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
                      backgroundColor: Colors.blue,
                      onTap: () async {
                        setState(() {
                          isShowCircleIndicator = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        FocusScope.of(context).unfocus();

                        dynamic response;

                        if (recipientController.text != "") {
                          if (pickedOutDateController.text == "") {
                            var newPhoneNumber =
                                recipientPhoneNumberController.text;
                            if (newPhoneNumber.startsWith("0")) {
                              newPhoneNumber = "6" + newPhoneNumber;
                            }
                            newPhoneNumber = newPhoneNumber.replaceAll(" ", "");
                            newPhoneNumber = newPhoneNumber.replaceAll("-", "");

                            response = await updateOneParcel({
                              "parcelId": trackingNumberResultController.text,
                              "picked_out_at": DateTime.now().toIso8601String(),
                              "recipient_name": recipientController.text,
                              "recipient_phone_number": newPhoneNumber,
                            });

                            if (recipientController.text != "" ||
                                pickedOutDateController.text == "") {
                              if (isHoldRecipient == false) {
                                recipientController.text = "";
                                recipientPhoneNumberController.text = "";
                              }
                              //clear tracking number
                              trackingNumberController.text = "";
                              //clear data bawah and tukar kpd false for view
                              isCanViewResult = false;
                              courierController.text = "";
                              trackingNumberResultController.text = "";
                              phoneNumberController.text = "";
                              remarksController.text = "";
                              createdDateController.text = "";
                              pickedOutDateController.text = "";
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Cannot be updated because have been picked out.'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recipient name must be filled.'),
                            ),
                          );
                        }

                        setState(() {
                          isShowCircleIndicator = false;
                        });
                      },
                      title: 'Picked out',
                    ),
                  ],
                  //  picked out
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
