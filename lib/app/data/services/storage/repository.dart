import 'package:getx_todo_app/app/data/models/task.dart';
import 'package:getx_todo_app/app/data/providers/task/task_provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.readTasks();

  void writeTasks(List<Task> tasks) => taskProvider.writeTasks(tasks);
}