import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../data/classes/language_constant.dart';
import '../../../data/model/owner_detail.dart';
import '../../../data/model/subtask.dart';
import '../../../data/model/user_detail.dart';
import '../../../utils/colors/colors.dart';
import '../../widgets/widgets.dart';

class UpdateSubtaskScreen extends StatefulWidget {
  final SubTasks? subtasks;
  const UpdateSubtaskScreen({super.key, required this.subtasks});

  @override
  State<UpdateSubtaskScreen> createState() => _UpdateSubtaskScreenState();
}

class _UpdateSubtaskScreenState extends State<UpdateSubtaskScreen> {
  UserBloc? userBloc;
  int page = 1, limit = 10;
  bool isLastUser = false;
  List<UserDetail>? usersList = [];
  List<int> removedSubtaskMediaPositions = [];
  List<int> removedSubtaskDocumentPositions = [];
  List<File>? selectedSubTaskPOCFiles = [];
  List<File>? selectedSubtaskDocumentFiles = [];
  final ImagePicker imagePicker = ImagePicker();
  Owner? createdUser;
  String? subTaskId,
      subTaskName,
      subTaskDesc,
      userId,
      assignedUserId,
      assignedUserName;
  bool? isCompleted = false, textClear = false, isProofOfCompletion, isPOCFiles;

  TextEditingController? _taskNameController,
      _taskDescriptionController,
      _taskAssignToController,
      _searchUserController;

