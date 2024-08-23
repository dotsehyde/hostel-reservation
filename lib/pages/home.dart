import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/config/notification.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/pages/payment.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    messaging.getToken().then((token) {
      if (auth.currentUser != null) {
        db
            .collection("users")
            .doc(auth.currentUser!.uid)
            .update({"token": token});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 32.sp),
            const Text("You are not logged in")
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.sp),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Scrollbar(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: db.collection('rooms').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(Icons.error, size: 32.sp),
                            Text(snapshot.error.toString())
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var data = snapshot.requireData.docs
                        .map((e) => RoomModel.fromMap(e.data()))
                        .toList();
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              size: 45.sp,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            Text(
                              "No available rooms yet!",
                              style: TextStyle(fontSize: 22.sp),
                            ).paddingSymmetric(vertical: 1.h),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                        itemCount: data.length,
                        // gridDelegate:
                        //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemBuilder: (context, i) {
                          var u = data[i];

                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.zero,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    offset: const Offset(5, 8),
                                  ),
                                ],
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            margin: EdgeInsets.only(bottom: 1.5.h),
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.sp,
                                    backgroundImage: MemoryImage(
                                        base64StringToImage(u.image)),
                                  ),
                                  Text(
                                    u.name,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ).paddingLeft(1.w),
                                ],
                              ),
                              Text(u.description).paddingTop(1.h),
                              const Divider(),
                              Text(
                                "Rooms",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ).paddingLeft(1.w),
                              StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  stream: db
                                      .collection("rooms")
                                      .doc(u.id)
                                      .collection("rooms")
                                      .where("capacity", isGreaterThan: 0)
                                      .snapshots(),
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: Text("Loading..."));
                                    }
                                    if (snap.hasError) {
                                      return Center(
                                          child: Text(snap.error.toString()));
                                    }
                                    var rooms = snap.requireData.docs
                                        .map((e) => RoomModel.fromMap(e.data()))
                                        .toList();
                                    if (rooms.isEmpty) {
                                      return const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "No rooms available",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            // isScrollControlled: true,
                                            builder: (context) {
                                              return buildDialog(
                                                  rooms[i], u.id);
                                            });
                                      },
                                      child: SizedBox(
                                        height: 18.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: rooms.length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                              height: 10.h,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 40.sp,
                                                    height: 40.sp,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.green[200],
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: MemoryImage(
                                                                base64StringToImage(
                                                                    rooms[i]
                                                                        .image)))),
                                                  ),
                                                  Text(rooms[i].name,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                      .paddingTop(1.h),
                                                  Text("GHS ${rooms[i].price}")
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  })
                            ]),
                          );
                        });
                  }),
            ),
          );
        },
      ),
    );
  }

  Widget buildDialog(RoomModel u, String hostelId) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 20.sp,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            const Divider(),
            Container(
              width: 100.sp,
              height: 70.sp,
              decoration: BoxDecoration(
                  color: Colors.green[200],
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: MemoryImage(base64StringToImage(u.image)))),
            ),
            Text(
              u.name,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ).paddingTop(1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bed, size: 20.sp).paddingRight(1.w),
                Text("${u.capacity} beds left"),
              ],
            ),
            Text(u.description),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("GHS ${u.price}", style: TextStyle(fontSize: 18.sp)),
                TextButton(
                    style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                    onPressed: u.capacity < 1
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                          room: u,
                                          hostelId: hostelId,
                                        )));
                          },
                    child: Text("Reserve Room",
                        style: TextStyle(fontSize: 18.sp))),
              ],
            )
          ],
        ).paddingAll(10),
      ),
    );
  }
}
