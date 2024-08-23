import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class CustomNotification {
  static Future<void> initRemoteNotifications({required bool debug}) async {
    final messaging = FirebaseMessaging.instance;
    // if (isAndroid) {
    //Android
    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: CustomNotification.mySilentDataHandle,
        onFcmTokenHandle: CustomNotification.myFcmTokenHandle,
        onNativeTokenHandle: CustomNotification.myNativeTokenHandle,
        licenseKey: "",
        debug: debug);

    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'main_channel_group',
              channelKey: 'main_channel',
              channelName: 'HostelHub',
              channelDescription: 'HostelHub Channel',
              defaultColor: Colors.green,
              criticalAlerts: true,
              playSound: true,
              enableVibration: true,
              enableLights: true,
              locked: true,
              defaultRingtoneType: DefaultRingtoneType.Alarm,
              defaultPrivacy: NotificationPrivacy.Public,
              importance: NotificationImportance.High,
              ledColor: Colors.green)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'main_channel_group',
              channelGroupName: 'HostelHub group')
        ],
        debug: debug);
    await CustomNotification.simpleRequestPermission();
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) {
        return CustomNotification.onActionReceivedMethod(receivedAction);
      },
      onNotificationCreatedMethod: (ReceivedNotification receivedNotification) {
        return CustomNotification.onNotificationCreatedMethod(
            receivedNotification);
      },
      onNotificationDisplayedMethod:
          (ReceivedNotification receivedNotification) {
        return CustomNotification.onNotificationDisplayedMethod(
            receivedNotification);
      },
      onDismissActionReceivedMethod: (ReceivedAction receivedAction) {
        return CustomNotification.onDismissActionReceivedMethod(receivedAction);
      },
    );
    messaging.setAutoInitEnabled(true);
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: false, sound: true);
    //App opened by clicking notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_on_rounded, color: Colors.green)
                      .paddingRight(3.w),
                  Text("Notification",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith())
                ],
              ),
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 15.sp),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                event.notification!.title!,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 16.sp),
              ),
              contentTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 15.sp),
              content: Text(
                event.notification!.body!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15.sp),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Okay",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 15.sp, color: Colors.white)),
                )
              ],
            );
          });
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //Opened from terminated

    //Foreground
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        if (Get.context == null) return;
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_on_rounded, color: Colors.green)
                        .paddingRight(3.w),
                    Text("Notification",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith())
                  ],
                ),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 15.sp),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  event.notification!.title!,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 16.sp),
                ),
                contentTextStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15.sp),
                content: Text(
                  event.notification!.body!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 15.sp),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Okay",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 15.sp, color: Colors.white)),
                  )
                ],
              );
            });
      }
    });

    // } else {
    //   await messaging.setAutoInitEnabled(true);
    //   await messaging.requestPermission(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );
    //   await messaging.setForegroundNotificationPresentationOptions(
    //     alert: true,
    //     badge: false,
    //     sound: true,
    //   );
    //   FirebaseMessaging.onBackgroundMessage(
    //       _firebaseMessagingBackgroundHandler);

    //   FirebaseMessaging.onMessage.listen((event) {
    //     if (event.notification != null) {
    //       CustomNotification.playSound();
    //       Get.snackbar(event.notification!.title!, event.notification!.body!,
    //           titleText: Text(event.notification!.title!,
    //               style: Theme.of(Get.context!)
    //                   .textTheme
    //                   .bodyMedium!
    //                   .copyWith(color: Colors.black, fontSize: 15.sp)),
    //           messageText: Text(event.notification!.body!,
    //               style: Theme.of(Get.context!)
    //                   .textTheme
    //                   .bodyMedium!
    //                   .copyWith(color: Colors.black87, fontSize: 15.sp)),
    //           backgroundColor: Colors.white,
    //           borderRadius: 10,
    //           snackPosition: SnackPosition.TOP,
    //           snackStyle: SnackStyle.FLOATING,
    //           duration: const Duration(seconds: 8),
    //           colorText: Colors.black,
    //           icon: Image.asset(
    //             "assets/img/icon.jpeg",
    //             height: 20.sp,
    //             width: 20.sp,
    //           ),
    //           dismissDirection: DismissDirection.horizontal);
    //     }
    //   });
    // }
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    // print('"SilentData": ${silentData.toString()}');
    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("bg");
      // debugPrint(silentData.toMap().toString());
    } else {
      // print("FOREGROUND");
    }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"fcmToken": token});
    }
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    print('"NativeToken": $token');
  }

  static Future<String> getToken() async {
    String firebaseAppToken = '';
    // if (isAndroid) {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    // } else {
    //   firebaseAppToken = await FirebaseMessaging.instance.getToken() ?? "";
    // }
    // print("FCM: $firebaseAppToken");
    return firebaseAppToken;
  }

  // Setup Listeners
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // if (isIOS) {
    //   CustomNotification.playSound();
    //   AwesomeNotifications().createNotification(
    //       content: NotificationContent(
    //           id: receivedNotification.hashCode,
    //           channelKey: 'main_channel',
    //           title: receivedNotification.title,
    //           body: receivedNotification.body));
    // }
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction event) async {
    // Your code goes here

    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_on_rounded, color: Colors.green)
                    .paddingRight(3.w),
                Text("Notification",
                    style:
                        Theme.of(context).textTheme.headlineSmall!.copyWith())
              ],
            ),
            titleTextStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 15.sp),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              event.title!,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 16.sp),
            ),
            contentTextStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 15.sp),
            content: Text(
              event.body!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 15.sp),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text("Okay",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 15.sp, color: Colors.white)),
              )
            ],
          );
        });

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
  }

  //Permissions
  static Future<void> simpleRequestPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications(
            channelKey: 'main_channel',
            permissions: [
              NotificationPermission.Alert,
              NotificationPermission.Badge,
              NotificationPermission.CriticalAlert,
              NotificationPermission.Sound,
              NotificationPermission.Vibration,
              NotificationPermission.Light,
              NotificationPermission.Car,
              NotificationPermission.OverrideDnD,
              NotificationPermission.FullScreenIntent,
            ]);
      }
    });
  }
}

