import 'dart:convert';

import './label.dart';
import './owner_detail.dart';
import './project_details.dart';
import './subtask.dart';
import '../../utils/utils.dart';

class TaskDetails {
  String? taskId;
  String? taskName;
  String? taskDescription;
  String? taskStartTime;
  String? taskEndTime;
  List<dynamic>? proofOfCompletionImages;
  bool? proofOfCompletion;
  bool? isCompleted;
  String? taskCompletionTime;
  Owner? taskOwner;
  Owner? taskCreator;
  Label? label;
  ProjectDetails? project;
  List<SubTasks>? subTasks;
  bool? isDeleted;
  String? createdOn;
  String? modifiedOn;
  List<dynamic>? documents;

  TaskDetails(
      {this.taskId,
      this.taskName,
      this.taskDescription,
      this.taskStartTime,
      this.taskEndTime,
      this.proofOfCompletionImages,
      this.proofOfCompletion,
      this.isCompleted,
      this.taskCompletionTime,
      this.taskOwner,
      this.taskCreator,
      this.label,
      this.project,
      this.subTasks,
      this.isDeleted,
      this.createdOn,
      this.modifiedOn,
      this.documents});

  factory TaskDetails.fromMap(Map<String, dynamic> map) {
    List<SubTasks>? subTasks = map['subTasks'] == null
        ? []
        : List<SubTasks>.from(
            map['subTasks']?.map((subtask) => SubTasks.fromMap(subtask)));
    return TaskDetails(
      taskId: map['taskId'],
      taskName: map['taskName'],
      taskDescription: map['taskDescription'],
      taskStartTime: map['taskStartTime'],
      taskEndTime: map['taskEndTime'],
      proofOfCompletionImages: map['proofOfCompletionImages'] == null
          ? []
          : json
              .decode(map['proofOfCompletionImages']
                  .toString()
                  .replaceAll("'", '"')
                  .replaceAll('JPEG', 'jpg')
                  .replaceAll('WEBP', 'webp'))
              .map((image) => getImagePath(image))
              .toList(),
      proofOfCompletion: map['proofOfCompletion'],
      isCompleted: map['isCompleted'],
      taskCompletionTime: map['taskCompletionTime'],
      taskOwner:
          map['taskOwner'] != null ? Owner.fromMap(map['taskOwner']) : null,
      taskCreator:
          map['taskCreator'] != null ? Owner.fromMap(map['taskCreator']) : null,
      label: map['label'] != null ? Label.fromMap(map['label']) : null,
      project: map['project'] != null
          ? ProjectDetails.fromMap(map['project'])
          : null,
      subTasks: map['subTasks'] == null ? null : subTasks,
      isDeleted: map['isDeleted'],
      createdOn: map['createdOn'],
      modifiedOn: map['modifiedOn'],
      documents: map['documents'] == null
          ? []
          : json
              .decode(map['documents']
                  .toString()
                  .replaceAll("'", '"')
                  .replaceAll('JPEG', 'jpg')
                  .replaceAll('WEBP', 'webp'))
              .map((image) => getImagePath(image))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskStartTime': taskStartTime,
      'taskEndTime': taskEndTime,
      'proofOfCompletion': proofOfCompletion,
      'proofOfCompletionImages': proofOfCompletionImages,
      'isCompleted': isCompleted,
      'taskCompletionTime': taskCompletionTime,
      'taskOwner': taskOwner,
      'taskCreator': taskCreator,
      'label': label,
      'project': project,
      'subTasks': subTasks,
      'isDeleted': isDeleted,
      'createdOn': createdOn,
      'modifiedOn': modifiedOn,
      'documents': documents
    };
  }

  factory TaskDetails.fromJson(String source) =>
      TaskDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  static String getImagePath(imageName) {
    return ImageUrlBuilder.getImage('tasks/$imageName');
  }
}
