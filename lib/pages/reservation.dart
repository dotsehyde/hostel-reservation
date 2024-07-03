import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Reservations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.sp),
        ),
        centerTitle: true,
      ),
    );
  }
}
