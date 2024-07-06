import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/pages/admin/users/add_user.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text("Admin Users",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: bgColor,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db
            .collection("users")
            .where("isAdmin", isEqualTo: true)
            .snapshots(),
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
            List<UserModel> data = snap.requireData.docs
                .map((e) => UserModel.fromMap(e.data()))
                .toList();
            return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, i) {
                  return Divider(indent: 3.w, endIndent: 3.w);
                },
                itemBuilder: (context, i) {
                  var u = data[i];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${i + 1}"),
                    ),
                    title: Text(u.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.email),
                        Text(u.phone),
                      ],
                    ),
                    trailing: data.length <= 1
                        ? null
                        : CircleAvatar(
                            backgroundColor: Colors.red[400],
                            child: IconButton(
                              onPressed: () {
                                confirmDialog(context,
                                    message:
                                        "Are you sure you want to delete this admin user?",
                                    title: "Delete admin user",
                                    onConfirm: () async {
                                  await db
                                      .collection("users")
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddAdminUserPage()));
          },
          child: Icon(Icons.add)),
    );
  }
}
