import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../bloc/bloc.dart';
import '../../../data/classes/language_constant.dart';
import '../../../data/model/owner_detail.dart';
import '../../../data/model/project_details.dart';
import '../../../data/model/subtask.dart';
import '../../../data/model/task_details.dart';
import '../../../data/model/user_detail.dart';
import '../../../utils/colors/colors.dart';
import '../../routes/pages_name.dart';
import '../../widgets/widgets.dart';

class UpdateTaskScreen extends StatefulWidget {
  final String? taskId;
  const UpdateTaskScreen({super.key, required this.taskId});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TaskBloc? taskBloc;
  UserBloc? userBloc;

  final ImagePicker imagePicker = ImagePicker();
  List<File>? selectedPOCFiles = [], selectedFiles = [];
  List<int> removedMediaPotisions = [],
      removedExistingImagePotision = [],
      removedSubtaskPOCImagePosition = [],
      removedSubtaskMediaPositions = [],
      removedSubtaskDocumentPositions = [];
  ProjectBloc? projectBloc;
  List<ProjectDetails>? projectList = [];
  int page = 1, limit = 10;
  bool isLastUser = false, isLastProject = false;
  List<UserDetail>? usersList = [];
  List<SubTasks>? subTasks = [];
  List<SubTasks>? updatedSubTasks = [];
  String? userId,
      userName,
      taskId,
      taskName,
      taskDescription,
      taskDueDate,
      assignedUserId,
      creatorId,
      assignedUserName,
      projectName,
      projectId;
  bool? isSubCompleted = false, isPOCFiles;
  bool isSubTaskEqual = true,
      isCompleted = false,
      textClear = false,
      isProofOfCompletion = false;

  List<TextEditingController>? _subTaskController;
  TextEditingController? _taskNameController,
      _taskDescriptionController,
      _taskDueDateController,
      _taskAssignToController,
      _taskProjectController,
      _searchUserController,
      _searchProjectController;

