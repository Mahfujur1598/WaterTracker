import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;


class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'water_reminders';
  static const String _channelName = 'Water Reminders';
  static const String _channelDesc = 'Reminds you to drink water';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    /// Initialize timezone
    tzdata.initializeTimeZones();

    const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<void> requestPermissions() async {
    await init();

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  NotificationDetails _details() {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  Future<void> cancelAllReminders() async {
    await init();
    await _plugin.cancelAll();
  }

  Future<void> scheduleRemindersEveryXHours({
    required int intervalHours,
    required int goalMl,
  }) async {
    await init();
    await cancelAllReminders();
    await requestPermissions();

    final remindersPerDay =
    (24 / intervalHours).floor().clamp(1, 24);
    final perReminderMl =
    (goalMl / remindersPerDay).round();

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 1; i <= remindersPerDay; i++) {
      final scheduled =
      now.add(Duration(hours: intervalHours * i));

      await _plugin.zonedSchedule(
        1000 + i,
        'Drink Water 💧',
        'Drink $perReminderMl ml now',
        scheduled,
        _details(),
        androidScheduleMode:
        AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> showTestNow() async {
    await init();
    await requestPermissions();

    await _plugin.show(
      999,
      'Test Notification',
      'If you see this, notifications work!',
      _details(),
    );
  }
}