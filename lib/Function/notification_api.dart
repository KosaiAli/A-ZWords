import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationAPI {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    init();
    _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static void init() {
    var androidinit = const AndroidInitializationSettings('ic_launcher');
    var initializationsetting = InitializationSettings(android: androidinit);
    _notification.initialize(initializationsetting);
  }

  static Future showNitification(DateTime date) async {
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
    var androiddetail = const AndroidNotificationDetails(
        'channelID', 'localNotification',
        channelDescription: 'Description of the notification',
        importance: Importance.high);
    var generateNotificationDetails =
        NotificationDetails(android: androiddetail);
    await _notification.zonedSchedule(0, 'title', 'body',
        tz.TZDateTime.from(date, tz.local), generateNotificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // static tz.TZDateTime _sechedualeDate(Time time) {
  //   final now = tz.TZDateTime.now(tz.local);
  //   print(now);
  //   final schedualDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
  //       time.hour, time.minute, time.second);
  //   print(schedualDate);
  //   return schedualDate.isBefore(now)
  //       ? schedualDate.add(const Duration(days: 1))
  //       : schedualDate;
  // }
}
