import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/app/core/utils/extension.dart';
import 'package:getx_todo_app/app/modules/detail/widget/doing_list.dart';
import 'package:getx_todo_app/app/modules/detail/widget/done_list.dart';
import 'package:getx_todo_app/app/modules/home/home_controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeController.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          body: Form(
            key: homeController.formKey,
            child: ListView(
        children: [
            // ******************************************* back button ***********************************************
            Padding(
              padding: EdgeInsets.all(2.0.wp),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                        homeController.updateTodos();
                        homeController.selectTask(null);
                        homeController.taskNameEditController.clear();
                      },
                      icon: const Icon(CupertinoIcons.back)),
                ],
              ),
            ),
            // **********************************************************************************************************
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0.wp,
              ),
              child: Row(
                children: [
                  Icon(
                    IconData(
                      task.icon,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: color,
                  ),
                  SizedBox(
                    width: 3.0.wp,
                  ),
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Obx(() {
              var totalTodos = homeController.doingTodos.length +
                  homeController.doneTodos.length;
              return Padding(
                padding: EdgeInsets.only(
                  left: 9.0.wp,
                  top: 3.0.wp,
                  right: 16.0.wp,
                ),
                child: Row(
                  children: [
                    Text(
                      '$totalTodos Tasks',
                      style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Expanded(
                      child: StepProgressIndicator(
                        totalSteps: totalTodos == 0 ? 1 : totalTodos,
                        currentStep: homeController.doneTodos.length,
                        size: 5,
                        padding: 0,
                        selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color]),
                        unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!]),
                      ),
                    )
                  ],
                ),
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
              child: TextFormField(
                controller: homeController.taskNameEditController,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!)
                  ),
                  prefixIcon: Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey[400],
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (homeController.formKey.currentState!.validate()) {
                        var success = homeController.addTodo(homeController.taskNameEditController.text);
                        if (success) {
                          EasyLoading.showSuccess("Todo item add successfully");
                        } else {
                          EasyLoading.showError("Tdod item alreay exist !");
                        }
                        homeController.taskNameEditController.clear();
                      }
                    },
                    icon: const Icon(Icons.done),
                  )
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your todo item";
                  }
                  return null;
                },
              ),
            ),
          DoingList(),
          DoneList(),
        ],
      ),
          )),
    );
  }
}
