import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/app/core/utils/extension.dart';
import 'package:getx_todo_app/app/modules/home/home_controller.dart';

class AddDialog extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  AddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Form(
          key: homeController.formKey,
          child: ListView(
            children: [
              // *********************************************Entête de la page************************************
              Padding(
                padding: EdgeInsets.all(1.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeController.taskNameEditController.clear();
                        homeController.selectTask(null);
                      },
                      icon: const Icon(Icons.close),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        if (homeController.formKey.currentState!.validate()) {
                          if (homeController.task.value == null) {
                            EasyLoading.showError('Please select task type');
                          } else {
                            var success = homeController.updateTask(homeController.task.value!, homeController.taskNameEditController.text,);
                            if (success) {
                              EasyLoading.showSuccess('Todo item add success');
                              Get.back();
                              homeController.selectTask(null);
                            } else {
                              EasyLoading.showError('Todo Item already exist');
                            }
                            homeController.taskNameEditController.clear();
                          }
                        }
                      },
                      child: Text('Done', style: TextStyle(fontSize: 14.0.sp),),
                    )
                  ],
                ),
              ),
              // *********************************************************************************************************

              // *************************************Titre de la nouvelle tâche******************************************
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.wp, vertical: 2.0.wp),
                child: Text('New Task', style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              // *********************************************************************************************************

              // ***************************************** Form to put task name *****************************************
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeController.taskNameEditController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    hintText: "Enter your task name",
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
              // **********************************************************************************************************

              // ************************************* Subtitle **********************************************************
              Padding(
                padding: EdgeInsets.only(
                  top: 5.0.wp,
                  left: 5.0.wp,
                  right: 5.0.wp,
                  bottom: 2.0.wp,
                ),
                child: Text('Add to', style: TextStyle(
                  fontSize: 12.0.sp,
                  color: Colors.grey,
                ),),
              ),
              // **********************************************************************************************************
              ...homeController.tasks.map((element) =>
                Obx(
                  () => InkWell(
                    onTap: () => homeController.selectTask(element),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.wp, vertical: 2.0.wp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(IconData(element.icon, fontFamily: 'MaterialIcons'),
                                color: HexColor.fromHex(element.color),
                              ),
                              SizedBox(
                                width: 3.0.wp,
                              ),
                              Text(element.title, style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          if (homeController.task.value == element)
                            const Icon(Icons.check, color: Colors.blue,)
                        ],
                      ),
                    ),
                  ),
                )).toList()
            ],
          ),
        ),
      ),
    );
  }
}
