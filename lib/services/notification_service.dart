import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(android: androidInit, iOS: iosInit);

    tz.initializeTimeZones();

    await _plugin.initialize(settings);
  }

  Future<void> scheduleMonthlyFirstSaturdayReminder({int hour = 9, int minute = 0}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'first_saturday_channel',
      'Pierwsze Soboty',
      channelDescription: 'Przypomnienia o pierwszej sobocie miesiąca',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Schedule next 12 first Saturdays
    final DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      final DateTime monthDate = DateTime(now.year, now.month + i, 1);
      final DateTime firstSaturday = _firstSaturdayOfMonth(monthDate.year, monthDate.month);
      final DateTime scheduled = DateTime(firstSaturday.year, firstSaturday.month, firstSaturday.day, hour, minute);
      final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduled, tz.local);
      await _plugin.zonedSchedule(
        1000 + i,
        'Pierwsza sobota miesiąca',
        'Pamiętaj o warunkach nabożeństwa.',
        tzTime,
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'first_saturday',
      );
    }
  }

  DateTime _firstSaturdayOfMonth(int year, int month) {
    final DateTime firstDay = DateTime(year, month, 1);
    final int weekday = firstDay.weekday; // Mon=1 ... Sun=7
    final int daysToSaturday = (DateTime.saturday - weekday + 7) % 7;
    return DateTime(year, month, 1 + daysToSaturday);
  }
}