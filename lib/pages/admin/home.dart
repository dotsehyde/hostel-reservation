import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/reserve.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/pages/admin/hostel/hostel_list.dart';
import 'package:hostel/pages/admin/reservations/reserve_list.dart';
import 'package:hostel/pages/admin/rooms/room_list.dart';
import 'package:hostel/pages/admin/saved_reports.dart';
import 'package:hostel/pages/admin/users/user_list.dart';
import 'package:hostel/pages/login.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final messaging = FirebaseMessaging.instance;

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

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
    Future.delayed(Duration.zero, () async {
      await requestStoragePermission();
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
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: LayoutBuilder(builder: (context, size) {
        return GridView(
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 15, crossAxisSpacing: 15, crossAxisCount: 2),
          children: [
            //Manage Hostels
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HostelListPage()));
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, size: 25.sp).paddingBottom(2.h),
                        Text(
                          "Manage Hostels",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),
            //Manage Reservations
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReserveListPage()));
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt, size: 25.sp).paddingBottom(2.h),
                        Text(
                          "Manage Reservations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),

            //Manage Users
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserListPage()));
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 25.sp).paddingBottom(2.h),
                        Text(
                          "Manage Users",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),
            GestureDetector(
                onTap: () {
                  loadingDialog(context, text: "Generating Report...");
                  generatePdf().then((_) {
                    Navigator.pop(context);
                    // Show the Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Report generated successfully!'),
                    ));
                  });
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_copy, size: 25.sp).paddingBottom(2.h),
                        Text(
                          "Generate Report",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SavedReportsPage()),
                  );
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_copy, size: 25.sp).paddingBottom(2.h),
                        Text(
                          "View Reports",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),

            //Logout
            GestureDetector(
              onTap: () {
                confirmDialog(context,
                    message: "Are you sure you want to logout?",
                    title: "Log Out", onConfirm: () {
                  try {
                    auth.signOut().then((_) {
                      setValue("logged", false);
                      setValue("isAdmin", false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    });
                  } on FirebaseAuthException catch (e) {
                    errorDialog(context, message: e.message);
                  }
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  decoration: BoxDecoration(
                      color: Colors.red[600],
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white, size: 25.sp)
                          .paddingBottom(2.h),
                      Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
          ],
        );
      }),
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final db = FirebaseFirestore.instance;

    // Fetch rooms from Firestore and await the result
    List<RoomModel> rooms = [];
    final roomSnap = await db.collection("rooms").get();
    for (var d in roomSnap.docs) {
      RoomModel room = RoomModel.fromMap(d.data());
      rooms.add(room);
    }

    // Add the content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'HostelHub Report',
                style: const pw.TextStyle(fontSize: 40),
              ),
              pw.Divider(),
              ...rooms.map((r) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      r.name,
                      style: const pw.TextStyle(fontSize: 20),
                    ),
                    pw.Text(
                      r.description,
                      style: const pw.TextStyle(fontSize: 15),
                    ),
                    pw.Text(
                      "${r.price} per bed",
                      style: const pw.TextStyle(fontSize: 15),
                    ),
                    pw.Text(
                      "Beds Left: ${r.capacity}",
                      style: const pw.TextStyle(fontSize: 15),
                    ),
                    pw.Divider(),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    // Get the directory to save the file
    final output = await getApplicationDocumentsDirectory();
    // Create a unique file name using the current timestamp
    final fileName =
        "report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf";
    final file = File("${output.path}/$fileName");
    // Save the PDF file
    await file.writeAsBytes(await pdf.save());
  }
}
