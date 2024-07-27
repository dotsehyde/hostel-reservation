import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentPage extends StatefulWidget {
  final RoomModel room;
  const PaymentPage({super.key, required this.room});

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
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.zero,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: selNetwork,
                        onChanged: (String? newValue) {
                          setState(() {
                            selNetwork = newValue!;
                          });
                        },
                        validator: (val) {
                          if (val == "Select Network") {
                            return "Please select a network";
                          }
                        },
                        items: <String>[
                          'Select Network',
                          'MTN',
                          'AirtelTigo',
                          'Telecel'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:
                                Text(value, style: TextStyle(fontSize: 20.sp)),
                          );
                        }).toList(),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.zero,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 19.sp),
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone number is required";
                        }
                        if (value.isNotEmpty && value.length < 10) {
                          return "Please enter a valid phone number";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero),
                          hintText: "Phone Number",
                          fillColor: bgColor,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 22.sp,
                          )),
                    ),
                  ),
                ),
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
                          loadingDialog(context, text: "Reserving room...");
                          var user =
                              await UserModel.getUser(auth.currentUser!.uid);

                          if (u.capacity == 0) {
                            Navigator.pop(context);
                            errorDialog(context, message: "Room is full");
                            return;
                          }
                          var docRef = db.collection('reservations').doc();
                          var reserve = ReserveModel(
                              id: docRef.id,
                              bookerId: user.id,
                              roomId: u.id,
                              room: u,
                              booker: user,
                              createdAt: DateTime.now(),
                              status: "active");
                          await docRef.set(reserve.toMap());
                          //update room capacity
                          await db
                              .collection('rooms')
                              .doc(u.id)
                              .update({'capacity': u.capacity - 1});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } on FirebaseException catch (error) {
                          Navigator.pop(context);
                          errorDialog(context, message: error.message);
                        }
                      });
                    },
                    label: Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 20.sp),
                    )),
              ]),
            ),
          );
        }));
  }
}
