import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/notification_service.dart';

class SettingsController extends GetxController {
  final box = GetStorage();
  final notifications = Get.find<NotificationService>();

  final goalMl = 2000.obs;
  final reminderHours = 2.obs;
  final reminderEnabled = false.obs;

  static const _kGoal = 'goal_ml';
  static const _kHours = 'reminder_hours';
  static const _kEnabled = 'reminder_enabled';

  @override
  void onInit() {
    super.onInit();

    goalMl.value = box.read(_kGoal) ?? 2000;
    reminderHours.value = box.read(_kHours) ?? 2;
    reminderEnabled.value = box.read(_kEnabled) ?? false;

    if (reminderEnabled.value) {
      _applyReminderSchedule();
    }
  }

  void setGoal(int ml) {
    goalMl.value = ml;
    box.write(_kGoal, ml);

    if (reminderEnabled.value) {
      _applyReminderSchedule();
    }
  }

  void setReminderHours(int h) {
    reminderHours.value = h;
    box.write(_kHours, h);

    if (reminderEnabled.value) {
      _applyReminderSchedule();
    }
  }

  Future<void> setReminderEnabled(bool v) async {
    reminderEnabled.value = v;
    box.write(_kEnabled, v);

    if (!v) {
      await notifications.cancelAllReminders();
      return;
    }

    await _applyReminderSchedule();
  }

  Future<void> _applyReminderSchedule() async {
    await notifications.scheduleRemindersEveryXHours(
      intervalHours: reminderHours.value,
      goalMl: goalMl.value,
    );
  }

  Future<void> testNow() async {
    await notifications.showTestNow();
  }

  int get remindersPerDay =>
      (24 / reminderHours.value).floor().clamp(1, 24);

  int get perReminderMl =>
      (goalMl.value / remindersPerDay).round();
}