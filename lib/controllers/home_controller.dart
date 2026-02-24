import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/models/water_entry.dart';
import '../data/repositories/water_repo.dart';
import 'history_controller.dart';
import 'settings_controller.dart';

class HomeController extends GetxController {
  final repo = Get.find<WaterRepo>();
  final settings = Get.find<SettingsController>();

  final todayTotalMl = 0.obs;
  final todayKey = ''.obs;

  /// ✅ UI will use this to show tick + success message
  final isGoalReached = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initToday();

    // ✅ goal change হলে progress + success status update
    ever<int>(settings.goalMl, (_) {
      _updateGoalStatus();
    });
  }

  String _dayKeyNow() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> _initToday() async {
    final key = _dayKeyNow();
    todayKey.value = key;
    todayTotalMl.value = await repo.todayTotal(key);
    _updateGoalStatus();
  }

  Future<void> refreshToday() async {
    final key = _dayKeyNow();

    // midnight case
    if (todayKey.value != key) {
      todayKey.value = key;
    }

    todayTotalMl.value = await repo.todayTotal(key);
    _updateGoalStatus();
  }

  /// ✅ progress 0..1 clamp
  double get progress {
    final goal = settings.goalMl.value;
    if (goal <= 0) return 0;
    return (todayTotalMl.value / goal).clamp(0.0, 1.0);
  }

  /// ✅ update reached status
  void _updateGoalStatus() {
    final goal = settings.goalMl.value;
    if (goal <= 0) {
      isGoalReached.value = false;
      return;
    }
    isGoalReached.value = todayTotalMl.value >= goal;
  }

  Future<void> addWater(int amount) async {
    if (amount <= 0) return;

    final now = DateTime.now();
    final key = _dayKeyNow();

    final entry = WaterEntry(
      amountMl: amount,
      timestamp: now.millisecondsSinceEpoch,
      dayKey: key,
    );

    // ✅ Instant UI update
    todayTotalMl.value += amount;

    // ✅ update success status instantly
    _updateGoalStatus();

    // Save to DB
    await repo.insertEntry(entry);

    // ✅ refresh history instantly
    if (Get.isRegistered<HistoryController>()) {
      await Get.find<HistoryController>().refresh();
    }
  }
}