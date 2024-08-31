import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

///Error Dialog
Future errorDialog(BuildContext context, {String? message}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 1)),
          title: const Text("Error"),
          content: Text(message ?? "Something went wrong"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      });
}

///Success Dialog
Future successDialog(BuildContext context,
    {required String title, String? message}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 1)),
          title: Text(title),
          content: Text(message ?? "Something went wrong"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      });
}

//Confirm Dialog
Future confirmDialog(BuildContext context,
    {required String message, title, required Function onConfirm}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 1)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel")),
            TextButton(
                onPressed: () {
                  onConfirm();
                },
                child: const Text("okay"))
          ],
        );
      });
}

///Loading Dialog
Future loadingDialog(BuildContext context, {required String text}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(12),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 1)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      });
}
