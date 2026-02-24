import 'package:get/get.dart';
import '../ui/history_page.dart';
import '../ui/home_page.dart';
import '../ui/settings_page.dart';

class Routes {
  static const home = '/';
  static const history = '/history';
  static const settings = '/settings';
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(name: Routes.history, page: () => const HistoryPage()),
    GetPage(name: Routes.settings, page: () => const SettingsPage()),
  ];
}