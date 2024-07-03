import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/models/user.dart';
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
          return FutureBuilder<UserModel>(
              future: UserModel.getUser(auth.currentUser!.uid),
              builder: (context, snap) {
                if (snap.hasError) {
                  return ErrorWidget(snap.error.toString()).paddingAll(10.sp);
                }
                if (snap.hasData) {
                  var user = snap.requireData;
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
                                    radius: 25.sp,
                                    backgroundImage:
                                        const AssetImage("assets/logo.png"),
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
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return editSheet(user);
                              });
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
                                color: Colors.red[100], shape: BoxShape.circle),
                            child: Icon(Icons.logout, color: Colors.red[700])),
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
    );
  }

  final _formKey = GlobalKey<FormState>();
  Widget editSheet(UserModel user) {
    return Container(
      padding: EdgeInsets.all(3.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: user.name,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter your name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              initialValue: user.studentId,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Student ID",
                hintText: "Enter your student ID",
                prefixIcon: Icon(Icons.password_rounded),
              ),
            ),
            TextFormField(
              initialValue: user.email,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            TextFormField(
              initialValue: user.phone,
              decoration: InputDecoration(
                labelText: "Phone",
                hintText: "Enter your phone number",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Update"))
          ],
        ),
      ),
    );
  }
}
