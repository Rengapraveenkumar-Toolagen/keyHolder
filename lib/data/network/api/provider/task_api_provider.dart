import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../model/subtask.dart';
import '../constant/endpoints.dart';
import '../dio_client.dart';

class TaskApiProvider {
  final DioClient _dioClient = DioClient();

  Future<Response> createTask(String taskName, String taskCreaterId) async {
    try {
      var response = await _dioClient.post(Endpoints.createTask,
          data: {'taskName': taskName, 'taskCreatorId': taskCreaterId});
      return response;
    } catch (error) {
      rethrow;
    }
  }

  updateTask(
      String taskId,
      String taskName,
      String taskDescription,
      String taskEndTime,
      String projectId,
      String taskOwnerId,
      List<SubTasks> subTasks,
      List<File>? pocFiles,
      List<int> removedMediaPotisions,
      bool isCompleted,
      bool proofOfCompletion,
      List<File>? documents,
      List<int> removedDocumentPotisions,
      List<int> removedSubtaskMediaPositions,
      List<int> removedSubtaskDocumentPositions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      var url = Uri.parse('${Endpoints.baseUrl}${Endpoints.updateTask}');

      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      });
      request.fields['taskId'] = taskId;
      request.fields['taskName'] = taskName;
      request.fields['taskDescription'] = taskDescription;
      request.fields['taskEndTime'] = taskEndTime;
      request.fields['projectId'] = projectId;
      request.fields['taskOwnerId'] = taskOwnerId;
      request.fields['isCompleted'] = isCompleted.toString();
      request.fields['ProofOfCompletion'] = proofOfCompletion.toString();
      if (proofOfCompletion != false && pocFiles != null) {
        for (var file in pocFiles) {
          request.files.add(http.MultipartFile(
              'ProofOfCompletionImages',
              File(file.path).readAsBytes().asStream(),
              File(file.path).lengthSync(),
              filename: file.path.split('/').last));
        }
      }
      if (removedMediaPotisions.isNotEmpty) {
        for (var removedMediaPotision in removedMediaPotisions) {
          var index = removedMediaPotisions.indexOf(removedMediaPotision);
          request.fields['RemovedMediaIndex[$index]'] =
              removedMediaPotision.toString();
        }
      }
      if (documents != null) {
        for (var file in documents) {
          request.files.add(http.MultipartFile(
              'Documents',
              File(file.path).readAsBytes().asStream(),
              File(file.path).lengthSync(),
              filename: file.path.split('/').last));
        }
      }
      if (removedDocumentPotisions.isNotEmpty) {
        for (var removedDocumentPosition in removedDocumentPotisions) {
          var index = removedDocumentPotisions.indexOf(removedDocumentPosition);
          request.fields['RemovedDocumentIndex[$index]'] =
              removedDocumentPosition.toString();
        }
      }
      if (subTasks.isNotEmpty) {
        for (var subtask in subTasks) {
          var index = subTasks.indexOf(subtask);
          request.fields['subTasks[$index].SubTaskId'] =
              subtask.subTaskId ?? '';
          request.fields['subTasks[$index].SubTaskName'] =
              subtask.subTaskName ?? '';
          request.fields['subTasks[$index].SubTaskDescription'] =
              subtask.subTaskDescription ?? '';
          request.fields['subTasks[$index].SubTaskCreatorId'] =
              subtask.subTaskCreator!.userId ?? '';
          request.fields['subTasks[$index].SubTaskOwnerId'] =
              subtask.subTaskOwner!.userId ?? '';
          request.fields['subTasks[$index].IsCompleted'] =
              subtask.isCompleted.toString();
          request.fields['subTasks[$index].SubTaskProofOfCompletion'] =
              subtask.subTaskProofOfCompletion.toString();
          if (subtask.subTaskProofOfCompletion != false &&
              subtask.subTaskProofOfCompletionImage != null) {
            for (var file in subtask.subTaskProofOfCompletionImage!) {
              if (file is File) {
                request.files.add(http.MultipartFile(
                    'subTasks[$index].SubTaskProofOfCompletionImage',
                    File(file.path).readAsBytes().asStream(),
                    File(file.path).lengthSync(),
                    filename: file.path.split('/').last));
              }
            }
          }

          for (var file in subtask.subTaskDocuments!) {
            if (file is File) {
              request.files.add(http.MultipartFile(
                  'subTasks[$index].SubTaskDocuments',
                  File(file.path).readAsBytes().asStream(),
                  File(file.path).lengthSync(),
                  filename: file.path.split('/').last));
            }
          }

          if (removedSubtaskMediaPositions.isNotEmpty) {
            for (var removedSubtaskMediaPosition
                in removedSubtaskMediaPositions) {
              var removedIndex = removedSubtaskMediaPositions
                  .indexOf(removedSubtaskMediaPosition);
              request.fields[
                      'subTasks[$index].SubTaskRemovedMediaIndex[$removedIndex]'] =
                  removedSubtaskMediaPosition.toString();
            }
          }
          if (removedSubtaskDocumentPositions.isNotEmpty) {
            for (var removedSubtaskDocumentPosition
                in removedSubtaskDocumentPositions) {
              var removedIndex = removedSubtaskDocumentPositions
                  .indexOf(removedSubtaskDocumentPosition);
              request.fields[
                      'subTasks[$index].SubTaskRemovedDocumentIndex[$removedIndex]'] =
                  removedSubtaskDocumentPosition.toString();
            }
          }
        }
      }

      http.Response response =
          await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAllTasks(int taskLimit, int taskPage) async {
    try {
      final Response response = await _dioClient
          .get('${Endpoints.getAllTasks}?limit=$taskLimit&page=$taskPage');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> deleteTask(String taskId) async {
    try {
      final Response response =
          await _dioClient.delete('${Endpoints.deleteTask}?taskId=$taskId');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getCompletedTasks(
      String userId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getCompletedTasks}?userId=$userId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getOverdueTasks(
      String userId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getOverdueTasks}?userId=$userId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getCreatedByMeTasks(
      String userId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getCreatedByMeTasks}?userId=$userId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAssignToMeTasks(
      String userId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getAssignToMeTasks}?userId=$userId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAllTasksByUserId(
      String userId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getAllTasksByUserId}?userId=$userId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getTaskById(String taskId) async {
    try {
      final Response response =
          await _dioClient.get('${Endpoints.getTaskById}?taskId=$taskId');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAllTasksByProject(
      String userId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getAllTasksByProject}?userId=$userId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getTasksByProjectAndUser(String userId, String projectId,
      int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getTasksByProjectAndUser}?userId=$userId&projectId=$projectId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getTasksByProject(
      String projectId, int taskPage, int taskLimit, String searchTask) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getTasksByProject}?projectId=$projectId&page=$taskPage&limit=$taskLimit&keyword=$searchTask');
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
