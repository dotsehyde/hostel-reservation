import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel/config/constant.dart';
import 'package:hostel/widgets/dialog_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayStackWeb extends StatefulWidget {
  final String url;
  final String reference;
  final bool isDeposit;

  const PayStackWeb(
      {super.key,
      required this.url,
      required this.reference,
      required this.isDeposit});

  @override
  State<PayStackWeb> createState() => _PayStackWebState();
}

class _PayStackWebState extends State<PayStackWeb> {
  Future<bool> checkTransactionStatus(String ref) async {
    try {
      /// Getting data, passing [ref] as a value to the URL that is being requested.
      var response = await Dio().get<Map<String, dynamic>>(
        'https://api.paystack.co/transaction/verify/$ref',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $payKey',
        }),
      );
      if (response.statusCode == 200) {
        if (response.data!["data"]["gateway_response"] == "Approved") {
          return true;
        } else {
          return false;
        }
      } else {
        /// Anything else means there is an issue
        throw Exception(
            "Response Code: ${response.statusCode}, Response Body${response.data}");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(65.w, 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (await checkTransactionStatus(widget.reference)) {
                  Navigator.of(context).pop(true); //close webview
                } else {
                  Navigator.of(context).pop(false); //close webview
                }
              },
              icon: const Icon(Icons.cancel, color: Colors.white),
              label: Text("Cancel Payment",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white)))
        ],
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: 'Flutter;Webview',
          navigationDelegate: (navigation) async {
            //Listen for callback URL
            if (navigation.url.contains("https://hostelhub.com")) {
              Navigator.of(context).pop(true); //close webview
            } else if (navigation.url
                .contains("https://standard.paystack.co/close")) {
              if (await checkTransactionStatus(widget.reference)) {
                Navigator.of(context).pop(true); //close webview
              } else {
                Navigator.of(context).pop(false); //close webview
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
