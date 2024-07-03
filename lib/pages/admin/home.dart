import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: LayoutBuilder(builder: (context, size) {
        return GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: [
            //Manage Hostels
            GridTile(
                child: Column(
              children: [
                Icon(Icons.house),
                Text(
                  "Manage Hostels",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            )),
            //Manage Reservations
            //Manage Users
            GridTile(
                child: Column(
              children: [
                Icon(Icons.person),
                Text(
                  "Manage Users",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            )),
            //Logout
            GestureDetector(
              onTap: () {
                confirmDialog(context,
                    message: "Are you sure you want to logout?",
                    title: "Log Out", onConfirm: () {
                  try {
                    auth.signOut().then((_) {
                      setValue("logged", false);
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
                  child: Column(
                    children: [
                      Icon(Icons.person),
                      Text(
                        "Manage Users",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
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
