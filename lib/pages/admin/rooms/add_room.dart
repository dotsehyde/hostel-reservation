import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/config/helpers.dart';
import 'package:hostel/models/room.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddRoomPage extends StatefulWidget {
  final RoomModel? room;
  const AddRoomPage({super.key, this.room});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController =
      TextEditingController(text: widget.room?.name);
  late TextEditingController descController =
      TextEditingController(text: widget.room?.description);
  late TextEditingController priceController =
      TextEditingController(text: widget.room?.price);
  late TextEditingController capacityController =
      TextEditingController(text: widget.room?.capacity.toString());

  late bool isUpdate = widget.room != null;

  final imagePicker = ImagePicker();
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
    if (isUpdate && widget.room!.image.isEmptyOrNull) {
      setState(() {
        imageBytes = base64StringToImage(widget.room!.image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text(isUpdate ? "Update Room" : "Add Room",
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
                const SizedBox(height: 20),
                //Picture
                GestureDetector(
                  onTap: () {
                    chooseImage();
                  },
                  child: Container(
                    width: 100.sp,
                    height: 55.sp,
                    decoration: BoxDecoration(
                        color: Colors.green[200],
                        image: DecorationImage(
                            image: imageBytes != null
                                ? MemoryImage(imageBytes!)
                                : imageFile != null
                                    ? FileImage(File(imageFile!.path))
                                    : const AssetImage("assets/logo.png"))),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 30.sp,
                      color: Colors.white70,
                    ),
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
                        return "Room name is required";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                      labelText: "Name",
                      fillColor: bgColor,
                      filled: true,
                    ),
                  ),
                ),

                //Description
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
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 17.sp),
                    controller: descController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                      labelText: "Description",
                      fillColor: bgColor,
                      filled: true,
                    ),
                  ),
                ),
                //Capacity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 45.w,
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 19.sp),
                        controller: capacityController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "No. of bed is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero),
                          labelText: "No. of Beds",
                          fillColor: bgColor,
                          filled: true,
                        ),
                      ),
                    ),
                    //Price
                    Container(
                      width: 45.w,
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
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: 19.sp),
                        controller: priceController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Price is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero),
                          labelText: "Price",
                          prefixText: "GHS ",
                          fillColor: bgColor,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ).paddingBottom(3.h),

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
                      isUpdate ? await update() : await create();
                    },
                    label: Text(
                      isUpdate ? "Update" : "Add",
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
  final db = FirebaseFirestore.instance;

  Future<void> create() async {
    try {
      if (imageFile == null) {
        errorDialog(context, message: "Please add an image.");
        return;
      }
      loadingDialog(context, text: "Please wait...");
      var docRef = db.collection("rooms").doc();
      var room = RoomModel(
          id: docRef.id,
          name: nameController.text,
          capacity: int.parse(capacityController.text),
          price: priceController.text,
          image: await imageToBase64String(imageFile!),
          description: descController.text);
      await docRef.set(room.toMap()).then((_) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      errorDialog(context, message: e.message);
    }
  }

  Future<void> update() async {
    try {
      loadingDialog(context, text: "Please wait...");
      var room = RoomModel(
          id: widget.room!.id,
          name: nameController.text,
          capacity: int.parse(capacityController.text),
          price: priceController.text,
          image: imageFile != null
              ? await imageToBase64String(imageFile!)
              : widget.room!.image,
          description: descController.text);
      await room.update().then((_) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      errorDialog(context, message: e.message);
    }
  }
}
