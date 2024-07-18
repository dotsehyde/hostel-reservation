import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage(this.user, {super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  late TextEditingController studentIdController =
      TextEditingController(text: widget.user.studentId);
  late TextEditingController nameController =
      TextEditingController(text: widget.user.name);
  late TextEditingController emailController =
      TextEditingController(text: widget.user.email);
  late TextEditingController phoneController =
      TextEditingController(text: widget.user.phone);
  XFile? imageFile;
  Uint8List? imageBytes;

  void chooseImage() {
    imagePicker.pickImage(source: ImageSource.gallery).then((file) {
      if (file != null) {
        setState(() {
          imageFile = file;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.user.photo.isEmptyOrNull) {
      setState(() {
        imageBytes = base64StringToImage(widget.user.photo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: Container(
        padding: EdgeInsets.all(3.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                //Profile Picture
                GestureDetector(
                  onTap: () {
                    chooseImage();
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30.sp,
                        backgroundImage: imageFile != null
                            ? FileImage(File(imageFile!.path))
                            : imageBytes != null
                                ? MemoryImage(imageBytes!)
                                : const AssetImage("assets/logo.png"),
                      ).paddingBottom(2.h),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(5.sp),
                          decoration: BoxDecoration(
                              color: Colors.grey[200], shape: BoxShape.circle),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      )
                    ],
                  ),
                ),
                //Name
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
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
                    readOnly: true,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 19.sp),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Full name is required";
                      }
                      if (value.isEmpty && !value.contains(" ")) {
                        return "Please enter your full name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        labelText: "Full Name",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person_outline_outlined,
                          size: 22.sp,
                        )),
                  ),
                ),

                //Student ID
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
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 19.sp),
                    controller: studentIdController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Student ID is required";
                      }
                      return null;
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero),
                        labelText: "Student ID",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          size: 22.sp,
                        )),
                  ),
                ),

                //Email
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
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
                    readOnly: true,
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
                        labelText: "Email Address",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 22.sp,
                        )),
                  ),
                ),

                //Phone
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
                        labelText: "Phone Number",
                        fillColor: bgColor,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.phone,
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
                      await updateProfile();
                    },
                    label: Text(
                      "Update Profile",
                      style: TextStyle(fontSize: 20.sp),
                    )).paddingTop(2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    try {
      loadingDialog(context, text: "Please wait...");
      var updatedUser = UserModel(
        id: widget.user.id,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        studentId: studentIdController.text,
        photo: imageFile != null
            ? await imageToBase64String(imageFile!)
            : widget.user.photo,
      );
      await updatedUser.update();
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      errorDialog(context, message: e.message);
    }
  }
}
