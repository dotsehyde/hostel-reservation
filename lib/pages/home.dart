import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/models/user.dart';
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
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  // isScrollControlled: true,
                                  builder: (context) {
                                    return buildDialog(u);
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 1.5.h),
                              padding: const EdgeInsets.all(10),
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
                              child: Row(children: [
                                Container(
                                  width: 45.sp,
                                  height: 45.sp,
                                  decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(
                                              base64StringToImage(u.image)))),
                                ).paddingRight(3.w),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          u.name,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bed,
                                              size: 20.sp,
                                            ).paddingRight(1.w),
                                            Text(
                                              " ${u.capacity} beds",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                          ],
                                        ).paddingBottom(1.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "GHS ${u.price}/bed",
                                              style: TextStyle(
                                                  color: Colors.green[800],
                                                  fontSize: 19.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ]),
                                )
                              ]),
                            ),
                          );
                        });
                  }),
            ),
          );
        },
      ),
    );
  }

  final auth = FirebaseAuth.instance;

  Widget buildDialog(RoomModel u) {
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
                            confirmDialog(context,
                                title: "Reserve bed",
                                message:
                                    "Are you want to reserve this bed at ${u.name}?",
                                onConfirm: () async {
                              try {
                                Navigator.pop(context);
                                loadingDialog(context,
                                    text: "Reserving room...");
                                var user = await UserModel.getUser(
                                    auth.currentUser!.uid);
                                //check if user has already reserved a room
                                // var res = await db
                                //     .collection("reservations")
                                //     .where("bookerId", isEqualTo: user.id)
                                //     .get();
                                // if (res.docs.isNotEmpty) {
                                //   Navigator.pop(context);
                                //   errorDialog(context,
                                //       message:
                                //           "You have already reserved a room");
                                //   return;
                                // }
                                if (u.capacity == 0) {
                                  Navigator.pop(context);
                                  errorDialog(context, message: "Room is full");
                                  return;
                                }
                                var docRef =
                                    db.collection('reservations').doc();
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
