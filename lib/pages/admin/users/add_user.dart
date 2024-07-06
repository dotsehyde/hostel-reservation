import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddAdminUserPage extends StatefulWidget {
  const AddAdminUserPage({super.key});

  @override
  State<AddAdminUserPage> createState() => _AddAdminUserPageState();
}

class _AddAdminUserPageState extends State<AddAdminUserPage> {
  final _formKey = GlobalKey<FormState>();
  final studentIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text("Add Admin User",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              children: [
                60.height,
                Text(
                  "Create an admin account",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                //Name
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 19.sp),
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        hintText: "Name",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person_outline_outlined,
                          size: 22.sp,
                        )),
                  ),
                ),

                //Email
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset:
                            const Offset(5, 5), // changes position of shadow
                      ),
                    ],
                    // border: Border.all(color: Colors.black)
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 19.sp),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      if (!value.validateEmail()) {
                        return "Invalid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        hintText: "Email Address",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 22.sp,
                        )),
                  ),
                ),
                //Phone Number
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 19.sp),
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone is required";
                      }
                      if (!value.startsWith("0")) {
                        return "Phone number must start with 0";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        hintText: "Phone Number",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.phone,
                          size: 22.sp,
                        )),
                  ),
                ),
                //Password
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 19.sp),
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    obscureText: !showPass,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        hintText: "Password",
                        fillColor: bgColor,
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: Icon(
                              showPass
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined,
                              size: 22.sp,
                            )),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 22.sp,
                        )),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset:
                            const Offset(5, 5), // changes position of shadow
                      ),
                    ],
                    // border: Border.all(color: Colors.black)
                  ),
                  margin: EdgeInsets.only(bottom: 2.5.h),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 19.sp),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Confirm Password is required";
                      }
                      if (passwordController.text != value) {
                        return "Password do not match";
                      }
                      return null;
                    },
                    obscureText: !showPass,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        hintText: "Confirm Password",
                        fillColor: bgColor,
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: Icon(
                              showPass
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined,
                              size: 22.sp,
                            )),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 22.sp,
                        )),
                  ),
                ),

                TextButton.icon(
                    icon: Icon(
                      Icons.arrow_forward_outlined,
                      size: 22.sp,
                    ),
                    iconAlignment: IconAlignment.end,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      await create();
                    },
                    label: Text(
                      "Create",
                      style: TextStyle(fontSize: 20.sp),
                    )),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: bgColor,
    );
  }

  final auth = FirebaseAuth.instance;
  Future<void> create() async {
    try {
      loadingDialog(context, text: "Please wait...");
      var cred = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      var newAdmin = UserModel(
          id: cred.user!.uid,
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          photo: "",
          studentId: "ADMIN");
      newAdmin.saveAdmin().then((_) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      errorDialog(context, message: e.message);
    }
  }
}
