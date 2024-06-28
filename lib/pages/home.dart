import 'package:flutter/material.dart';
import 'package:hostel/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //State
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Hostels",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.sp),
        ),
        elevation: 10,
        scrolledUnderElevation: 10,
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 7.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: TextField(
                  onChanged: (v) {
                    if (v.isNotEmpty && v.length >= 3) {
                      setState(() => isSearch = true);
                    }
                  },
                  style: TextStyle(fontSize: 18.sp),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search hostel...")),
            )),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Scrollbar(
              child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                  itemCount: 10,
                  // gridDelegate:
                  //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.5.h),
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: const Offset(
                                  5, 8), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image),
                          Text("Room $i"),
                          const Text("Price: 1000"),
                          const Text("Available: Yes"),
                        ],
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
