import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/pages/admin/reservations/reserve_list.dart';
import 'package:hostel/pages/admin/rooms/room_list.dart';
import 'package:hostel/pages/admin/users/user_list.dart';
import 'package:hostel/pages/login.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
                          builder: (context) => const RoomListPage()));
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
                          "Manage Rooms",
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
}
