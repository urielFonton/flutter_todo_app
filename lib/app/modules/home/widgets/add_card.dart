import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/app/core/utils/extension.dart';
import 'package:getx_todo_app/app/core/values/colors.dart';
import 'package:getx_todo_app/app/data/models/task.dart';
import 'package:getx_todo_app/app/modules/home/home_controller.dart';
import 'package:getx_todo_app/app/widgets/icons.dart';

class AddCard extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  AddCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;

    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
            radius: 5,
            title: 'Task Type',
            content: Form(
              key: homeController.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeController.taskNameEditController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0.wp))),
                          labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          print("Task title cannot be null");
                          return 'Please enter your task title';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                    child: Wrap(
                      spacing: 2.0.wp,
                      children: icons
                          .map((e) => Obx(() {
                                final index = icons.indexOf(e);
                                return ChoiceChip(
                                  selectedColor: Colors.grey[200],
                                  pressElevation: 0,
                                  backgroundColor: Colors.white,
                                  label: e,
                                  selected:
                                      homeController.chipIndex.value == index,
                                  onSelected: (bool selected) {
                                    homeController.chipIndex.value =
                                        selected ? index : 0;
                                  },
                                );
                              }))
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(150, 40)),
                    onPressed: () {
                      if (homeController.formKey.currentState!.validate()) {
                        int icon = icons[homeController.chipIndex.value]
                            .icon!
                            .codePoint;
                        String color = icons[homeController.chipIndex.value]
                            .color!
                            .toHex();
                        var task = Task(
                            title: homeController.taskNameEditController.text,
                            icon: icon,
                            color: color);
                        Get.back();
                        homeController.addTask(task)
                            ? EasyLoading.showSuccess('Success')
                            : EasyLoading.showError('Task already exist');
                      }
                    },
                    child: const Text('Create Task'),
                  )
                ],
              ),
            ),
          );
          homeController.taskNameEditController.clear();
          homeController.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 8.0.wp,
                  color: Colors.grey,
                ),
                Text('(Add your task type)', style: TextStyle(color: Colors.grey, fontSize: 10.0.sp, fontWeight: FontWeight.w600),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
