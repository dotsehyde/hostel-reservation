import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/notification.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/pages/paystack_web.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentPage extends StatefulWidget {
  final RoomModel room;
  final String hostelId;
  const PaymentPage({super.key, required this.room, required this.hostelId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final phoneController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String selNetwork = "Select Network";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Text(
            "Make Payment",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(builder: (context, size) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Form(
              key: _formKey,
              child: Column(children: [
                40.height,
                Text("Room: ${widget.room.name}",
                    style: TextStyle(fontSize: 20.sp)),
                Text(
                  "Price: GHS ${widget.room.price}",
                  style: TextStyle(fontSize: 20.sp),
                ),
                // Container(
                //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                //     decoration: BoxDecoration(
                //       color: bgColor,
                //       borderRadius: BorderRadius.zero,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.6),
                //           spreadRadius: 0,
                //           blurRadius: 0,
                //           offset: const Offset(5, 5),
                //         ),
                //       ],
                //     ),
                //     child: DropdownButtonHideUnderline(
                //       child: DropdownButtonFormField<String>(
                //         value: selNetwork,
                //         onChanged: (String? newValue) {
                //           setState(() {
                //             selNetwork = newValue!;
                //           });
                //         },
                //         validator: (val) {
                //           if (val == "Select Network") {
                //             return "Please select a network";
                //           }
                //         },
                //         items: <String>[
                //           'Select Network',
                //           'MTN',
                //           'AirtelTigo',
                //           'Telecel'
                //         ].map<DropdownMenuItem<String>>((String value) {
                //           return DropdownMenuItem<String>(
                //             value: value,
                //             child:
                //                 Text(value, style: TextStyle(fontSize: 20.sp)),
                //           );
                //         }).toList(),
                //       ),
                //     )),

                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 3.h),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.zero,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.6),
                //           spreadRadius: 0,
                //           blurRadius: 0,
                //           offset: const Offset(5, 5),
                //         ),
                //       ],
                //     ),
                //     child: TextFormField(
                //       keyboardType: TextInputType.phone,
                //       textInputAction: TextInputAction.done,
                //       style: TextStyle(fontSize: 19.sp),
                //       controller: phoneController,
                //       validator: (value) {
                //         if (value!.isEmpty) {
                //           return "Phone number is required";
                //         }
                //         if (value.isNotEmpty && value.length < 10) {
                //           return "Please enter a valid phone number";
                //         }
                //         return null;
                //       },
                //       decoration: InputDecoration(
                //           border: const OutlineInputBorder(
                //               borderRadius: BorderRadius.zero),
                //           hintText: "Phone Number",
                //           fillColor: bgColor,
                //           filled: true,
                //           prefixIcon: Icon(
                //             Icons.phone,
                //             size: 22.sp,
                //           )),
                //     ),
                //   ),
                // ),
                TextButton.icon(
                    icon: Icon(
                      Icons.arrow_forward_outlined,
                      size: 22.sp,
                    ),
                    iconAlignment: IconAlignment.end,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      var u = widget.room;
                      confirmDialog(context,
                          title: "Reserve bed",
                          message:
                              "Are you want to reserve this bed at ${u.name}?",
                          onConfirm: () async {
                        try {
                          Navigator.pop(context);
                          // loadingDialog(context, text: "Reserving room...");
                          var user =
                              await UserModel.getUser(auth.currentUser!.uid);
                          if (u.capacity == 0) {
                            Navigator.pop(context);
                            errorDialog(context, message: "Room is full");
                            return;
                          }
                          makePayment(
                            email: user.email,
                            amount: (double.parse(u.price) * 100).toInt(),
                            isDeposit: false,
                          ).then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PayStackWeb(
                                          url: value.data.authorizationUrl,
                                          reference: value.data.reference,
                                          isDeposit: false,
                                        ))).then((res) async {
                              if (res) {
                                var docRef =
                                    db.collection('reservations').doc();
                                var reserve = ReserveModel(
                                    id: docRef.id,
                                    bookerId: user.id,
                                    roomId: widget.hostelId,
                                    room: u,
                                    booker: user,
                                    createdAt: DateTime.now(),
                                    status: "active");
                                await docRef.set(reserve.toMap());
                                //update room capacity
                                await db
                                    .collection('rooms')
                                    .doc(widget.hostelId)
                                    .collection("rooms")
                                    .doc(u.id)
                                    .update({'capacity': u.capacity - 1});
                                Navigator.pop(context);
                                Navigator.pop(context);
                                var adminToken = (await db
                                        .collection("users")
                                        .where("isAdmin", isEqualTo: true)
                                        .get())
                                    .docs
                                    .first
                                    .get("token");
                                await FcmHelper.sendNotification(
                                  toToken: adminToken,
                                  title: "New Reservation",
                                  body:
                                      "${user.name} has reserved a bed at ${u.name} for GHS ${u.price}.\nCheck reservation page for more details",
                                );
                                successDialog(context,
                                        title: "Bed Reserved",
                                        message:
                                            "Bed reserved successfully.\nKindly check the reservation page for more details")
                                    .then((_) {});
                              } else {
                                errorDialog(context,
                                    message: "Transaction not successful");
                              }
                            });
                          });
                          // Navigator.pop(context);
                        } on FirebaseException catch (error) {
                          Navigator.pop(context);
                          errorDialog(context, message: error.message);
                        }
                      });
                    },
                    label: Text(
                      "Pay with Paystack",
                      style: TextStyle(fontSize: 20.sp),
                    )),
              ]),
            ),
          );
        }));
  }

  Future<PayStackData> makePayment({
    required String email,
    required int amount,
    required bool isDeposit,
  }) async {
    try {
      var response = await Dio().post<Map<String, dynamic>>(
          "https://api.paystack.co/transaction/initialize",
          options: Options(headers: {
            "Authorization": "Bearer $payKey",
            "Content-Type": "application/json",
          }),
          data: {
            "email": email,
            "amount": amount.toString(),
            "currency": "GHS",
            "channels": ["card", "mobile_money"],
            "callback_url": "https://hostelhub.com",
          });
      if (response.statusCode == 200) {
        var data = PayStackData.fromJson(response.data ?? {});
        if (isDeposit) {
        } else {}
        return data;
      } else {
        throw Exception(
            "We could not process your request. Please try again later.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkTransactionStatus(String ref, bool isDeposit) async {
    try {
      /// Getting data, passing [ref] as a value to the URL that is being requested.
      var response = await Dio().get<Map<String, dynamic>>(
        'https://api.paystack.co/transaction/verify/$ref',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $payKey',
        }),
      );
      if (response.statusCode == 200) {
        if (response.data!["data"]["gateway_response"] == "Approved") {
          if (isDeposit) {
          } else {
            errorDialog(context, message: "Transaction not successful");
          }
          return true;
        } else {
          return false;
        }
      } else {
        /// Anything else means there is an issue
        throw Exception(
            "Response Code: ${response.statusCode}, Response Body${response.data}");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class PayWithPaystack {}

class PayStackData {
  final bool status;
  final String message;
  final Data data;

  PayStackData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PayStackData.fromJson(Map<String, dynamic> json) => PayStackData(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final String authorizationUrl;
  final String accessCode;
  final String reference;

  Data({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        authorizationUrl: json["authorization_url"],
        accessCode: json["access_code"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "authorization_url": authorizationUrl,
        "access_code": accessCode,
        "reference": reference,
      };
}
