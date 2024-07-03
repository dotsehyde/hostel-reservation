import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/pages/admin/home.dart';
import 'package:hostel/pages/navigationBar.dart';
import 'package:hostel/pages/signup.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  //States
  bool showPass = false;
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: LayoutBuilder(
          builder: (context, size) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 45.sp,
                    ),
                    Text(
                      appName,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Login into your account",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    // const SizedBox(height: 10),
                    // Divider(),

                    Text(
                      "Select account type:",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isAdmin = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: .5.h),
                              color:
                                  !isAdmin ? Colors.green : Colors.transparent,
                              child: Text("Student",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: !isAdmin ? Colors.white : null)),
                            )),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isAdmin = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: .5.h),
                              color:
                                  isAdmin ? Colors.green : Colors.transparent,
                              child: Text("Admin",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: isAdmin ? Colors.white : null)),
                            )),
                      ],
                    ),
                    // const SizedBox(height: 10),
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
                        style: TextStyle(fontSize: 19.sp),
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(
                                5, 5), // changes position of shadow
                          ),
                        ],
                        // border: Border.all(color: Colors.black)
                      ),
                      margin: EdgeInsets.only(bottom: 2.5.h),
                      child: TextFormField(
                        style: TextStyle(fontSize: 19.sp),
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
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
                          await login();
                        },
                        label: Text(
                          "Login",
                          style: TextStyle(fontSize: 20.sp),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        },
                        child: Text("Don't have an account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 18.sp)))
                  ],
                ),
              ),
            );
          },
        ));
  }

  //Functions
  Future<void> login() async {
    try {
      loadingDialog(context, text: "Please wait...");
      var userCred = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCred.user != null) {
        setValue("logged", true);
        var aa = await UserModel.checkIsAdmin(userCred.user!.uid);
        if (aa && isAdmin) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationBarPage()));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      errorDialog(context, message: e.message);
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      errorDialog(context, message: e.message);
    }
  }
}
