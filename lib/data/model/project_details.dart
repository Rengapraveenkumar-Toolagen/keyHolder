import 'dart:convert';

import './member.dart';
import './task_details.dart';

class ProjectDetails {
  String? projectId;
  String? projectName;
  String? projectDescription;
  List<Member>? projectMembers;
  List<TaskDetails>? tasks;
  int? taskCount;
  ProjectDetails(this.projectId, this.projectName, this.projectDescription,
      this.projectMembers, this.tasks, this.taskCount);

  factory ProjectDetails.fromMap(Map<String, dynamic> map) {
    List<Member>? projectMembers = map['projectMembers'] == null
        ? []
        : List<Member>.from(
            map['projectMembers']?.map((x) => Member.fromMap(x)));
    List<TaskDetails>? tasks = map['tasks'] == null
        ? []
        : List<TaskDetails>.from(
            map['tasks']?.map((x) => TaskDetails.fromMap(x)));
    return ProjectDetails(
        map['projectId'],
        map['projectName'],
        map['projectDescription'],
        map['projectMembers'] == null ? null : projectMembers,
        map['tasks'] == null ? null : tasks,
        map['taskCount']);
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectMembers': projectMembers,
      'tasks': tasks,
      'taskCount': taskCount
    };
  }

  String toJson() => json.encode(toMap());

  factory ProjectDetails.fromJson(String source) =>
      ProjectDetails.fromMap(json.decode(source));
}
