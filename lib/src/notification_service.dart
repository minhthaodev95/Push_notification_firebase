import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  // initialize flutter notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  //init plugin when start app

  Future<void> init(BuildContext context) async {
    //init in Android mode
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // init in Ios Mode
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //     await flutterLocalNotificationPlugin.getNotificationAppLaunchDetails();

    await flutterLocalNotificationPlugin.initialize(initializationSettings,
        onSelectNotification: (
      String? payload,
    ) async {
      await Navigator.of(context).pushNamed('anotherScreen');
    });
    tz.initializeTimeZones();
  }

  Future<void> displayNotificationFirebase(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'notichannel', 'notichannel Channel',
            channelDescription: 'Main channel notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@drawable/app_icon'),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await flutterLocalNotificationPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: 'This is payload of notifiacation',
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> showNotification(
      int id, String title, String body, int seconds) async {
    final asiaUtc7 = tz.getLocation('Asia/Ho_Chi_Minh');
    final tz.TZDateTime now = tz.TZDateTime.now(asiaUtc7);

    await flutterLocalNotificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime(asiaUtc7, now.year, now.month, now.day, now.hour,
              now.minute, now.second)
          .add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: 'Main channel notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@drawable/app_icon'),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'This is payload of notifiacation',
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  Future<void> selectNotification(
    String? payload,
  ) async {}

  // android notification details

  // AndroidNotificationDetails androidPlatformChannelSpecifics =
  //     const AndroidNotificationDetails('your channel id', 'your channel name',
  //         channelDescription: 'channel description',
  //         importance: Importance.defaultImportance,
  //         priority: Priority.max);

  // IOSNotificationDetails iOSPlatformChannelSpecifics =
  //     const IOSNotificationDetails();

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationPlugin.cancelAll();
  }
}