class FcmHelper {
  ///
  /// getAccessToken For Generate Access Token Using Service Account Json
  ///
  static Future getAccessToken() async {
    ///
    /// Service Account json Which you download in Step 2
    ///
    Map<String, dynamic> serviceAccountJson = {
      "type": "service_account",
      "project_id": "hostelhubgh",
      "private_key_id": "e883612ce7666f34fd2052c6819bcdffe2f681a1",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDTWJ/WTrUD8irz\np3bI5EPeLeo/0oGtsahIRiJOZm/qwiSiZtK4S3nWZC5De2lqz87e0a7BR+qNubEX\nA3zwEOan0lAme5D0GyBG2ZHYN2VT19GcWgSYxgLHV3fZRCU2Iy7ZACi1IjsjWWVh\n1fZns9XPMw6acYsFhQyTJOwAI4ZUyuO+idOmF7nxDehmSJrkrGZMh9cRIFV2MsVS\n4HLoVNSrwea5FibB2AW1JLPrfN46Eofm3JjrZvPsUaLf6PbcNf9ZwTWGy0xJhZX3\nIDDf2QcUCwUMnxvih6CBZQjV9bBrw+b9wMabwEScDA9Bmb9dzhciCj5KCQqp5vV9\nMjV/1s93AgMBAAECggEAPzLhvRaVJ6Rrdqftq94ic1Z8lXAv6g5VmaMrUBFuxx8e\nEFg6C/U57kPP18sYN2ID5PqDzPVh7NaJ361h13HeX3HTGObbbjuMV9NouuS5zqwb\nWKtMc5jGrPB5fMVVcU5tDGPxSFT/pS7u06ZFRDZxKcAFTmbEoTZrj7a7QcFdwo3L\niLmi4FpJxbjvCPoiLdXYYrJ4ybyRMQgPM1w0fZEXJGRfLw/Lo/no31Ogbqo237Fz\nYHlDi3IPWeXtujNz4BhPUEHqWuQ1RJo5AV5CvQe7pRzP3Enx7grllTc8x5UNXpGZ\nYY3OKOPvfvhtb12u+FCe3IPZWFMAxbSq6z8NmGmDDQKBgQD+Uo3e6hC+cYywABQ6\nwx7uuAslHRLaas8o82fBSe+ObaDTVTfAbjGH4zLZe8ChU2NdOHRBaKjkqIQQiN1P\nlGw5d10INzIOBrvrKP00vS9FnuuqPAu0HK27pX6fj3LeovICzK+6LIET20sGeGdu\nTAOVgIkEkvcj9vpQrqRFwbqk+wKBgQDUvYA+GIetJzrGeptLxeB98OwGGGA8KI/R\ntAdeYOGjDFip9DAV+trNxmP//Qw4sjF83GTGgog0OGboo2ipBGTxFRrhMIBm6+7H\nCG7QR4vq8oArs730coFxic8EAfqPo5CfkFNGTqCndpPRf/vpcQ0Njwz7CX+uMVJb\nOYbdcSRetQKBgCnvBsF4qqYcJuxmNu+xeIo4Am5uKsukzN+dsr/mJv+/B8OQy46J\nHNWhGqNNimePTlTymAio7yA0wQHQ71zNxkJ7cfWG1FQHvDh8G7P0dbTvDUCWgf+C\nswq7sPMyPeiDyY+4nEkASZAyml5IwBUpp3WhKfZ9HQ7rDD79bMyrstC9AoGBAKwC\n5TRQJTPOKmndLL/hqRhruotbHkTGDzNhuyuGbiqlivMwK8k54bzMEoMjGcSl3/mz\nQhB37qU6jYrAxZkTooKDrA40Zz3QumpX2TGzB+DaXuP3GzoRc7RX1vjImM2XVRKP\nYaXRYXjGGdMlBozECefSqI46KfCwlISKSQ+3sc6ZAoGAevJN71Sj+RjmG4rsvZBz\n0RgSv6gzxqsHPHJ3BffARWVR8aYg9DUBzvWNnTd3mtcRv/D51A7ARlCU2lARNbnL\np4u9nbhS9QAQPW3Z6p8eGFYWyP5O2kgkpQHROa17W9LYmUmKae8/IbuFUEjUFjaL\n/sR5NAH8TCUrp97ee9s3DPQ=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-6r5ks@hostelhubgh.iam.gserviceaccount.com",
      "client_id": "101240815237167417600",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-6r5ks%40hostelhubgh.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();

    //log("FCM API ACCESS TOKEN ===>> ${credentials.accessToken.data}");

    return credentials.accessToken.data;
  }

  ///
  ///  sendNotification Use This Function For send Notification
  ///

  static Future sendNotification({
    required String toToken,
    required String title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    try {
      ///
      /// "https://fcm.googleapis.com/v1/projects/{Your Firebase Project ID}/messages:send",
      ///
      return await Dio().post(
        "https://fcm.googleapis.com/v1/projects/hostelhubgh/messages:send",
        options: Options(
          headers: {
            "Authorization": "Bearer ${await FcmHelper.getAccessToken()}",
          },
        ),
        data: {
          "message": {
            "token": toToken, // User FCM Token
            "notification": {
              "title": title, // Title of Notification
              "body": body ?? "", // Body of Notification
            },
            "data": data // Data (payload) of Notification
          }
        },
      );
    } catch (e) {
      log("Error : sendNotification == > ${e.toString()}");
      return;
    }
  }
}
