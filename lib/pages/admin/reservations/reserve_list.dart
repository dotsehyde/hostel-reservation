import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/config/notification.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/pages/admin/rooms/add_room.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReserveListPage extends StatefulWidget {
  const ReserveListPage({super.key});

  @override
  State<ReserveListPage> createState() => _ReserveListPageState();
}

class _ReserveListPageState extends State<ReserveListPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text("Reservations",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: bgColor,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection("reservations").snapshots(),
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
                    Text(
                      "Nothing here!",
                      style: TextStyle(fontSize: 22.sp),
                    ).paddingSymmetric(vertical: 1.h),
                    Text(
                      "No reservations booked yet!",
                      style: TextStyle(fontSize: 16.sp),
                    )
                  ],
                ),
              );
            }
            return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, i) {
                  return Divider(indent: 3.w, endIndent: 3.w);
                },
                itemBuilder: (context, i) {
                  var u = data[i];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(
                                5, 8), // changes position of shadow
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
                          "Booker Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: Text("Name: ${u.booker.name}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                            Text("Student ID: ${u.booker.studentId}",
                                style: TextStyle(fontSize: 16.sp)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: Text("Email: ${u.booker.email}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                            Text("Phone: ${u.booker.phone}",
                                style: TextStyle(fontSize: 16.sp)),
                          ],
                        ),
                        Text(
                          "Room Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                        ),
                        StreamBuilder(
                            stream: db
                                .collection("rooms")
                                .doc(u.roomId)
                                .snapshots(),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                var room = snap.requireData.data();
                                return Text("Hostel: ${room?['name'] ?? "N/A"}",
                                    style: TextStyle(fontSize: 16.sp));
                              }
                              return Text("Room: Loading...",
                                  style: TextStyle(fontSize: 16.sp));
                            }),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                    style: TextButton.styleFrom(
                                        minimumSize: Size(45.w, 1.h),
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      confirmDialog(context,
                                          message:
                                              "Are you sure this ${u.booker.name} has checked in successfully?",
                                          title: "Check in student",
                                          onConfirm: () {
                                        loadingDialog(context,
                                            text: "Please wait...");
                                        db
                                            .collection("reservations")
                                            .doc(u.id)
                                            .update({
                                          "status": "checked in"
                                        }).then((_) {
                                          if (u.booker.token.isNotEmpty) {
                                            FcmHelper.sendNotification(
                                                toToken: u.booker.token,
                                                title: "Checked In",
                                                body:
                                                    "You have been checked in successfully. Enjoy your stay!");
                                          }
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }).catchError((e) {
                                          Navigator.pop(context);
                                          errorDialog(context,
                                              message: e.toString());
                                        });
                                      });
                                    },
                                    child: Text("Checked In",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp)))
                                .visible(u.status == "active"),
                            TextButton(
                                    style: TextButton.styleFrom(
                                        minimumSize: Size(45.w, 1.h),
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      confirmDialog(context,
                                          message:
                                              "Are you sure you want to cancel this reservation?",
                                          title: "Cancel Reservation",
                                          onConfirm: () {
                                        loadingDialog(context,
                                            text: "Please wait...");
                                        db
                                            .collection("reservations")
                                            .doc(u.id)
                                            .update({
                                          "status": "cancelled"
                                        }).then((_) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }).catchError((e) {
                                          Navigator.pop(context);
                                          errorDialog(context,
                                              message: e.toString());
                                        });
                                      });
                                    },
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp)))
                                .visible(u.status == "active"),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
