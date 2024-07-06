import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/models/room.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //State
  bool isSearch = false;
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.sp),
        ),
        elevation: 10,
        // scrolledUnderElevation: 10,
        // bottom: PreferredSize(
        //     preferredSize: Size(double.infinity, 7.h),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 2.w),
        //       child: TextField(
        //           onChanged: (v) {
        //             if (v.isNotEmpty && v.length >= 3) {
        //               setState(() => isSearch = true);
        //             }
        //           },
        //           style: TextStyle(fontSize: 18.sp),
        //           decoration: const InputDecoration(
        //               border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.zero,
        //                   borderSide: BorderSide.none),
        //               filled: true,
        //               fillColor: Colors.white,
        //               prefixIcon: Icon(Icons.search),
        //               hintText: "Search hostel...")),
        //     )),

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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var data = snapshot.requireData.docs
                        .map((e) => RoomModel.fromMap(e.data()))
                        .toList();
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
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Hello"),
                                          ],
                                        ),
                                        Spacer(),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.green),
                                            onPressed: () {},
                                            child: Text("Reserve Room"))
                                      ],
                                    ).paddingAll(10);
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 1.5.h),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: const Offset(
                                          5, 8), // changes position of shadow
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
                                            ).paddingRight(2.w),
                                            Text(
                                              u.capacity.toString(),
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "GHS ${u.price}/room",
                                              style: TextStyle(
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
}
