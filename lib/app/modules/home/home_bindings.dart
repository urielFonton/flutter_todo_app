import 'package:get/get.dart';
import 'package:getx_todo_app/app/data/providers/task/task_provider.dart';
import 'package:getx_todo_app/app/data/services/storage/repository.dart';
import 'package:getx_todo_app/app/modules/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
        taskRepository: TaskRepository(taskProvider: TaskProvider())));
  }
}
