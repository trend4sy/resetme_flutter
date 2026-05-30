import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
    FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _local.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  Future<void> scheduleCheckinReminder({int hour = 20, int minute = 0}) async {
    await _local.cancelAll();
    await _local.periodicallyShow(
      0,
      'ResetMe',
      'كيف كان يومك؟ خذ دقيقة لتسجيل مزاجك',
      RepeatInterval.daily,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          'تذكيرات يومية',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleSleepReminder({int hour = 22, int minute = 0}) async {
    await _local.show(
      1,
      'وقت النوم',
      'حان وقت روتين النوم. خذ 10 دقائق للاسترخاء',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'sleep',
          'تذكير النوم',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancelAll() async {
    await _local.cancelAll();
  }
}
