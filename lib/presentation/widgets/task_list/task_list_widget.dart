import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/classes/language_constant.dart';
import '../../../data/model/task_details.dart';
import '../../../utils/utils.dart';
import '../widgets.dart';

class TaskListWidget extends StatefulWidget {
  final TaskDetails task;
  final Function(String taskId) onTaskTap;
  final Function(bool? value) onCheckboxChanged;
  final int index;

  const TaskListWidget(
      {super.key,
      required this.task,
      required this.onTaskTap,
      required this.onCheckboxChanged,
      required this.index});

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  bool? isTaskCompleted;
  String? taskName;
  String? taskOwnerName;
  String? taskEndTime;
  String? projectName;

  @override
  void initState() {
    isTaskCompleted = widget.task.isCompleted ?? false;
    taskName = widget.task.taskName ?? '';
    taskOwnerName = widget.task.taskOwner?.userName;
    taskEndTime = widget.task.taskEndTime;
    projectName = widget.task.project?.projectName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: GestureDetector(
            onTap: () => widget.onTaskTap(widget.task.taskId!),
            child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: boxShadowBlackColor,
                          blurRadius: 1,
                          offset: Offset(0, 2))
                    ]),
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 12.w),
                child: Row(children: [
                  Checkbox(
                    activeColor: primaryColor,
                    value: isTaskCompleted,
                    onChanged: widget.onCheckboxChanged,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(taskName!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          decoration: isTaskCompleted == true
                                              ? TextDecoration.lineThrough
                                              : null))),
                              (taskOwnerName != null)
                                  ? CircleAvatar(
                                      radius: 12,
                                      backgroundColor:
                                          getAvatarColor(widget.index),
                                      child: Text(getInitials(taskOwnerName!),
                                          style: const TextStyle(
                                              fontSize: 10, color: white)))
                                  : const SizedBox()
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (taskEndTime != null &&
                                  taskEndTime!.isNotEmpty)
                                Expanded(
                                    child: Text(
                                        "${translation(context).dueDate}: ${ConvertionUtil.convertLocalDateMonthFromString(taskEndTime!)}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: greyTextColor))),
                              if (projectName != null &&
                                  projectName!.isNotEmpty)
                                Expanded(
                                    child: Text(projectName!,
                                        style: const TextStyle(
                                            fontSize: 12, color: greyTextColor),
                                        textAlign: TextAlign.right))
                            ])
                      ]))
                ]))));
  }
}
