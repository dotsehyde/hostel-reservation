import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/firebase_options.dart';
import 'package:hostel/pages/admin/home.dart';
import 'package:hostel/pages/login.dart';
import 'package:hostel/pages/navigationBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: getBoolAsync("logged", defaultValue: false)
            ? getBoolAsync("isAdmin")
                ? const AdminHomePage()
                : const NavigationBarPage()
            : const LoginPage(),
      );
    });
  }
  // return Scaffold(
  //                 backgroundColor: bgColor,
  //                 body: Center(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         "assets/logo.png",
  //                         width: 50.sp,
  //                       ),
  //                       const LinearProgressIndicator()
  //                           .paddingSymmetric(horizontal: 30.w, vertical: 2.h),
  //                     ],
  //                   ),
  //                 ),
  //               );
}
