import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '/models/task.dart';
import '/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    // await _configureLocalTimeZone();
    _configureLocalTimeZoneCC();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  initializNotification() async {
    tz.initializeTimeZones();
//tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTime(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTime(
      int hour, int minute, int remind, String repeat, String date) {
    final tz.Location location =
        tz.getLocation('Africa/Cairo'); // Explicitly use Cairo timezone
    final tz.TZDateTime now = tz.TZDateTime.now(location);
    //final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var formattedDate = DateFormat.yMd().parse(date);

    final tz.TZDateTime fd = tz.TZDateTime.from(formattedDate, location);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(location, fd.year, fd.month, fd.day, hour, minute);
    scheduledDate = scheduledDate.subtract(Duration(minutes: remind));

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(location, now.year, now.month,
            (formattedDate.day) + 1, hour, minute);
      }
      if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(location, now.year, now.month,
            (formattedDate.day) + 7, hour, minute);
      }
      if (repeat == 'Monhtly') {
        scheduledDate = tz.TZDateTime(location, now.year,
            (formattedDate.month) + 1, (formattedDate.day), hour, minute);
      }
      scheduledDate = scheduledDate.subtract(Duration(minutes: remind));
    }

    return scheduledDate;
  }

  // tz.TZDateTime remindAfter(int remind, tz.TZDateTime scheduledDate) {
  //   return scheduledDate.subtract( Duration(minutes: remind));
  // }

  // remindAfter(remind, DateTime scheduledDate) {

  // }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  canselNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
    log('notification canseled');
  }

  canselAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    log('all notification canseled');
  }

  void _configureLocalTimeZoneCC() {
    tz.initializeTimeZones(); // Load timezone data

    // Get the local timezone offset in hours
    String timeZone = 'Africa/Cairo'; // Manually set to Egypt timezone

    try {
      tz.setLocalLocation(tz.getLocation(timeZone));
      log('✅ Local timezone set to: ${tz.local}');
    } catch (e) {
      log('⚠️ Failed to set timezone, defaulting to UTC: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body!));
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.input != null) {
      Get.dialog(Text(notificationResponse.input!));
    }
    if (notificationResponse.payload != null) {
      debugPrint('notification payload : $payload');
      await Get.to(() => NotificationScreen(payload: payload!));
    }
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }
}
