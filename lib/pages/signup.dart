import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/models/user.dart';
import 'package:hostel/pages/login.dart';
import 'package:hostel/pages/navigationBar.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final studentIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
//States
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: LayoutBuilder(
          builder: (context, size) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: size.maxHeight / 12,
                      // ),
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
                        "Create an account",
                        style: TextStyle(fontSize: 18.sp),
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
                              offset: const Offset(
                                  5, 5), // changes position of shadow
                            ),
                          ],
                          // border: Border.all(color: Colors.black)
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(fontSize: 19.sp),
                          controller: nameController,
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
                              hintText: "Full Name",
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
                              offset: const Offset(
                                  5, 5), // changes position of shadow
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
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero),
                              hintText: "Student ID",
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
                          keyboardType: TextInputType.emailAddress,
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
                              offset: const Offset(
                                  5, 5), // changes position of shadow
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
                            await signup();
                          },
                          label: Text(
                            "Register",
                            style: TextStyle(fontSize: 20.sp),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: Text("Already have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.sp)))
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  //Functions
  Future<void> signup() async {
    try {
      loadingDialog(context, text: "Please wait...");
      var userCred = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //Save to DB
      await userCred.user!.updateDisplayName(nameController.text);
      await UserModel(
              phone: phoneController.text,
              id: userCred.user!.uid,
              name: nameController.text,
              email: emailController.text,
              studentId: studentIdController.text,
              photo: "")
          .save()
          .then((_) {
        Navigator.pop(context);
        setValue("logged", true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NavigationBarPage()));
      });
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
