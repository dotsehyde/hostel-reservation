import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/pages/edit_profile.dart';
import 'package:hostel/pages/login.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "My Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, size) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: UserModel.streamUser(auth.currentUser?.uid ?? ""),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return ErrorWidget(snap.error.toString()).paddingAll(10.sp);
                  }
                  if (snap.hasData) {
                    var user = UserModel.fromMap(snap.requireData.data()!);
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 2.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 3.w),
                          width: size.maxWidth,
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 26.sp,
                                      backgroundImage: user.photo.isEmptyOrNull
                                          ? const AssetImage("assets/logo.png")
                                          : MemoryImage(
                                              base64StringToImage(user.photo)),
                                    ).paddingRight(4.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: TextStyle(fontSize: 17.sp),
                                        ),
                                        Text(
                                          user.studentId,
                                          style: TextStyle(fontSize: 17.sp),
                                        ),
                                        Text(
                                          user.email,
                                          style: TextStyle(fontSize: 17.sp),
                                        ),
                                        Text(
                                          user.phone,
                                          style: TextStyle(fontSize: 17.sp),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).paddingBottom(1.h),
                        Divider(
                          indent: 3.w,
                          endIndent: 3.w,
                        ),
                        SettingItemWidget(
                          title: "Edit Profile",
                          subTitle: "Update your profile details",
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            size: 25.sp,
                          ),
                          leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.edit)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(user)));
                          },
                        ),
                        Divider(
                          indent: 3.w,
                          endIndent: 3.w,
                        ),
                        //Logout
                        SettingItemWidget(
                          title: "Log out",
                          subTitle: "Log out of your account",
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            size: 25.sp,
                          ),
                          leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  shape: BoxShape.circle),
                              child:
                                  Icon(Icons.logout, color: Colors.red[700])),
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
                                          builder: (context) =>
                                              const LoginPage()));
                                });
                              } on FirebaseAuthException catch (e) {
                                errorDialog(context, message: e.message);
                              }
                            });
                          },
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                });
          },
        ),
        // resizeToAvoidBottomInset: true,
      );
    }
  }
}
