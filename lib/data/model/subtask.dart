import 'dart:convert';

import '../../utils/image_url_builder.dart';
import './owner_detail.dart';

class SubTasks {
  String? subTaskId;
  String? subTaskName;
  String? subTaskDescription;
  Owner? subTaskOwner;
  Owner? subTaskCreator;
  bool? isCompleted;
  bool? subTaskProofOfCompletion;
  List<dynamic>? subTaskProofOfCompletionImage;
  List<dynamic>? subTaskDocuments;

  SubTasks(
      this.subTaskId,
      this.subTaskName,
      this.subTaskDescription,
      this.subTaskOwner,
      this.subTaskCreator,
      this.isCompleted,
      this.subTaskProofOfCompletion,
      this.subTaskProofOfCompletionImage,this.subTaskDocuments);

  factory SubTasks.fromMap(Map<String, dynamic> map) {
    return SubTasks(
        map['subTaskId'],
        map['subTaskName'],
        map['subTaskDescription'],
        map['subTaskOwner'] != null ? Owner.fromMap(map['subTaskOwner']) : null,
        map['subTaskCreator'] != null
            ? Owner.fromMap(map['subTaskCreator'])
            : null,
        map['isCompleted'],
        map['subTaskProofOfCompletion'],
        map['subTaskProofOfCompletionImage'] == null
            ? []
            : json
                .decode(map['subTaskProofOfCompletionImage']
                    .toString()
                    .replaceAll("'", '"')
                    .replaceAll('JPEG', 'jpg')
                    .replaceAll('WEBP', 'webp'))
                .map((image) => getImagePath(image))
                .toList(),
         map['subTaskDocuments'] == null
            ? []
            : json
                .decode(map['subTaskDocuments']
                    .toString()
                    .replaceAll("'", '"')
                    .replaceAll('JPEG', 'jpg')
                    .replaceAll('WEBP', 'webp'))
                .map((image) => getImagePath(image))
                .toList());
  }

  Map<String, dynamic> toMap() {
    return {
      'subTaskId': subTaskId,
      'subTaskName': subTaskName,
      'subTaskDescription': subTaskDescription,
      'subTaskOwner': subTaskOwner,
      'subTaskCreator': subTaskCreator,
      'isCompleted': isCompleted,
      'subTaskProofOfCompletion': subTaskProofOfCompletion,
      'subTaskProofOfCompletionImage': subTaskProofOfCompletionImage,
      'subTaskDocuments':subTaskDocuments
    };
  }

  static String getImagePath(imageName) {
    return ImageUrlBuilder.getImage('tasks/$imageName');
  }
}
