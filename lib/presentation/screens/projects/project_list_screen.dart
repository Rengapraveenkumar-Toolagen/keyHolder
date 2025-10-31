import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/bloc.dart';
import '../../../data/classes/language_constant.dart';
import '../../../data/model/member.dart';
import '../../../data/model/project_details.dart';
import '../../../data/model/task_details.dart';
import '../../../utils/utils.dart';
import '../../routes/pages_name.dart';
import '../../widgets/widgets.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  TextEditingController? projectTitleController, _searchController;
  FocusNode? projectTitleFocusNode, _searchFocusNode;
  ScrollController? scrollController;
  bool isTaskVisible = false, isLastProject = false, textClear = false;
  ProjectBloc? projectBloc;
  int page = 1, limit = 12;
  List<ProjectDetails>? projectList;
  String? projectTaskList;
  String? userId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    projectBloc = BlocProvider.of<ProjectBloc>(context);
    projectTitleController = TextEditingController();
    _searchController = TextEditingController();
    projectTitleFocusNode = FocusNode();
    scrollController = ScrollController();
    _searchFocusNode = FocusNode();
    netWorkStatusCheck();
    scrollController!.addListener(loadMore);
    userId = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  void dispose() {
    projectTitleController!.dispose();
    projectTitleFocusNode!.dispose();
    super.dispose();
  }

  netWorkStatusCheck() async {
    await connectivityCheck().then((internet) {
      if (!internet && mounted) {
        showModal(context, () {
          getAllProjects();
        });
      } else {
        getAllProjects();
      }
    });
  }

  getAllProjects() {
    projectBloc!.add(GetAllProjects(page, limit, _searchController!.text));
  }

  loadMore() {
    double maxScroll = scrollController!.position.maxScrollExtent;
    double offset = scrollController!.offset;
    bool outOfRange = scrollController!.position.outOfRange;
    if (offset >= maxScroll && !outOfRange && !isLastProject) {
      page = page + 1;
      getAllProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: bgColor,
      body: BlocListener<ProjectBloc, ProjectState>(
          bloc: projectBloc,
          listener: (context, state) {
            if (state is GetAllProjectsSuccess) {
              if (page == 1) {
                isLastProject = state.projectDetails.isEmpty;
                projectList = state.projectDetails;
              } else {
                isLastProject = state.projectDetails.isEmpty;
                projectList!.addAll(state.projectDetails);
              }
            } else if (state is GetAllProjectsFailed) {
              showAlertSnackBar(context, state.errorMessage, AlertType.error);
            } else if (state is CreateProjectSuccess) {
              Navigator.pop(context);
              getAllProjects();
              showAlertSnackBar(
                  context,
                  translation(context).projectCreatedSuccessfully,
                  AlertType.success);
            } else if (state is CreateProjectFailed) {
              showAlertSnackBar(context, state.errorMessage, AlertType.error);
            }
          },
          child: BlocBuilder<ProjectBloc, ProjectState>(
              bloc: projectBloc,
              builder: (context, state) {
                if (state is GetAllProjectsLoading ||
                    state is CreateProjectLoading) {
                  return const Loading();
                } else {
                  return RefreshIndicator(
                    backgroundColor: bgColor,
                    color: primaryColor,
                    onRefresh: () {
                      page = 1;
                      getAllProjects();
                      return Future.value();
                    },
                    child: _buildBody(),
                  );
                }
              })),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: bgColor,
      leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 3.h),
              child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: lightGreyColor,
                  child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: const Icon(Icons.arrow_back_ios,
                          color: greyIconColor))))),
      centerTitle: true,
      title: Text(translation(context).projects,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp)),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 2.h),
          child: _buildSearchTextField(),
        ),
        (projectList != null && projectList!.isNotEmpty)
            ? Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 8.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: !isLastProject
                                    ? projectList!.length + 1
                                    : projectList!.length,
                                itemBuilder: (context, index) {
                                  if (index == projectList!.length) {
                                    return isLastProject ||
                                            projectList!.length < limit
                                        ? const SizedBox()
                                        : Center(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.h),
                                              height: 40,
                                              width: 40,
                                              child: const Loading(),
                                            ),
                                          );
                                  } else {
                                    return InkWell(
                                        onTap: () async {
                                          final projectDetails =
                                              projectList![index];
                                          Navigator.of(context).pushNamed(
                                              PageName.projectTaskListScreen,
                                              arguments: {
                                                'isProjectTask': true,
                                                'project': projectDetails
                                              });
                                        },
                                        child: buildProjectList(
                                            projectList![index].projectName!,
                                            projectList![index].tasks!,
                                            projectList![index].projectId!,
                                            index,
                                            projectList![index]
                                                .projectMembers!));
                                  }
                                })
                          ])),
                ),
              )
            : Expanded(
                child: Center(
                    child: Text(translation(context).noProjectsAvailabe,
                        style:
                            TextStyle(fontSize: 16.sp, color: greyTextColor))),
              ),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return TextFormField(
        enabled: true,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onEditingComplete: () {
          if (_searchController!.text.isNotEmpty && _searchController != null) {
            page = 1;
            getAllProjects();
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
                        getAllProjects();
                      }
                    },
                    child: const Icon(Icons.clear, color: black))
                : const SizedBox(),
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: white,
            hintText: translation(context).searchProject,
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

  Widget buildProjectList(String projectName, List<TaskDetails> tasks,
      String projectId, index, List<Member> membersList) {
    List<String>? users = [];
    for (int i = 0; i < membersList.length; i++) {
      users.add(membersList[i].userName!);
    }
    return Column(children: [
      Card(
          color: white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      right: 5.w, left: 5.w, top: 4.h, bottom: 4.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Container(
                              width: 40.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                  color: getAvatarColor(index),
                                  borderRadius: BorderRadius.circular(3.r)),
                              alignment: Alignment.center,
                              child: Text(getInitials(projectName),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: white,
                                      fontWeight: FontWeight.w600))),
                          SizedBox(width: 10.w),
                          if (membersList
                              .any((member) => member.userId == userId))
                            GestureDetector(
                              onTap: () async {
                                var result = await Navigator.of(context)
                                    .pushNamed(PageName.projectDetailScreen,
                                        arguments: projectList![index]);
                                if (context.mounted) {
                                  if (result == true) {
                                    getAllProjects();
                                  }
                                }
                              },
                              child: const Icon(Icons.edit,
                                  size: 20, color: black),
                            ),
                          SizedBox(width: 5.w),
                          Text(projectName,
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'Poppins'))
                        ]),
                        Row(children: [
                          membersList.isNotEmpty && users.isNotEmpty
                              ? userAvatarListWidget(users)
                              : const SizedBox(),
                          SizedBox(width: 5.w),
                          (tasks.isNotEmpty)
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(25.r),
                                  onTap: () {
                                    setState(() {
                                      projectTaskList =
                                          projectTaskList == projectName
                                              ? ''
                                              : projectName;
                                    });
                                  },
                                  child: Icon(
                                      projectTaskList == projectName
                                          ? Icons.arrow_drop_up_outlined
                                          : Icons.arrow_drop_down_outlined,
                                      size: 30))
                              : const SizedBox()
                        ])
                      ])),
              if (projectTaskList == projectName)
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () async {
                            var result = await Navigator.of(context).pushNamed(
                                PageName.updateTaskScreen,
                                arguments: tasks[index].taskId);
                            if (context.mounted) {
                              if (result == true) {
                                getAllProjects();
                              }
                            }
                          },
                          child: Row(children: [
                            Checkbox(
                                visualDensity: VisualDensity.compact,
                                activeColor: primaryColor,
                                value: tasks[index].isCompleted,
                                onChanged: (bool? value) {
                                  // setState(() {
                                  //   tasks[index].isCompleted = value ?? false;
                                  // });
                                }),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w, right: 5.w, bottom: 5.h),
                                child: Text(tasks[index].taskName!,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        decoration: tasks[index].isCompleted!
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none)),
                              ),
                            )
                          ]));
                    })
            ],
          )),
    ]);
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
        height: 80,
        color: bgColor,
        child: Padding(
            padding:
                EdgeInsets.only(left: 10.h, right: 10.h, top: 5.h, bottom: 5.h),
            child: _buildCreateProjectButton()));
  }

  Widget _buildCreateProjectButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: Size.fromHeight(40.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r))),
        onPressed: () {
          _showCreateProjectForm();
        },
        child: Text(translation(context).createProject,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500)));
  }

  void _showCreateProjectForm() {
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
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(translation(context).createProject,
                                  style: const TextStyle(fontSize: 18))),
                          const SizedBox(height: 10.0),
                          TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: projectTitleController,
                              cursorColor: lightTextColor,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: lightTextColor,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                      borderSide: BorderSide(width: 2.w)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                      borderSide: BorderSide(
                                          color: greyBorderColor.withValues(
                                              alpha: .2),
                                          width: 2.w)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                      borderSide: BorderSide(
                                          color: greyBorderColor, width: 2.w)),
                                  filled: true,
                                  fillColor: white,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  hintText: translation(context).projectName,
                                  hintStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color:
                                          lightTextColor.withValues(alpha: .5),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return translation(context)
                                      .pleaseEnterProjectName;
                                }
                                return null;
                              }),
                          const SizedBox(height: 10.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        projectBloc!.add(CreateProject(
                                            projectTitleController!.text.trim(),
                                            userId!));
                                      }
                                      projectTitleController!.clear();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor),
                                    child: Text(translation(context).create,
                                        style: const TextStyle(color: white)))
                              ])
                        ]))),
          );
        });
  }
}
