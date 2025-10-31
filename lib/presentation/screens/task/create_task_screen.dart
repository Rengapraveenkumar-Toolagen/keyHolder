import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../data/classes/language_constant.dart';
import '../../../utils/colors/colors.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController? tasknameController,
      descController,
      startDateController,
      endDateController;
  FocusNode? tasknameFocusNode, descFocusNode;
  ScrollController? scrollController;
  String? currentDate;
  bool? isCategorySelected = false, isTaskPrioritySelected = false;

  List<Map<String, dynamic>> taskPriority = [
    {'name': 'High', 'color': Colors.red, 'isSelected': true},
    {'name': 'Medium', 'color': yellowStatusColor, 'isSelected': false},
    {'name': 'Low', 'color': blueButtonColor, 'isSelected': false}
  ];

  List<Map<String, dynamic>> category = [
    {'name': 'Marketing', 'isSelected': true},
    {'name': 'Development', 'isSelected': false},
    {'name': 'Mobile App', 'isSelected': false},
    {'name': 'HTML', 'isSelected': false},
    {'name': 'Android App', 'isSelected': false},
    {'name': 'SEO', 'isSelected': false},
    {'name': 'iOS App', 'isSelected': true},
    {'name': 'Web Design', 'isSelected': false},
    {'name': 'App Design', 'isSelected': false},
    {'name': 'iOS App', 'isSelected': false},
    {'name': 'Web Design', 'isSelected': false},
  ];

  List<Map<String, dynamic>> memberList = [
    {'name': 'Add', 'data': 'Member', 'isSelected': false},
    {
      'name': 'You',
      'data': 'iOS Developer',
      'image': 'assets/images/sample_image_2.png',
      'isSelected': true
    },
    {
      'name': 'Anna',
      'data': 'Manager',
      'image': 'assets/images/sample_men.png',
      'isSelected': false
    },
    {
      'name': 'John',
      'data': 'CEO',
      'image': 'assets/images/sample_men.png',
      'isSelected': false
    },
    {
      'name': 'Tina',
      'data': 'Tester',
      'image': 'assets/images/sample_image_2.png',
      'isSelected': false
    },
    {
      'name': 'Robert',
      'data': 'Android Developer',
      'image': 'assets/images/sample_men.png',
      'isSelected': false
    },
    {
      'name': 'Shaun',
      'data': 'Dotnet Developer',
      'image': 'assets/images/sample_men.png',
      'isSelected': false
    },
    {
      'name': 'Monica',
      'data': 'iOS Developer',
      'image': 'assets/images/sample_image_2.png',
      'isSelected': true
    },
  ];

  @override
  void initState() {
    tasknameController = TextEditingController();
    descController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    scrollController = ScrollController();

    tasknameFocusNode = FocusNode();
    descFocusNode = FocusNode();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM y').format(now);
    startDateController!.text = formattedDate;
    endDateController!.text = formattedDate;
    super.initState();
  }

  @override
  void dispose() {
    tasknameController!.dispose();
    descController!.dispose();
    startDateController!.dispose();
    endDateController!.dispose();
    scrollController!.dispose();

    tasknameFocusNode!.dispose();
    descFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: bgColor,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 3),
                    child: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: lightGreyColor,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: const Icon(Icons.arrow_back_ios,
                                color: greyIconColor))))),
            title: Center(
                child: Text(translation(context).createTask,
                    style: const TextStyle(fontWeight: FontWeight.w500))),
            actions: [
              GestureDetector(
                  onTap: () {},
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 2.0, right: 15, bottom: 3),
                      child: CircleAvatar(
                          radius: 25.r,
                          backgroundColor: lightGreyColor,
                          child: const Icon(Icons.notifications_none,
                              color: greyBorderColor))))
            ]),
        backgroundColor: bgColor,
        body: SingleChildScrollView(child: _buildBody()));
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeading(translation(context).taskname),
          SizedBox(height: 10.h),
          taskNameTextBox(),
          SizedBox(height: 10.h),
          _buildHeading(translation(context).description),
          SizedBox(height: 10.h),
          descriptionTextBox(),
          SizedBox(height: 10.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
                onTap: () async {
                  DateTime? startPickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (startPickedDate != null) {
                    String formattedDate =
                        DateFormat('d MMM y').format(startPickedDate);
                    setState(() {
                      startDateController!.text = formattedDate;
                    });
                  }
                },
                child: _buildStartDateText(translation(context).startDate)),
            SizedBox(width: 5.w),
            InkWell(
                onTap: () async {
                  DateTime? endPickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (endPickedDate != null) {
                    String formattedDate =
                        DateFormat('d MMM y').format(endPickedDate);
                    setState(() {
                      endDateController!.text = formattedDate;
                    });
                  }
                },
                child: _buildEndDateText(translation(context).endDate))
          ]),
          SizedBox(height: 10.h),
          _buildHeading(translation(context).taskPriority),
          SizedBox(height: 5.h),
          _buildTaskPriority(),
          SizedBox(height: 5.h),
          _buildHeading(translation(context).category),
          SizedBox(height: 5.h),
          buildCategoryList(),
          SizedBox(height: 10.h),
          _buildHeading(translation(context).addTeamMembers),
          SizedBox(height: 5.h),
          _buildAddMemberList(),
          SizedBox(height: 10.h),
          createTaskButton(),
          SizedBox(height: 10.h)
        ]));
  }

  Widget taskNameTextBox() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r), color: greyFillColor),
        child: TextFormField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            focusNode: tasknameFocusNode,
            cursorColor: const Color.fromARGB(255, 94, 93, 93),
            controller: tasknameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                hintText: translation(context).taskname,
                hintStyle: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    color: black,
                    fontWeight: FontWeight.w500),
                enabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5))),
            validator: (value) {
              String title = value!.trim();
              if (title.isEmpty) {
                return translation(context).pleaseEnterTaskName;
              }
              return null;
            }));
  }

  Widget descriptionTextBox() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r), color: greyFillColor),
        child: TextFormField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            focusNode: descFocusNode,
            cursorColor: const Color.fromARGB(255, 94, 93, 93),
            controller: descController,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                hintText: translation(context).description,
                hintStyle: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    color: black,
                    fontWeight: FontWeight.w500),
                enabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5))),
            validator: (value) {
              String title = value!.trim();
              if (title.isEmpty) {
                return translation(context).pleaseEnterDescription;
              }
              return null;
            }));
  }

  Widget _buildHeading(title) {
    return Text(title,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: greyTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500));
  }

  Widget _buildStartDateText(String title) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildHeading(title),
      SizedBox(height: 5.h),
      Container(
          decoration: BoxDecoration(
              color: greyFillColor, borderRadius: BorderRadius.circular(45)),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                CircleAvatar(
                    radius: 20.r,
                    backgroundColor: bgColor,
                    child: Image.asset('assets/images/calendar.png',
                        height: 25, width: 25)),
                SizedBox(width: 5.w),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: black),
                        controller: startDateController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        enabled: false))
              ])))
    ]);
  }

  Widget _buildEndDateText(String title) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildHeading(title),
      SizedBox(height: 5.h),
      Container(
          decoration: BoxDecoration(
              color: greyFillColor, borderRadius: BorderRadius.circular(45)),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                CircleAvatar(
                    radius: 20.r,
                    backgroundColor: bgColor,
                    child: Image.asset('assets/images/calendar.png',
                        height: 25, width: 25)),
                SizedBox(width: 5.w),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: black),
                        controller: endDateController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        enabled: false))
              ])))
    ]);
  }

  Widget _buildTaskPriority() {
    return SizedBox(
        height: 40.h,
        child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: taskPriority.length,
            itemBuilder: (context, index) {
              final taskButton = taskPriority[index];
              return _buildTaskPriorityButton(taskButton['name'],
                  taskButton['color'], taskButton['isSelected']);
            }));
  }

  Widget _buildTaskPriorityButton(String text, color, bool isSelected) {
    return Container(
        margin: const EdgeInsets.only(top: 8, right: 8),
        decoration: BoxDecoration(
            border: Border.all(color: white, width: 2.h),
            borderRadius: BorderRadius.circular(30),
            color: greyBoxColor),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(radius: 7.r, backgroundColor: color),
                  SizedBox(width: 6.w),
                  Text(text),
                  SizedBox(width: 15.w),
                  isSelected
                      ? const Icon(
                          size: 20, Icons.check_circle, color: primaryColor)
                      : const Icon(
                          size: 20,
                          Icons.check_circle_outline,
                          color: greyBorderColor)
                ])));
  }

  Widget buildCategoryList() {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: category.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3),
        itemBuilder: (context, index) {
          final categoryItem = category[index];
          return _buildCategoryButton(
              categoryItem['name'], categoryItem['isSelected']);
        });
  }

  Widget _buildCategoryButton(String categoryName, bool isSelected) {
    return InkWell(
        onTap: () {
          setState(() {
            isCategorySelected = !isCategorySelected!;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(color: transparent)
                    : Border.all(color: white, width: 2.h),
                borderRadius: BorderRadius.circular(30),
                color: isSelected ? primaryColor : greyBoxColor),
            child: Center(
                child: Text(categoryName,
                    style: TextStyle(color: isSelected ? white : black)))));
  }

  Widget _buildAddMemberList() {
    return SizedBox(
        height: 100.h,
        child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: memberList.length,
            itemBuilder: (context, index) {
              final member = memberList[index];
              if (index == 0) {
                return addMemberIcon(
                    member['name'], member['data'], member['isSelected']);
              }
              return _buildMemberList(member['name'], member['data'],
                  member['isSelected'], member['image']);
            }));
  }

  Widget addMemberIcon(String name, String data, bool isSelected) {
    return Padding(
        padding: const EdgeInsets.only(right: 5, left: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: white,
                child: const Icon(
                  Icons.add,
                  color: black,
                ),
              ),
              SizedBox(height: 2.h),
              Text(name, overflow: TextOverflow.ellipsis),
              SizedBox(
                  width: 70,
                  child: Center(
                      child: Text(data,
                          softWrap: true, overflow: TextOverflow.ellipsis)))
            ]));
  }

  Widget _buildMemberList(
      String name, String data, bool isSelected, imagePath) {
    return Padding(
        padding: const EdgeInsets.only(right: 5, left: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(height: 2.h),
              Text(name, overflow: TextOverflow.ellipsis),
              SizedBox(
                  width: 70,
                  child: Center(
                      child: Text(data,
                          softWrap: true, overflow: TextOverflow.ellipsis)))
            ]));
  }

  Widget createTaskButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
            height: 44.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(30.r)),
            child: Center(
                child: Text(translation(context).createTask,
                    style: TextStyle(
                        color: white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)))));
  }
}
