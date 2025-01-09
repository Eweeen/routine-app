import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Initialiser les notifications locales
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Demander l'autorisation des notifications (iOS uniquement)
Future<void> requestNotificationPermission() async {
  final IOSFlutterLocalNotificationsPlugin? iosPlugin =
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>();
  if (iosPlugin != null) {
    await iosPlugin.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

// Planifier une notification pour une routine
Future<void> scheduleRoutineNotification({
  required int id,
  required String title,
  required String body,
  required String frequency,
  required DateTime startDate,
}) async {
  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'routine_channel',
    'Routine Notifications',
    channelDescription: 'Rappels pour vos routines',
    importance: Importance.high,
    priority: Priority.high,
  );

  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  // Calculer la prochaine notification à 12h par défaut
  DateTime nextDate = calculateNextDate(frequency, startDate);

  // S'assurer que l'heure est fixée à 12h
  nextDate = DateTime(nextDate.year, nextDate.month, nextDate.day, 12);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(nextDate, tz.local),
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

// Calculer la prochaine date de notification
DateTime calculateNextDate(String frequency, DateTime startDate) {
  final now = DateTime.now();
  switch (frequency.toLowerCase()) {
    case 'quotidienne':
      return now.isAfter(startDate)
          ? now.add(const Duration(days: 1))
          : startDate;
    case 'hebdomadaire':
      return now.isAfter(startDate)
          ? now.add(const Duration(days: 7))
          : startDate;
    case 'mensuelle':
      return DateTime(
        now.year,
        now.month + 1,
        startDate.day,
        12, // Fixe l'heure à 12h
      );
    default:
      return startDate; // Une fois ou fréquence inconnue
  }
}

// Annuler une notification spécifique
Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}
