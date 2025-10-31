import 'dart:io';
import 'package:dio/dio.dart';

import '../model/project_details.dart';
import '../model/subtask.dart';
import '../model/task_details.dart';
import '../network/api/dio_exception.dart';
import '../network/api/provider/task_api_provider.dart';

class TaskRepo {
  final TaskApiProvider _taskApiProvider = TaskApiProvider();

  Future<Response> createTask(String taskName, String taskCreaterId) async {
    try {
      var response = await _taskApiProvider.createTask(taskName, taskCreaterId);
      return response;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
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
      List<int> removedDocumentPositions,
      List<int> removedSubtaskMediaPositions,
      List<int> removedSubtaskDocumentPositions) async {
    try {
      var response = await _taskApiProvider.updateTask(
          taskId,
          taskName,
          taskDescription,
          taskEndTime,
          projectId,
          taskOwnerId,
          subTasks,
          pocFiles,
          removedMediaPotisions,
          isCompleted,
          proofOfCompletion,
          documents,
          removedDocumentPositions,
          removedSubtaskMediaPositions,
          removedSubtaskDocumentPositions);
      return response;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getAllTasks(int limit, int page) async {
    List<TaskDetails> tasks;
    try {
      var response = await _taskApiProvider.getAllTasks(limit, page);
      var result = response.data as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<Response> deleteTask(String taskId) async {
    try {
      final response = await _taskApiProvider.deleteTask(taskId);
      return response;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getCompletedTasks(
      String userId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getCompletedTasks(userId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getOverdueTasks(
      String userId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getOverdueTasks(userId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getCreatedByMeTasks(
      String userId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getCreatedByMeTasks(userId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getAssignToMeTasks(
      String userId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getAssignToMeTasks(userId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getAllTasksByUserId(
      String userId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getAllTasksByUserId(userId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<TaskDetails> getTaskById(String taskId) async {
    TaskDetails task;
    try {
      var response = await _taskApiProvider.getTaskById(taskId);
      var res = response.data as Map<String, dynamic>;
      task = TaskDetails.fromMap(res['data']);
      return task;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<ProjectDetails>> getAllTasksByProject(
      String userId, int page, int limit, String searchTask) async {
    List<ProjectDetails> projects;
    try {
      var response =
          await _taskApiProvider.getAllTasksByProject(userId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      projects = result.map((task) => ProjectDetails.fromMap(task)).toList();
      return projects;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

    Future<List<TaskDetails>> getTasksByProjectAndUser(
      String userId, String projectId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getTasksByProjectAndUser(userId, projectId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<TaskDetails>> getTasksByProject(
     String projectId, int page, int limit, String searchTask) async {
    List<TaskDetails> tasks;
    try {
      var response =
          await _taskApiProvider.getTasksByProject(projectId, page, limit, searchTask);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      tasks = result.map((task) => TaskDetails.fromMap(task)).toList();
      return tasks;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }
}
