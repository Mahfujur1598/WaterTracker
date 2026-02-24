import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/models/water_entry.dart';
import '../data/repositories/water_repo.dart';
import 'home_controller.dart';

class HistoryController extends GetxController {
  final repo = Get.find<WaterRepo>();
  final home = Get.find<HomeController>();

  final selectedDayKey = ''.obs;
  final entries = <WaterEntry>[].obs;
  final dayTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final today = _dayKey(DateTime.now());
    selectDay(today);

    ever(home.todayTotalMl, (_) {
      refresh();
    });
  }

  String _dayKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> selectDay(String dayKey) async {
    selectedDayKey.value = dayKey;
    await refresh();
  }

  Future<void> refresh() async {
    final key = selectedDayKey.value;
    entries.value = await repo.entriesByDay(key);
    dayTotal.value = await repo.todayTotal(key);

    final today = _dayKey(DateTime.now());
    if (key == today) {
      await home.refreshToday();
    }
  }

  Future<void> deleteEntry(int id) async {
    await repo.deleteEntry(id);
    await refresh();
  }

  List<String> lastDaysKeys(int days) {
    final now = DateTime.now();
    return List.generate(days, (i) {
      final d = now.subtract(Duration(days: i));
      return _dayKey(d);
    });
  }
}