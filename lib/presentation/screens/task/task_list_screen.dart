import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../bloc/task/task_bloc.dart';
import '../../../data/classes/language_constant.dart';
import '../../../data/model/project_details.dart';
import '../../../data/model/task_details.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/connectivity.dart';
import '../../routes/pages_name.dart';
import '../../widgets/widgets.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TextEditingController? _taskNameController, _searchController;
  FocusNode? _searchFocusNode;
  ScrollController? scrollController;
  TaskBloc? taskBloc;
  String? userId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int page = 1;
  int limit = 10;
  bool isLastTask = false;
  bool isLastProject = false;
  bool isProjectListDisplay = false, textClear = false;
  List<TaskDetails>? taskList;
  List<ProjectDetails>? projectList;
  String? _selectedFilter;
  String? projectName;
  bool isLoading = false;

  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    taskBloc = BlocProvider.of<TaskBloc>(context);
    _taskNameController = TextEditingController();
    _searchController = TextEditingController();
    scrollController = ScrollController();
    _searchFocusNode = FocusNode();
    userId = FirebaseAuth.instance.currentUser!.uid;
    netWorkStatusCheck();
    scrollController!.addListener(loadMore);
    super.initState();
  }

  netWorkStatusCheck() async {
    await connectivityCheck().then((internet) {
      if (!internet && mounted) {
        showModal(context, () {
          getAllTasksByUserId();
        });
      } else {
        getAllTasksByUserId();
      }
    });
  }

  getCompletedTasks() {
    taskBloc!
        .add(GetCompletedTasks(userId!, page, limit, _searchController!.text));
  }

  getCreatedByMeTasks() {
    taskBloc!.add(
        GetCreatedByMeTasks(userId!, page, limit, _searchController!.text));
  }

  getAssignToMeTasks() {
    taskBloc!
        .add(GetAssignToMeTasks(userId!, page, limit, _searchController!.text));
  }

  getOverdueTasks() {
    taskBloc!
        .add(GetOverdueTasks(userId!, page, limit, _searchController!.text));
  }

  getAllTasksByUserId() {
    taskBloc!.add(
        GetAllTasksByUserId(userId!, page, limit, _searchController!.text));
  }

  getAllTasksByProject() {
    taskBloc!.add(
        GetAllTasksByProject(userId!, page, limit, _searchController!.text));
  }

  taskFilters(String filter) {
    page = 1;
    setState(() {
      _selectedFilter = filter;
    });
    if (_selectedFilter == null ||
        _selectedFilter == translation(context).allTasks) {
      isProjectListDisplay = false;
      getAllTasksByUserId();
    } else if (_selectedFilter == translation(context).assignToMe) {
      isProjectListDisplay = false;
      getAssignToMeTasks();
    } else if (_selectedFilter == translation(context).createdByMe) {
      isProjectListDisplay = false;
      getCreatedByMeTasks();
    } else if (_selectedFilter == translation(context).overdueTasks) {
      isProjectListDisplay = false;
      getOverdueTasks();
    } else if (_selectedFilter == translation(context).completedTasks) {
      isProjectListDisplay = false;
      getCompletedTasks();
    } else if (_selectedFilter == translation(context).groupByProject) {
      isProjectListDisplay = true;
      getAllTasksByProject();
    }
  }

  Future<void> loadMore() async {
    if (isLoading && (isLastTask || isLastProject)) return;

    double maxScroll = scrollController!.position.maxScrollExtent;
    double offset = scrollController!.offset;

    if (offset >= maxScroll && !scrollController!.position.outOfRange) {
      isLoading = true;
      page = page + 1;

      try {
        if (_selectedFilter == null ||
            _selectedFilter == translation(context).allTasks) {
          await getAllTasksByUserId();
        } else if (_selectedFilter == translation(context).assignToMe) {
          await getAssignToMeTasks();
        } else if (_selectedFilter == translation(context).createdByMe) {
          await getCreatedByMeTasks();
        } else if (_selectedFilter == translation(context).overdueTasks) {
          await getOverdueTasks();
        } else if (_selectedFilter == translation(context).completedTasks) {
          await getCompletedTasks();
        } else if (_selectedFilter == translation(context).groupByProject) {
          await getAllTasksByProject();
        }
      } finally {
        isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: BlocListener<TaskBloc, TaskState>(
            bloc: taskBloc,
            listener: (context, state) {
              if (state is CreateTaskSuccess) {
                Navigator.pop(context);
                taskFilters(translation(context).allTasks);
                showAlertSnackBar(
                    context,
                    translation(context).taskCreatedSuccessfully,
                    AlertType.success);
              } else if (state is CreateTaskFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetAllTasksSuccess) {
                if (page == 1) {
                  isLastTask = state.taskDetails.isEmpty;
                  taskList = state.taskDetails;
                } else {
                  isLastTask = state.taskDetails.isEmpty;
                  taskList!.addAll(state.taskDetails);
                }
              } else if (state is GetAllTasksFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetCompletedTasksSuccess) {
                if (page == 1) {
                  isLastTask = state.getCompletedTaskDetails.isEmpty;
                  taskList = state.getCompletedTaskDetails;
                } else {
                  isLastTask = state.getCompletedTaskDetails.isEmpty;
                  taskList!.addAll(state.getCompletedTaskDetails);
                }
              } else if (state is GetCompletedTasksFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetCreatedByMeTasksSuccess) {
                if (page == 1) {
                  isLastTask = state.getCreatedByMeTaskDetails.isEmpty;
                  taskList = state.getCreatedByMeTaskDetails;
                } else {
                  isLastTask = state.getCreatedByMeTaskDetails.isEmpty;
                  taskList!.addAll(state.getCreatedByMeTaskDetails);
                }
              } else if (state is GetCreatedByMeTasksFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetAssignToMeTasksSuccess) {
                if (page == 1) {
                  isLastTask = state.getAssignToMeTaskDetails.isEmpty;
                  taskList = state.getAssignToMeTaskDetails;
                } else {
                  isLastTask = state.getAssignToMeTaskDetails.isEmpty;
                  taskList!.addAll(state.getAssignToMeTaskDetails);
                }
              } else if (state is GetAssignToMeTasksFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetOverdueTasksSuccess) {
                if (page == 1) {
                  isLastTask = state.getOverdueTaskDetails.isEmpty;
                  taskList = state.getOverdueTaskDetails;
                } else {
                  isLastTask = state.getOverdueTaskDetails.isEmpty;
                  taskList!.addAll(state.getOverdueTaskDetails);
                }
              } else if (state is GetOverdueTasksFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetAllTasksByUserIdSuccess) {
                if (page == 1) {
                  isLastTask = state.getAllTasksByUserIdDetails.isEmpty;
                  taskList = state.getAllTasksByUserIdDetails;
                } else {
                  isLastTask = state.getAllTasksByUserIdDetails.isEmpty;
                  taskList!.addAll(state.getAllTasksByUserIdDetails);
                }
              } else if (state is GetAllTasksByUserIdFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              } else if (state is GetAllTasksByProjectSuccess) {
                if (page == 1) {
                  isLastProject = state.getAllTaskByProject.isEmpty;
                  projectList = state.getAllTaskByProject;
                } else {
                  isLastProject = state.getAllTaskByProject.isEmpty;
                  projectList!.addAll(state.getAllTaskByProject);
                }
              } else if (state is GetAllTasksByProjectFailed) {
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              }
            },
            child: BlocBuilder<TaskBloc, TaskState>(
                bloc: taskBloc,
                builder: (context, state) {
                  if (state is CreateTaskLoading ||
                      state is GetAllTasksLoading ||
                      state is GetCompletedTaskLoading ||
                      state is GetCreatedByMeTaskLoading ||
                      state is GetAssignToMeTaskLoading ||
                      state is GetOverdueTaskLoading ||
                      state is GetAllTasksByUserIdLoading ||
                      state is GetAllTasksByProjectLoading) {
                    return const Loading();
                  } else {
                    return RefreshIndicator(
                        backgroundColor: bgColor,
                        color: primaryColor,
                        onRefresh: () {
                          page = 1;
                          taskFilters(
                              _selectedFilter ?? translation(context).allTasks);
                          return Future.value();
                        },
                        child: _buildBody());
                  }
                })),
        bottomNavigationBar: _buildBottomAppBar());
  }

  Widget _buildBody() {
    return Column(children: [
      SizedBox(height: 5.h),
      Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 2.h),
        child: _buildSearchTextField(),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildHeadingText(_selectedFilter ?? translation(context).allTasks),
        _buildFilterText(translation(context).filter),
      ]),
      (taskList != null && taskList!.isNotEmpty)
          ? Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: isProjectListDisplay
                    ? _buildProjectCard()
                    : _buildTaskCard(),
              ),
            )
          : Expanded(
              child: Center(
                  child: Text(
                      isProjectListDisplay
                          ? translation(context).noProjectsAvailabe
                          : translation(context).noTasksAvailable,
                      style: TextStyle(fontSize: 16.sp, color: greyTextColor))))
    ]);
  }

  Widget _buildSearchTextField() {
    return TextFormField(
        enabled: true,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onEditingComplete: () {
          if (_searchController!.text.isNotEmpty && _searchController != null) {
            taskFilters(_selectedFilter ?? translation(context).allTasks);
          }
        },
        onChanged: (value) {
          setState(() {
            textClear = value.isEmpty ? false : true;
          });
        },
        controller: _searchController,
        focusNode: _searchFocusNode,
        maxLines: 1,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            suffixIcon: textClear
                ? GestureDetector(
                    onTap: () {
                      if (_searchController!.text.isNotEmpty &&
                          _searchController != null) {
                        setState(() {
                          _searchController!.clear();
                          page = 1;
                          projectList = [];
                          textClear = false;
                        });
                        taskFilters(
                            _selectedFilter ?? translation(context).allTasks);
                      }
                    },
                    child: const Icon(Icons.clear, color: black))
                : const SizedBox(),
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: white,
            hintText: isProjectListDisplay
                ? translation(context).searchProject
                : translation(context).searchTask,
            hintStyle: TextStyle(color: lightTextColor.withValues(alpha: .5)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(width: 1.w)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                    color: greyBorderColor.withValues(alpha: .2), width: 1.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: greyBorderColor, width: 1.w)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w)),
        style: const TextStyle(color: lightTextColor));
  }

  Widget _buildHeadingText(String text) {
    return Padding(
        padding: EdgeInsets.only(left: 8.h),
        child: Text(text,
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600)));
  }

  Widget _buildFilterText(String text) {
    return Padding(
        padding: EdgeInsets.only(right: 8.h),
        child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        backgroundColor: white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r)),
                        content: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      title: Text(
                                          translation(context).assignToMe,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        taskFilters(
                                            translation(context).assignToMe);
                                      }),
                                  ListTile(
                                      title: Text(
                                          translation(context).createdByMe,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        taskFilters(
                                            translation(context).createdByMe);
                                      }),
                                  ListTile(
                                      title: Text(translation(context).allTasks,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        taskFilters(
                                            translation(context).allTasks);
                                      }),
                                  ListTile(
                                      title: Text(
                                          translation(context).overdueTasks,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        taskFilters(
                                            translation(context).overdueTasks);
                                      }),
                                  ListTile(
                                      title: Text(
                                          translation(context).completedTasks,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        taskFilters(translation(context)
                                            .completedTasks);
                                      }),
                                  ListTile(
                                      title: Text(
                                          translation(context).groupByProject,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        taskFilters(translation(context)
                                            .groupByProject);
                                      })
                                ])));
                  });
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.filter_list_rounded, size: 24, color: black),
              SizedBox(width: 5.w),
              Text(text,
                  style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600))
            ])));
  }

  Widget _buildTaskCard() {
    return ListView.builder(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: !isLastTask ? taskList!.length + 1 : taskList!.length,
        itemBuilder: (context, index) {
          if (index == taskList!.length) {
            return isLastTask || taskList!.length < limit
                ? const SizedBox()
                : Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10.h),
                      height: 40,
                      width: 40,
                      child: const Loading(),
                    ),
                  );
          } else {
            final task = taskList![index];
            return TaskListWidget(
              task: task,
              index: index,
              onTaskTap: (taskId) async {
                final result = await Navigator.of(context).pushNamed(
                  PageName.updateTaskScreen,
                  arguments: taskId,
                );

                if (context.mounted) {
                  if (result == true) {
                    taskFilters(translation(context).allTasks);
                  }
                }
              },
              onCheckboxChanged: (value) {
                // setState(() {
                //   task.isCompleted = value ?? false;
                // });
              },
            );
          }
        });
  }

  Widget _buildProjectCard() {
    return ListView.builder(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            !isLastProject ? projectList!.length + 1 : projectList!.length,
        itemBuilder: (context, index) {
          if (index == projectList!.length) {
            return isLastProject || projectList!.length < limit
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 40,
                            width: 40,
                            child: const Loading())
                      ]);
          } else {
            final project = projectList![index];
            return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: GestureDetector(
                    onTap: () {
                      final projectDetails = projectList![index];
                      Navigator.of(context).pushNamed(
                          PageName.projectTaskListScreen,
                          arguments: {
                            'isProjectTask': false,
                            'project': projectDetails
                          });
                    },
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
                        padding: EdgeInsets.only(
                            right: 5.w, left: 5.w, top: 4.h, bottom: 4.h),
                        child: Row(children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Container(
                                            width: 40.w,
                                            height: 35.h,
                                            decoration: BoxDecoration(
                                                color: getAvatarColor(index),
                                                borderRadius:
                                                    BorderRadius.circular(3.r)),
                                            alignment: Alignment.center,
                                            child: Text(
                                                getInitials(
                                                    project.projectName ?? ''),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: white,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        SizedBox(width: 10.w),
                                        Text(project.projectName ?? '',
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ])
                                    ])
                              ])),
                          Row(
                            children: [
                              (projectList![index].taskCount != null &&
                                      projectList![index].taskCount! > 0)
                                  ? CircleAvatar(
                                      radius: 13.r,
                                      backgroundColor: primaryColor,
                                      child: Text(
                                        projectList![index]
                                            .taskCount
                                            .toString(),
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          )
                        ]))));
          }
        });
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
        height: 70, color: bgColor, child: _buildCreateTaskButton());
  }

  Widget _buildCreateTaskButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          minimumSize: Size.fromHeight(40.h),
        ),
        onPressed: () {
          _showCreateTaskForm();
        },
        child: Text(translation(context).createTask,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500)));
  }

  void _showCreateTaskForm() {
    showModalBottomSheet(
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: white,
        context: context,
        isScrollControlled: true,
        elevation: 0,
        builder: (BuildContext context) {
          return Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: EdgeInsets.all(10.h),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(translation(context).createTask,
                                    style: const TextStyle(fontSize: 18))),
                            const SizedBox(height: 10.0),
                            TextFormField(
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                controller: _taskNameController,
                                cursorColor: lightTextColor,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: lightTextColor,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        borderSide: BorderSide(width: 2.w)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        borderSide: BorderSide(
                                            color: greyBorderColor.withValues(
                                                alpha: .2),
                                            width: 2.w)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        borderSide: BorderSide(
                                            color: greyBorderColor,
                                            width: 2.w)),
                                    filled: true,
                                    fillColor: white,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.h),
                                    hintText: translation(context).taskName,
                                    hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color:
                                            lightTextColor.withValues(alpha: .5),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return translation(context)
                                        .pleaseEnterTaskName;
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 10.0),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(translation(context).cancel,
                                          style: const TextStyle(
                                              color: greyTextColor))),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          taskBloc!.add(CreateTask(
                                              _taskNameController!.text.trim(),
                                              userId!));
                                        }
                                        _taskNameController!.clear();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor),
                                      child: Text(translation(context).create,
                                          style: const TextStyle(color: white)))
                                ])
                          ]))));
        });
  }
}
