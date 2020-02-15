import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:screen_demo/models/notification_model.dart';

class NotificationManager {
  static NotificationManager _instance;
  FirebaseMessaging _fireBaseMessaging;
  EventBus _eventBus;

  factory NotificationManager() {
    if (_instance == null) {
      _instance = NotificationManager._createInstance();
    }
    return _instance;
  }

  NotificationManager._createInstance() {
    _fireBaseMessaging = FirebaseMessaging();
    fireBaseNotificationSetup();
    _eventBus = EventBus();
  }

  EventBus getEventBus() {
    return _eventBus;
  }

  void fireBaseNotificationSetup() async {
    if (Platform.isIOS) iOSPermission();
    _fireBaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _eventBus.fire(NotificationModel(
            title: message['notification']['title'],
            bodyData: message['notification']['body']));
      },
      onResume: (Map<String, dynamic> message) async {
        Future.delayed(Duration(seconds: 2)).then((value) {
          _eventBus.fire(NotificationModel(
              title: message['data']['title'],
              bodyData: message['data']['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        Future.delayed(Duration(seconds: 2)).then((value) {
          _eventBus.fire(NotificationModel(
              title: message['data']['title'],
              bodyData: message['data']['body']));
        });
      },
    );
  }

  void iOSPermission() {
    _fireBaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fireBaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
