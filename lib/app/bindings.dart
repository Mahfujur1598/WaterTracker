import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/settings_controller.dart';
import '../data/repositories/water_repo.dart';
import '../services/notification_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // services / repos
    final n = Get.put(NotificationService(), permanent: true);
    n.init();

    Get.put(WaterRepo(), permanent: true);

    Get.put(SettingsController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(HistoryController(), permanent: true);
  }
}