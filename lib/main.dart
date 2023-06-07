import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_todo_app/app/data/services/storage/services.dart';
import 'package:getx_todo_app/app/modules/home/home_bindings.dart';
import 'package:getx_todo_app/app/modules/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo List using GetX',
      debugShowCheckedModeBanner: false,
      home: const HomeViewPage(),
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}