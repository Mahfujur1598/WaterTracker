import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_tracker/services/notification_service.dart';

import 'app/routes.dart';
import 'app/bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final notificationService = NotificationService();
  await notificationService.init();
  Get.put(notificationService, permanent: true);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      initialRoute: Routes.home,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    );
  }
}