  FocusNode? _taskNameFocusNode, _taskDescriptionFocusNode, _searchFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SubTasks? subTasks;

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _taskAssignToController = TextEditingController();
    _searchUserController = TextEditingController();
    _taskNameFocusNode = FocusNode();
    _taskDescriptionFocusNode = FocusNode();
    _searchFocusNode = FocusNode();
    userId = FirebaseAuth.instance.currentUser!.uid;
    subTasks = widget.subtasks;
    if (subTasks != null) {
      subTaskId = subTasks!.subTaskId;
      _taskNameController!.text = subTaskName = subTasks!.subTaskName ?? '';
      _taskDescriptionController!.text =
          subTaskDesc = subTasks!.subTaskDescription ?? '';
      isCompleted = subTasks!.isCompleted;
      isProofOfCompletion = subTasks!.subTaskProofOfCompletion;
      if (subTasks!.subTaskOwner != null) {
        assignedUserId = subTasks!.subTaskOwner!.userId;
        _taskAssignToController!.text =
            assignedUserName = subTasks!.subTaskOwner!.userName ?? '';
      }
      if (subTasks!.subTaskCreator != null) {
        createdUser = subTasks!.subTaskCreator;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController!.dispose();
    _taskAssignToController!.dispose();
    _taskNameFocusNode!.dispose();
    super.dispose();
  }

  getAllUsers() {
    userBloc!.add(GetAllUsers(_searchUserController!.text, limit, page));
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
              ? selectedSubTaskPOCFiles!.add(File(croppedFile.path))
              : selectedSubtaskDocumentFiles!.add(File(croppedFile.path));
        });
      }
    });
  }

  Future<void> getVideoFromCamera() async {
    final pickedVideo = await imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedVideo != null) {
      setState(() {
        selectedSubTaskPOCFiles!.add(File(pickedVideo.path));
      });
    }
  }

  Future getVideoFile() async {
    final pickedFile = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedSubtaskDocumentFiles!.add(File(pickedFile.path));
      });
    }
  }

  Future getImageFromGallery(bool isPOCFiles) async {
    final pickedImage = await imagePicker.pickMultiImage();
    setState(() {
      if (pickedImage.isNotEmpty) {
        selectedSubtaskDocumentFiles!
            .addAll(pickedImage.map((image) => File(image.path)));
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
          selectedSubtaskDocumentFiles!
              .add(File(pickedFiles.files.single.path!));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == "read_external_storage_denied") {
        showAlertSnackBar(
            context, translation(context).appSettingConfirm, AlertType.info);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Text(translation(context).updateSubtask),
        ),
        body: BlocListener<UserBloc, UserState>(
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
                showAlertSnackBar(context, state.errorMessage, AlertType.error);
              }
            },
            child: SingleChildScrollView(child: _buildBody())));
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
              taskDescriptionTextBox(),
              SizedBox(height: 10.h),
              taskAssignToTextBox(),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: buildHeading(translation(context).addFile),
              ),
              _buildAddAttachmentField(),
              Padding(
                padding: (createdUser!.userId == userId)
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: 10.w, right: 10.w),
                child: Row(children: [
                  (createdUser!.userId == userId)
                      ? Checkbox(
                          activeColor: primaryColor,
                          value: isProofOfCompletion,
                          onChanged: (bool? value) {
                            setState(() {
                              isProofOfCompletion = value ?? false;
                            });
                          })
                      : const SizedBox(),
                  buildHeading('${translation(context).proofOfCompletion}*'),
                ]),
              ),
              isProofOfCompletion!
                  ? Column(children: [
                      _buildAddImageField(),
                      Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Row(children: [
                            InkWell(
                                onTap: () {
                                  isPOCFiles = true;
                                  getImageFromCamera(isPOCFiles!);
                                },
                                child: const Icon(Icons.camera_alt_rounded)),
                            SizedBox(width: 5.w),
                            InkWell(
                                onTap: () {
                                  getVideoFromCamera();
                                },
                                child: const Icon(Icons.video_camera_back)),
                            SizedBox(width: 5.w)
                          ]))
                    ])
                  : const SizedBox(),
              SizedBox(height: 10.h),
              InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedSubTaskPOCFiles!.isEmpty &&
                          createdUser!.userId != userId &&
                          subTasks!.subTaskProofOfCompletionImage!.isEmpty) {
                        showAlertSnackBar(
                            context,
                            translation(context).attachProofofcompletion,
                            AlertType.info);
                      } else if (isCompleted != subTasks!.isCompleted ||
                          subTaskName != _taskNameController!.text ||
                          subTaskDesc != _taskDescriptionController!.text ||
                          assignedUserName != _taskAssignToController!.text ||
                          assignedUserId != subTasks!.subTaskOwner!.userId ||
                          isProofOfCompletion !=
                              subTasks!.subTaskProofOfCompletion ||
                          selectedSubTaskPOCFiles!.isNotEmpty ||
                          selectedSubtaskDocumentFiles!.isNotEmpty ||
                          removedSubtaskMediaPositions.isNotEmpty ||
                          removedSubtaskDocumentPositions.isNotEmpty) {
                        SubTasks subTasks = SubTasks(
                            subTaskId,
                            _taskNameController!.text.trim(),
                            _taskDescriptionController!.text.trim(),
                            Owner(
                                userId: assignedUserId,
                                userName: assignedUserName),
                            createdUser,
                            isCompleted,
                            isProofOfCompletion,
                            selectedSubTaskPOCFiles,
                            selectedSubtaskDocumentFiles);
                        Navigator.pop(context, [
                          subTasks,
                          removedSubtaskMediaPositions,
                          removedSubtaskDocumentPositions
                        ]);
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
          hintText: translation(context).subtaskName,
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
            return translation(context).pleaseEnterSubTaskName;
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
            hintText: translation(context).subtaskDescription,
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
            return translation(context).enterSubtaskDescription;
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
                          suffixIcon: textClear!
                              ? GestureDetector(
                                  onTap: () {
                                    if (_searchUserController!
                                            .text.isNotEmpty &&
                                        _searchUserController != null) {
                                      setState(() {
                                        _searchUserController!.clear();
                                        page = 1;
                                        usersList = [];
                                        textClear = false;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.clear, color: black))
                              : const SizedBox(),
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
                                                assignedUserName = userName;
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

  Widget _buildAddImageField() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (subTasks != null &&
                    subTasks!.subTaskProofOfCompletionImage != null &&
                    subTasks!.subTaskProofOfCompletionImage!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: subTasks!.subTaskProofOfCompletionImage!
                                .map((item) {
                              int index = subTasks!
                                  .subTaskProofOfCompletionImage!
                                  .indexOf(item);
                              bool isDeleted =
                                  removedSubtaskMediaPositions.contains(index);
                              return item.toString().contains('.mp4') ||
                                      item.toString().contains('.MOV')
                                  ? StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: _buildPOCChildWithRemoveIcon(
                                          VideoPlayerWidget(videoUrl: item),
                                          index,
                                          isDeleted,
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
                                          isDeleted,
                                          item));
                            }).toList())
                      ])),
                selectedSubTaskPOCFiles != null &&
                        selectedSubTaskPOCFiles!.isNotEmpty
                    ? Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: selectedSubTaskPOCFiles!.map((item) {
                              int index = subTasks != null
                                  ? (subTasks!.subTaskProofOfCompletionImage!
                                          .length) +
                                      selectedSubTaskPOCFiles!.indexOf(item)
                                  : selectedSubTaskPOCFiles!.indexOf(item);
                              bool isDeleted =
                                  removedSubtaskMediaPositions.contains(index);
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
                                          isDeleted,
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
                                          isDeleted,
                                          item));
                            }).toList())
                      ])
                    : const SizedBox()
              ]))
    ]);
  }

  Widget _buildPOCChildWithRemoveIcon(
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
                                  selectedSubTaskPOCFiles!.remove(item);
                                });
                              } else if (!isDeleted) {
                                setState(() {
                                  removedSubtaskMediaPositions.add(index);
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
                                  selectedSubtaskDocumentFiles!.remove(item);
                                });
                              } else if (!isDeleted) {
                                setState(() {
                                  removedSubtaskDocumentPositions.add(index);
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

  Widget _buildAddAttachmentField() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (subTasks != null &&
                    subTasks!.subTaskDocuments != null &&
                    subTasks!.subTaskDocuments!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: subTasks!.subTaskDocuments!.map((item) {
                              int index =
                                  subTasks!.subTaskDocuments!.indexOf(item);
                              bool isDeleted = removedSubtaskDocumentPositions
                                  .contains(index);
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
                selectedSubtaskDocumentFiles != null &&
                        selectedSubtaskDocumentFiles!.isNotEmpty
                    ? Column(children: [
                        StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: selectedSubtaskDocumentFiles!.map((item) {
                              int index = subTasks != null
                                  ? (subTasks!.subTaskDocuments!.length) +
                                      selectedSubtaskDocumentFiles!
                                          .indexOf(item)
                                  : selectedSubtaskDocumentFiles!.indexOf(item);
                              bool isDeleted = removedSubtaskDocumentPositions
                                  .contains(index);
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
                              child: const Icon(
                                Icons.image_outlined,
                                color: black,
                              )),
                          SizedBox(width: 10.w),
                          InkWell(
                              onTap: () {
                                isPOCFiles = false;

                                getImageFromCamera(isPOCFiles!);
                              },
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: black,
                              )),
                          SizedBox(width: 10.w),
                          InkWell(
                              onTap: () {
                                getVideoFile();
                              },
                              child: const Icon(
                                Icons.video_camera_back_outlined,
                                color: black,
                              )),
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

  Widget buildHeading(title) {
    return Text(title,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: greyTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500));
  }
}
