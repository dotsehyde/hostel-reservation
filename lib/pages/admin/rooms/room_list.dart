import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/pages/admin/rooms/add_room.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text("Rooms",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: bgColor,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection("rooms").snapshots(),
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
            List<RoomModel> data = snap.requireData.docs
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
                      "Nothing here!",
                      style: TextStyle(fontSize: 22.sp),
                    ).paddingSymmetric(vertical: 1.h),
                    Text(
                      "Clicke the button below to create a room",
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
                  return ListTile(
                    leading: Container(
                      width: 35.sp,
                      height: 35.sp,
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        image: DecorationImage(
                          image: MemoryImage(base64StringToImage(u.image)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      u.name,
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bed,
                              size: 20.sp,
                            ).paddingRight(2.w),
                            Text(
                              u.capacity.toString(),
                              style: TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        Text(
                          "GHS ${u.price}",
                          style: TextStyle(fontSize: 17.sp),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 22.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Edit
                          CircleAvatar(
                            backgroundColor: Colors.blue[400],
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddRoomPage(room: u)));
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                            ),
                          ).paddingRight(1.w),

                          //Delete
                          CircleAvatar(
                            backgroundColor: Colors.red[400],
                            child: IconButton(
                              onPressed: () {
                                confirmDialog(context,
                                    message:
                                        "Are you sure you want to delete this room?",
                                    title: "Delete room", onConfirm: () async {
                                  await db
                                      .collection("rooms")
                                      .doc(u.id)
                                      .delete()
                                      .then((_) {
                                    Navigator.pop(context);
                                  }).catchError((e) {
                                    Navigator.pop(context);
                                    errorDialog(context, message: e.toString());
                                  });
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddRoomPage()));
          },
          child: Icon(Icons.add)),
    );
  }
}