  FocusNode? _taskNameFocusNode,
      _taskDescriptionFocusNode,
      _taskAssignToFocusNode,
      _taskProjectFocusNode,
      _searchFocusNode;
  TaskDetails? task;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    taskId = widget.taskId;
    taskBloc = BlocProvider.of<TaskBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);
    projectBloc = BlocProvider.of<ProjectBloc>(context);
    getTaskByUserId();
    _subTaskController = [];
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _taskDueDateController = TextEditingController();
    _taskAssignToController = TextEditingController();
    _taskProjectController = TextEditingController();
    _searchUserController = TextEditingController();
    _searchProjectController = TextEditingController();

    _taskNameFocusNode = FocusNode();
    _taskDescriptionFocusNode = FocusNode();
    _taskAssignToFocusNode = FocusNode();
    _taskProjectFocusNode = FocusNode();
    _searchFocusNode = FocusNode();
    userId = FirebaseAuth.instance.currentUser!.uid;
    userName = FirebaseAuth.instance.currentUser!.displayName;

    super.initState();
  }

  @override
  void dispose() {
    _taskNameController!.dispose();
    _taskDescriptionController!.dispose();
    _taskDueDateController!.dispose();
    _taskAssignToController!.dispose();
    _taskProjectController!.dispose();

    _taskNameFocusNode!.dispose();
    _taskDescriptionFocusNode!.dispose();
    _taskAssignToFocusNode!.dispose();
    _taskProjectFocusNode!.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _taskDueDateController!.text =
            '${DateFormat('yyyy-MM-dd').format(pickedDate)}T00:00:00.00';
      });
    }
  }

  taskDetailDisplay() {
    if (task != null) {
      taskId = task!.taskId;
      isCompleted = task!.isCompleted ?? false;
      taskName = _taskNameController!.text = task!.taskName ?? '';
      taskDescription =
          _taskDescriptionController!.text = task!.taskDescription ?? '';
      taskDueDate = _taskDueDateController!.text = task!.taskEndTime ?? '';
      if (task!.taskOwner != null) {
        assignedUserId = task!.taskOwner!.userId ?? '';
        assignedUserName =
            _taskAssignToController!.text = task!.taskOwner!.userName ?? '';
      }
      if (task!.taskCreator != null) {
        creatorId = task!.taskCreator!.userId;
      }
      isCompleted = task!.isCompleted ?? false;
      if (task!.project != null) {
        projectId = task!.project!.projectId;
        projectName =
            _taskProjectController!.text = task!.project!.projectName!;
        projectId = task!.project!.projectId;
      }
      isProofOfCompletion = task!.proofOfCompletion ?? false;

      subTasks = task!.subTasks;
      if (subTasks != null) {
        for (var subtask in subTasks!) {
          _subTaskController!.add(TextEditingController());
          _subTaskController![subTasks!.indexOf(subtask)].text =
              subtask.subTaskName!;
          updatedSubTasks!.add(subtask);
        }
      }
    }
  }

  getTaskByUserId() {
    taskBloc!.add(GetTaskById(taskId!));
  }

  getAllUsers() {
    userBloc!.add(GetAllUsers(_searchUserController!.text, limit, page));
  }

  getAllProjects() {
    projectBloc!
        .add(GetAllProjects(page, limit, _searchProjectController!.text));
  }

  Future getImageFromCamera(bool isPOCFiles) async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    await processPickedImage(pickedImage, isPOCFiles);
  }

  processPickedImage(pickedImage, isPOCFiles) async {
    var croppedFile = await cropImage(pickedImage);
    setState(() {
      if (croppedFile != null) {
        setState(() {
          isPOCFiles
              ? selectedPOCFiles!.add(File(croppedFile.path))
              : selectedFiles!.add(File(croppedFile.path));
        });
      }
    });
  }

  Future<void> getVideoFromCamera() async {
    final pickedVideo = await imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedVideo != null) {
      setState(() {
        selectedPOCFiles!.add(File(pickedVideo.path));
      });
    }
  }

  Future getVideoFile() async {
    final pickedFile = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedFiles!.add(File(pickedFile.path));
      });
    }
  }

  Future getImageFromGallery(bool isPOCFiles) async {
    final pickedImage = await imagePicker.pickMultiImage();
    setState(() {
      if (pickedImage.isNotEmpty) {
        selectedFiles!.addAll(pickedImage.map((image) => File(image.path)));
      }
    });
  }

  Future getAttachmentFromGallery(context) async {
    try {
      FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
      );
      setState(() {
        if (pickedFiles != null) {
          selectedFiles!.add(File(pickedFiles.files.single.path!));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == "read_external_storage_denied") {
        showAlertSnackBar(
            context, translation(context).appSettingConfirm, AlertType.info);
      }
    }
  }

  updateSubtaskList() {
    if (updatedSubTasks!.length == subTasks!.length) {
      for (var i = 0; i < subTasks!.length; i++) {
        if (subTasks![i].subTaskName != updatedSubTasks![i].subTaskName ||
            subTasks![i].subTaskOwner != updatedSubTasks![i].subTaskOwner ||
            subTasks![i].isCompleted != updatedSubTasks![i].isCompleted ||
            subTasks![i].subTaskProofOfCompletion !=
                updatedSubTasks![i].subTaskProofOfCompletion ||
            subTasks![i].subTaskDescription !=
                updatedSubTasks![i].subTaskDescription ||
            subTasks![i].subTaskProofOfCompletionImage !=
                updatedSubTasks![i].subTaskProofOfCompletionImage) {
          isSubTaskEqual = false;
          return;
        } else {
          isSubTaskEqual = true;
        }
      }
    } else {
      isSubTaskEqual = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(false);
        return;
      },
      child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: bgColor,
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              title: Text(translation(context).updateTask),
              actions: [
                IconButton(
                    icon: const Icon(Icons.delete, color: redIconColor),
                    onPressed: () {
                      showAlertWithAction(
                          context: context,
                          title: translation(context).deleteTask,
                          content: translation(context).doYouWantToDeleteTask,
                          onPress: () {
                            taskBloc!.add(DeleteTask(taskId!));
                          });
                    })
              ]),
          body: MultiBlocListener(
              listeners: [
                BlocListener(
                    bloc: taskBloc,
                    listener: (context, state) {
                      if (state is UpdateTaskSuccess) {
                        Navigator.pop(context, true);
                        showAlertSnackBar(
                            context,
                            translation(context).taskUpdatedSuccessfully,
                            AlertType.success);
                      } else if (state is UpdateTaskFailed) {
                        showAlertSnackBar(
                            context, state.errorMessage, AlertType.error);
                      } else if (state is DeleteTaskSuccess) {
                        Navigator.pop(context, true);
                        showAlertSnackBar(
                            context,
                            translation(context).taskDeletedSuccessfully,
                            AlertType.success);
                      } else if (state is DeleteTaskFailed) {
                        showAlertSnackBar(
                            context, state.errorMessage, AlertType.error);
                      } else if (state is GetTaskByIdSuccess) {
                        task = state.taskById;
                        taskDetailDisplay();
                      } else if (state is GetTaskByIdFailed) {
                        showAlertSnackBar(
                            context, state.errorMessage, AlertType.error);
                      }
                    }),
                BlocListener(
                    bloc: userBloc,
                    listener: (context, state) {
                      if (state is GetAllUsersSuccess) {
                        if (page == 1) {
                          isLastUser = state.usersList.isEmpty;
                          usersList = state.usersList;
                        } else {
                          isLastUser = state.usersList.isEmpty;
                          usersList!.addAll(state.usersList);
                        }
                      } else if (state is GetAllUsersFailed) {
                        showAlertSnackBar(
                            context, state.errorMessage, AlertType.error);
                      }
                    }),
                BlocListener(
                    bloc: projectBloc,
                    listener: (context, state) {
                      if (state is GetAllProjectsSuccess) {
                        if (page == 1) {
                          isLastProject = state.projectDetails.isEmpty;
                          projectList = state.projectDetails;
                        } else {
                          isLastUser = state.projectDetails.isEmpty;
                          projectList!.addAll(state.projectDetails);
                        }
                      } else if (state is GetAllUsersFailed) {
                        showAlertSnackBar(
                            context, state.errorMessage, AlertType.error);
                      }
                    })
              ],
              child: BlocBuilder<TaskBloc, TaskState>(
                  bloc: taskBloc,
                  builder: (context, state) {
                    return BlocBuilder<UserBloc, UserState>(
                        bloc: userBloc,
                        builder: (context, state) {
                          if (state is UpdateTaskLoading ||
                              state is GetTaskByIdLoading) {
                            return const Loading();
                          } else {
                            return SingleChildScrollView(child: _buildBody());
                          }
                        });
                  }))),
    );
  }

  Widget _buildBody() {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 10.h),
              taskNameTextBox(),
              SizedBox(height: 10.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: buildHeading(translation(context).addSubTask)),
                InkWell(
                    onTap: () {
                      setState(() {
                        _subTaskController!.add(TextEditingController());
                        SubTasks subTask = SubTasks(
                            '',
                            '',
                            '',
                            null,
                            Owner(userId: userId, userName: userName),
                            false,
                            false, [], []);
                        updatedSubTasks!.add(subTask);
                      });
                    },
                    child: const Icon(Icons.add, color: primaryColor))
              ]),
              _buildSubTaskWidget(),
              taskDescriptionTextBox(),
              SizedBox(height: 10.h),
              taskDueDateTextBox(),
              SizedBox(height: 10.h),
              taskAssignToTextBox(),
              SizedBox(height: 10.h),
              taskProjectTextBox(),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: buildHeading(translation(context).addFile),
              ),
              _buildAddAttachmentField(),
              SizedBox(height: 10.h),
              Padding(
                padding: (creatorId == userId)
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: 10.w, right: 10.w),
                child: (creatorId == userId)
                    ? Row(children: [
                        Checkbox(
                            activeColor: primaryColor,
                            value: isProofOfCompletion,
                            onChanged: (bool? value) {
                              setState(() {
                                isProofOfCompletion = value ?? false;
                              });
                            }),
                        buildHeading(translation(context).proofOfCompletion),
                      ])
                    : const SizedBox(),
              ),
              isProofOfCompletion
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (creatorId == userId)
                                ? const SizedBox()
                                : buildHeading(
                                    '${translation(context).proofOfCompletion}*'),
                            _buildAddPOCImageField(),
                            Row(children: [
                              InkWell(
                                  onTap: () {
                                    isPOCFiles = true;
                                    getImageFromCamera(isPOCFiles!);
                                  },
                                  child: const Icon(Icons.camera_alt_rounded,
                                      color: black)),
                              SizedBox(width: 5.w),
                              InkWell(
                                  onTap: () {
                                    getVideoFromCamera();
                                  },
                                  child: const Icon(Icons.video_camera_back,
                                      color: black)),
                              SizedBox(width: 5.w)
                            ])
                          ]))
                  : const SizedBox(),
              SizedBox(height: 10.h),
              InkWell(
                  onTap: () {
                    updateSubtaskList();
                    if (_formKey.currentState!.validate()) {
                      if (selectedPOCFiles!.isEmpty &&
                          creatorId! != userId &&
                          task!.proofOfCompletionImages!.isEmpty) {
                        showAlertSnackBar(
                            context,
                            translation(context).attachProofofcompletion,
                            AlertType.info);
                      } else if (isProofOfCompletion !=
                              task!.proofOfCompletion ||
                          isCompleted != task!.isCompleted ||
                          taskName != _taskNameController!.text ||
                          taskDescription != _taskDescriptionController!.text ||
                          taskDueDate != _taskDueDateController!.text ||
                          assignedUserName != _taskAssignToController!.text ||
                          projectName != _taskProjectController!.text ||
                          !isSubTaskEqual ||
                          selectedPOCFiles!.isNotEmpty ||
                          selectedFiles!.isNotEmpty ||
                          removedMediaPotisions.isNotEmpty ||
                          removedExistingImagePotision.isNotEmpty) {
                        taskBloc!.add(UpdateTask(
                            taskId!,
                            _taskNameController!.text.trim(),
                            _taskDescriptionController!.text.trim(),
                            _taskDueDateController!.text.trim(),
                            projectId!,
                            assignedUserId!,
                            updatedSubTasks!,
                            selectedPOCFiles,
                            removedMediaPotisions,
                            isCompleted,
                            isProofOfCompletion,
                            selectedFiles,
                            removedExistingImagePotision,
                            removedSubtaskMediaPositions,
                            removedSubtaskDocumentPositions));
                      } else {
                        showAlertSnackBar(context,
                            translation(context).noChangesMade, AlertType.info);
                      }
                    }
                  },
                  child: updateTaskButton()),
              SizedBox(height: 10.h)
            ])));
  }

  Widget buildHeading(title) {
    return Text(title,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: greyTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500));
  }

  Widget taskNameTextBox() {
    return TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: _taskNameController,
        focusNode: _taskNameFocusNode,
        maxLines: null,
        decoration: InputDecoration(
          prefixIcon: Checkbox(
              activeColor: primaryColor,
              value: isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  isCompleted = value ?? false;
                });
              }),
          filled: true,
          fillColor: white,
          hintText: translation(context).taskName,
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
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        ),
        style: const TextStyle(color: lightTextColor),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translation(context).enterTaskName;
          }
          return null;
        });
  }

  Widget taskDescriptionTextBox() {
    return TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        maxLines: 5,
        controller: _taskDescriptionController,
        focusNode: _taskDescriptionFocusNode,
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            filled: true,
            fillColor: white,
            hintText: translation(context).taskDescription,
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
                borderSide: BorderSide(color: greyBorderColor, width: 1.w))),
        style: const TextStyle(color: lightTextColor),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translation(context).enterTaskDescription;
          }
          return null;
        });
  }

  Widget taskDueDateTextBox() {
    return TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: _taskDueDateController,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: white,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          hintText: translation(context).dueDate,
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
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        ),
        style: const TextStyle(color: lightTextColor),
        onTap: () => _selectDueDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translation(context).pleaseSelectDuedate;
          }
          return null;
        });
  }

  Widget taskAssignToTextBox() {
    return TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: _taskAssignToController,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: white,
          prefixIcon: const Icon(Icons.people_alt_rounded),
          hintText: translation(context).assignTo,
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
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        ),
        style: const TextStyle(color: lightTextColor),
        onTap: () {
          getAllUsers();
          _showAssignToBottomSheet();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translation(context).pleaseAssignMember;
          }
          return null;
        });
  }

  void _showAssignToBottomSheet() {
    showModalBottomSheet(
        backgroundColor: white,
        isScrollControlled: true,
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: 250.h,
                color: white,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                          child: Text(translation(context).assignTo,
                              style: const TextStyle(fontSize: 18))),
                      const SizedBox(height: 10),
                      Text(translation(context).membersList,
                          style: const TextStyle(
                              fontSize: 12, color: greyTextColor),
                          textAlign: TextAlign.left),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: true,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onEditingComplete: () {
                          if (_searchUserController!.text.isNotEmpty &&
                              _searchUserController != null) {
                            page = 1;
                            getAllUsers();
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            textClear = value.isEmpty ? false : true;
                          });
                        },
                        controller: _searchUserController,
                        focusNode: _searchFocusNode,
                        maxLines: 1,
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                if (_searchUserController!.text.isNotEmpty &&
                                    _searchUserController != null) {
                                  setState(() {
                                    _searchUserController!.clear();
                                    page = 1;
                                    usersList = [];
                                    textClear = false;
                                  });
                                  getAllUsers();
                                }
                              },
                              child: const Icon(Icons.clear, color: black)),
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: white,
                          hintText: translation(context).searchUser,
                          hintStyle: TextStyle(
                              color: lightTextColor.withValues(alpha: .5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(width: 1.w)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                  color: greyBorderColor.withValues(alpha: .2),
                                  width: 1.w)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                  color: greyBorderColor, width: 1.w)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                        ),
                        style: const TextStyle(color: lightTextColor),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<UserBloc, UserState>(
                          bloc: userBloc,
                          builder: (context, state) {
                            if (state is GetAllUsersLoading) {
                              return const Loading();
                            } else {
                              return Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: usersList!.length,
                                      itemBuilder: (context, index) {
                                        String? userName =
                                            usersList![index].userName!;
                                        Color avatarColor =
                                            getAvatarColor(index);
                                        return ListTile(
                                            leading: CircleAvatar(
                                                backgroundColor: avatarColor,
                                                child: Text(
                                                    getInitials(userName),
                                                    style: const TextStyle(
                                                        color: white))),
                                            title: Text(userName),
                                            onTap: () {
                                              setState(() {
                                                _taskAssignToController!.text =
                                                    userName;
                                                assignedUserId =
                                                    usersList![index].id;
                                                _searchUserController!.clear();
                                              });
                                              Navigator.pop(context);
                                            });
                                      }));
                            }
                          }),
                    ])),
          );
        });
  }

  Widget taskProjectTextBox() {
    return TextFormField(
        controller: _taskProjectController,
        readOnly: true,
        decoration: InputDecoration(
            filled: true,
            fillColor: white,
            prefixIcon: const Icon(Icons.work_history_rounded),
            hintText: translation(context).projects,
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
        style: const TextStyle(color: lightTextColor),
        onTap: () {
          getAllProjects();
          _showProjectBottomSheet();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translation(context).pleaseSelectProject;
          }
          return null;
        });
  }

  void _showProjectBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: 400,
                color: white,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                          child: Text(translation(context).projects,
                              style: const TextStyle(fontSize: 18))),
                      const SizedBox(height: 10),
                      Text(translation(context).projectList,
                          style: const TextStyle(
                              fontSize: 12, color: greyTextColor),
                          textAlign: TextAlign.left),
                      const SizedBox(height: 10),
                      TextFormField(
                          enabled: true,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onEditingComplete: () {
                            if (_searchProjectController!.text.isNotEmpty &&
                                _searchProjectController != null) {
                              page = 1;
                              getAllProjects();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              textClear = value.isEmpty ? false : true;
                            });
                          },
                          controller: _searchProjectController,
                          focusNode: _searchFocusNode,
                          maxLines: 1,
                          enableSuggestions: false,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    if (_searchProjectController!
                                            .text.isNotEmpty &&
                                        _searchProjectController != null) {
                                      setState(() {
                                        _searchProjectController!.clear();
                                        page = 1;
                                        projectList = [];
                                        textClear = false;
                                      });
                                      getAllProjects();
                                    }
                                  },
                                  child: const Icon(Icons.clear, color: black)),
                              prefixIcon: const Icon(Icons.search_rounded),
                              filled: true,
                              fillColor: white,
                              hintText: translation(context).searchProject,
                              hintStyle: TextStyle(
                                  color: lightTextColor.withValues(alpha: .5)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(width: 1.w)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(
                                      color:
                                          greyBorderColor.withValues(alpha: .2),
                                      width: 1.w)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(
                                      color: greyBorderColor, width: 1.w)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w)),
                          style: const TextStyle(color: lightTextColor)),
                      const SizedBox(height: 10),
                      BlocBuilder<ProjectBloc, ProjectState>(
                          bloc: projectBloc,
                          builder: (context, state) {
                            if (state is GetAllProjectsLoading) {
                              return const Loading();
                            } else {
                              return Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: projectList!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String? projectName =
                                            projectList![index].projectName;
                                        return ListTile(
                                            leading: Container(
                                                width: 30.w,
                                                height: 25.h,
                                                decoration: BoxDecoration(
                                                  color: getAvatarColor(index),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    getInitials(projectName!),
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: white))),
                                            title: Text(projectName),
                                            onTap: () {
                                              setState(() {
                                                _taskProjectController!.text =
                                                    projectName;
                                                projectId = projectList![index]
                                                    .projectId;
                                                _searchProjectController!
                                                    .clear();
                                              });
                                              Navigator.pop(context);
                                            });
                                      }));
                            }
                          })
                    ])),
          );
        });
  }

  Widget _buildAddPOCImageField() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (task != null &&
                    task!.proofOfCompletionImages != null &&
                    task!.proofOfCompletionImages!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children:
                                task!.proofOfCompletionImages!.map((item) {
                              int index =
                                  task!.proofOfCompletionImages!.indexOf(item);
                              bool isPOCDeleted =
                                  removedMediaPotisions.contains(index);
                              return item.toString().contains('.mp4') ||
                                      item.toString().contains('.MOV')
                                  ? StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: _buildPOCChildWithRemoveIcon(
                                          VideoPlayerWidget(videoUrl: item),
                                          index,
                                          isPOCDeleted,
                                          item))
                                  : StaggeredGridTile.count(
                                      crossAxisCellCount: 1,
                                      mainAxisCellCount: 1,
                                      child: _buildPOCChildWithRemoveIcon(
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ZoomImage(
                                                                url: item)));
                                              },
                                              child: ThumbnailImage(
                                                  imageUrl: item,
                                                  userProfile: true)),
                                          index,
                                          isPOCDeleted,
                                          item));
                            }).toList())
                      ])),
                selectedPOCFiles != null && selectedPOCFiles!.isNotEmpty
                    ? Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: selectedPOCFiles!.map((item) {
                              int index = task != null
                                  ? (task!.proofOfCompletionImages!.length) +
                                      selectedPOCFiles!.indexOf(item)
                                  : selectedPOCFiles!.indexOf(item);
                              bool isPOCDeleted =
                                  removedMediaPotisions.contains(index);
                              return item.path.toString().contains('.mp4') ||
                                      item.path.toString().contains('.MOV')
                                  ? StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: _buildPOCChildWithRemoveIcon(
                                          VideoPlayerWidget(
                                            video: item,
                                          ),
                                          index,
                                          isPOCDeleted,
                                          item))
                                  : StaggeredGridTile.count(
                                      crossAxisCellCount: 1,
                                      mainAxisCellCount: 1,
                                      child: _buildPOCChildWithRemoveIcon(
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ZoomImage(
                                                                file: item)));
                                              },
                                              child: ThumbnailImage(
                                                  file: item,
                                                  userProfile: true)),
                                          index,
                                          isPOCDeleted,
                                          item));
                            }).toList())
                      ])
                    : const SizedBox()
              ]))
    ]);
  }

  Widget _buildPOCChildWithRemoveIcon(
      Widget child, int index, bool isPOCDeleted, item) {
    return Stack(children: [
      child,
      if (!isPOCDeleted)
        Align(
            alignment: Alignment.topRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        showAlertWithAction(
                            context: context,
                            title: translation(context).deleteFile,
                            content: translation(context).deleteThisFile,
                            onPress: () {
                              if (item is File) {
                                setState(() {
                                  selectedPOCFiles!.remove(item);
                                });
                              } else if (!isPOCDeleted) {
                                setState(() {
                                  removedMediaPotisions.add(index);
                                });
                              }
                            });
                      },
                      child: CircleAvatar(
                          backgroundColor: redIconColor,
                          radius: 12.r,
                          child: Icon(Icons.delete, size: 16.h, color: white)))
                ])),
      if (isPOCDeleted)
        Align(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.all(8),
                color: white.withValues(alpha: 0.5),
                child: Text(translation(context).deleted,
                    style: const TextStyle(
                        color: redIconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700))))
    ]);
  }

  Widget _buildChildWithRemoveIcon(
      Widget child, int index, bool isDeleted, item) {
    return Stack(children: [
      child,
      if (!isDeleted)
        Align(
            alignment: Alignment.topRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        showAlertWithAction(
                            context: context,
                            title: translation(context).deleteFile,
                            content: translation(context).deleteThisFile,
                            onPress: () {
                              if (item is File) {
                                setState(() {
                                  selectedFiles!.remove(item);
                                });
                              } else if (!isDeleted) {
                                setState(() {
                                  removedExistingImagePotision.add(index);
                                });
                              }
                            });
                      },
                      child: CircleAvatar(
                          backgroundColor: redIconColor,
                          radius: 12.r,
                          child: Icon(Icons.delete, size: 16.h, color: white)))
                ])),
      if (isDeleted)
        Align(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.all(8),
                color: white.withValues(alpha: 0.5),
                child: Text(translation(context).deleted,
                    style: const TextStyle(
                        color: redIconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700))))
    ]);
  }

  Widget updateTaskButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
            height: 44.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(30.r)),
            child: Center(
                child: Text(translation(context).updateTask,
                    style: TextStyle(
                        color: white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500)))));
  }

  Widget _buildSubTaskWidget() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _subTaskController!.length,
        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
        itemBuilder: (context, index) => updatedSubTasks!.isEmpty
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: TextFormField(
                          readOnly: true,
                          onTap: () async {
                            Object? result = await Navigator.pushNamed(
                                context, PageName.updateSubTaskScreen,
                                arguments: updatedSubTasks![index]);
                            if (result != null) {
                              setState(() {
                                List<Object?> resultList =
                                    result as List<Object?>;
                                SubTasks subTaskDetail =
                                    resultList[0] as SubTasks;
                                removedSubtaskMediaPositions =
                                    resultList[1] as List<int>;
                                removedSubtaskDocumentPositions =
                                    resultList[2] as List<int>;
                                updatedSubTasks![index] = subTaskDetail;
                                _subTaskController![index].text =
                                    subTaskDetail.subTaskName!;
                              });
                            }
                          },
                          onChanged: (value) {
                            updatedSubTasks![index].subTaskName = value;
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: _subTaskController![index],
                          maxLines: null,
                          decoration: InputDecoration(
                              prefixIcon: Checkbox(
                                  activeColor: primaryColor,
                                  value: updatedSubTasks![index].isCompleted,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      updatedSubTasks![index].isCompleted =
                                          value ?? false;
                                    });
                                  }),
                              filled: true,
                              fillColor: white,
                              hintText: translation(context).taskName,
                              hintStyle: TextStyle(
                                  color: lightTextColor.withValues(alpha: .5)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(width: 1.w)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(
                                      color:
                                          greyBorderColor.withValues(alpha: .2),
                                      width: 1.w)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(
                                      color: greyBorderColor, width: 1.w)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w)),
                          style: const TextStyle(color: lightTextColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translation(context)
                                  .pleaseEnterSubTaskName;
                            }
                            return null;
                          })),
                  SizedBox(width: 5.w),
                  InkWell(
                      onTap: () {
                        showAlertWithAction(
                            context: context,
                            title: translation(context).deleteSubtask,
                            content: translation(context).deleteThisSubtask,
                            onPress: () {
                              setState(() {
                                _subTaskController![index].clear();
                                _subTaskController![index].dispose();
                                _subTaskController!.removeAt(index);
                                updatedSubTasks!.removeAt(index);
                              });
                            });
                      },
                      child: const Icon(Icons.delete_forever_rounded,
                          color: redIconColor))
                ])));
  }

  Widget _buildAddAttachmentField() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (task != null &&
                    task!.documents != null &&
                    task!.documents!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: task!.documents!.map((item) {
                              int index = task!.documents!.indexOf(item);
                              bool isDeleted =
                                  removedExistingImagePotision.contains(index);
                              return item.toString().contains('.mp4') ||
                                      item.toString().contains('.MOV')
                                  ? StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: _buildChildWithRemoveIcon(
                                          VideoPlayerWidget(videoUrl: item),
                                          index,
                                          isDeleted,
                                          item))
                                  : (item.toString().contains('.pdf') ||
                                          item.toString().contains('.txt'))
                                      ? StaggeredGridTile.count(
                                          crossAxisCellCount: 1,
                                          mainAxisCellCount: 1,
                                          child: _buildChildWithRemoveIcon(
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    item
                                                            .toString()
                                                            .contains('.pdf')
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              launchURL(item);
                                                            },
                                                            child: Image.asset(
                                                              'assets/images/pdf_file_image.png',
                                                              fit: BoxFit.fill,
                                                              height: 90,
                                                            ),
                                                          )
                                                        : item
                                                                .toString()
                                                                .contains(
                                                                    '.txt')
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  launchURL(
                                                                      item);
                                                                },
                                                                child: Image.asset(
                                                                    'assets/images/text_file_image.png',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: 90))
                                                            : ThumbnailImage(
                                                                imageUrl:
                                                                    '$item',
                                                                userProfile:
                                                                    false)
                                                  ]),
                                              index,
                                              isDeleted,
                                              item))
                                      : StaggeredGridTile.count(
                                          crossAxisCellCount: 1,
                                          mainAxisCellCount: 1,
                                          child: _buildChildWithRemoveIcon(
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ZoomImage(
                                                                    url:
                                                                        item)));
                                                  },
                                                  child: ThumbnailImage(
                                                      imageUrl: item,
                                                      userProfile: true)),
                                              index,
                                              isDeleted,
                                              item));
                            }).toList())
                      ])),
                selectedFiles != null && selectedFiles!.isNotEmpty
                    ? Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: selectedFiles!.map((item) {
                              int index = task != null
                                  ? (task!.documents!.length) +
                                      selectedFiles!.indexOf(item)
                                  : selectedFiles!.indexOf(item);
                              bool isDeleted =
                                  removedExistingImagePotision.contains(index);
                              String fileExtension =
                                  item.path.split('.').last.toLowerCase();
                              if (fileExtension == 'pdf' ||
                                  fileExtension == 'txt') {
                                return StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 1,
                                  child: _buildChildWithRemoveIcon(
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          item.toString().contains('.pdf')
                                              ? Image.asset(
                                                  'assets/images/pdf_file_image.png',
                                                )
                                              : item.toString().contains('.txt')
                                                  ? Image.asset(
                                                      'assets/images/text_file_image.png',
                                                    )
                                                  : ThumbnailImage(
                                                      imageUrl: '$item',
                                                      userProfile: false)
                                        ],
                                      ),
                                      index,
                                      isDeleted,
                                      item),
                                );
                              } else if (item.path
                                      .toString()
                                      .contains('.mp4') ||
                                  item.path.toString().contains('.MOV')) {
                                return StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 1,
                                    child: _buildChildWithRemoveIcon(
                                        VideoPlayerWidget(video: item),
                                        index,
                                        isDeleted,
                                        item));
                              } else {
                                return StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: _buildChildWithRemoveIcon(
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ZoomImage(
                                                              file: item)));
                                            },
                                            child: ThumbnailImage(
                                                file: item, userProfile: true)),
                                        index,
                                        isDeleted,
                                        item));
                              }
                            }).toList())
                      ])
                    : const SizedBox(),
                Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                isPOCFiles = false;
                                getImageFromGallery(isPOCFiles!);
                              },
                              child: const Icon(Icons.image_outlined,
                                  color: black)),
                          SizedBox(width: 10.w),
                          InkWell(
                              onTap: () {
                                isPOCFiles = false;
                                getImageFromCamera(isPOCFiles!);
                              },
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: black)),
                          SizedBox(width: 10.w),
                          InkWell(
                              onTap: () {
                                getVideoFile();
                              },
                              child: const Icon(
                                  Icons.video_camera_back_outlined,
                                  color: black)),
                          SizedBox(width: 10.w),
                          InkWell(
                              onTap: () {
                                getAttachmentFromGallery(context);
                              },
                              child:
                                  const Icon(Icons.attach_file, color: black))
                        ]))
              ]))
    ]);
  }
}
