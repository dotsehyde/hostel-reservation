import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 32.sp),
            Text("You are not logged in")
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Reservations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: StreamBuilder(
        stream: db
            .collection('reservations')
            .where("bookerId", isEqualTo: auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Column(
                children: [
                  Icon(Icons.error, size: 32.sp),
                  Text(snap.error.toString())
                ],
              ),
            );
          }
          if (snap.hasData) {
            List<ReserveModel> data = snap.requireData.docs
                .map((e) => ReserveModel.fromMap(e.data()))
                .toList();
            if (data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt,
                      size: 45.sp,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                    Text("No Reservations yet")
                  ],
                ),
              );
            }
            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, i) => Divider(
                indent: 3.w,
                endIndent: 3.w,
              ),
              itemBuilder: (context, index) {
                var u = data[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset:
                              const Offset(5, 8), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.zero),
                  width: 100.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Information",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.sp),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Name: ${u.booker.name}",
                              style: TextStyle(fontSize: 16.sp)),
                          Text("Student ID: ${u.booker.studentId}",
                              style: TextStyle(fontSize: 16.sp)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Email: ${u.booker.email}",
                              style: TextStyle(fontSize: 16.sp)),
                          Text("Phone: ${u.booker.phone}",
                              style: TextStyle(fontSize: 16.sp)),
                        ],
                      ),
                      Text(
                        "Room Information",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.sp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Room: ${u.room.name}",
                              style: TextStyle(fontSize: 16.sp)),
                          Text("Price: GHS ${u.room.price}",
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.green[900])),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(u.createdAt.timeAgo),
                          Text("Status: ${u.status.toUpperCase()}",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: u.status == "active"
                                      ? Colors.amber
                                      : u.status == "cancelled"
                                          ? Colors.red[600]
                                          : Colors.blue[800])),
                        ],
                      ),
                      TextButton(
                              style: TextButton.styleFrom(
                                  minimumSize: Size(100.w, 1.h),
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                confirmDialog(context,
                                    message:
                                        "Are you sure you want to cancel this reservation?",
                                    title: "Cancel Reservation", onConfirm: () {
                                  loadingDialog(context,
                                      text: "Please wait...");
                                  db
                                      .collection("reservations")
                                      .doc(u.id)
                                      .update({"status": "cancelled"}).then(
                                          (_) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }).catchError((e) {
                                    Navigator.pop(context);
                                    errorDialog(context, message: e.toString());
                                  });
                                });
                              },
                              child: Text("Cancel Reservation",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.sp)))
                          .visible(u.status == "active"),
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
