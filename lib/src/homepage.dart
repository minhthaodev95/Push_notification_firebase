import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/src/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    //? Local push notification active when app terminated!!
    NotificationService().init(context).then((payload) async {
      // final routeFromMessage = message.data['route'];
      var details = await NotificationService()
          .flutterLocalNotificationPlugin
          .getNotificationAppLaunchDetails();
      if (details!.didNotificationLaunchApp) {
        print('when app terminated');
        await Navigator.of(context).pushNamed('anotherScreen');
      }
    });
    //! When app terminated then function run and return notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data['route'];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    //? Notification show in foreground work
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      print(message.notification!.body);
      NotificationService().displayNotificationFirebase(message);
    });
    //! when user tap on notification, the app in the background and still opened!!!
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];
      print(message.notification!.title);
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomePage'),
        ),
        body: Center(
            child: ElevatedButton(
          onPressed: () {
            NotificationService().showNotification(1, "title", "body", 1);
          },
          child: const Text('Show Notificaiton'),
        )));
  }
}
