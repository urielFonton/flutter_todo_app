import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/app/core/utils/extension.dart';
import 'package:getx_todo_app/app/core/values/colors.dart';
import 'package:getx_todo_app/app/data/models/task.dart';
import 'package:getx_todo_app/app/modules/home/home_controller.dart';
import 'package:getx_todo_app/app/modules/home/widgets/add_card.dart';
import 'package:getx_todo_app/app/modules/home/widgets/dialog/add_dialog.dart';
import 'package:getx_todo_app/app/modules/home/widgets/task_card.dart';
import 'package:getx_todo_app/app/modules/report/report_view.dart';

class HomeViewPage extends GetView<HomeController> {
  const HomeViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Obx(
         () => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              SafeArea(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0.wp),
                      child: Text(
                        'My List',
                        style: TextStyle(
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(
                          () => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          ...controller.tasks
                              .map((element) => LongPressDraggable(
                              data: element,
                              onDragStarted: () => controller.onDeleting(true),
                              onDraggableCanceled: (_, __) =>
                                  controller.onDeleting(false),
                              onDragEnd: (_) => controller.onDeleting(false),
                              feedback: Opacity(
                                opacity: 0.8,
                                child: TaskCard(task: element),
                              ),
                              child: TaskCard(task: element)))
                              .toList(),
                          AddCard()
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ReportPage(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: DragTarget<Task>(builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              elevation: 0,
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please, create  your task type');
                }
              },
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
          onAccept: (Task task) {
            controller.deleteTask(task);
            EasyLoading.showSuccess('Task deleted successfully');
          },
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Obx(
            () => BottomNavigationBar(
              onTap: (int index) => controller.changeTabIndex(index),
              currentIndex: controller.tabIndex.value,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Padding(
                    padding: EdgeInsets.only(right: 15.0.wp),
                    child: const Icon(Icons.apps),
                  )
                ),
                BottomNavigationBarItem(
                    label: 'Report',
                    icon: Padding(
                      padding: EdgeInsets.only(left: 15.0.wp),
                      child: const Icon(Icons.data_usage),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
