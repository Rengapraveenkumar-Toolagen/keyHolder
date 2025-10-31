part of 'task_bloc.dart';

class TaskEvent {}

class CreateTask extends TaskEvent {
  String taskName;
  String taskCreaterId;
  CreateTask(this.taskName, this.taskCreaterId);
}

class UpdateTask extends TaskEvent {
  String taskId;
  String taskName;
  String taskDescription;
  String taskEndTime;
  String projectId;
  String taskOwnerId;
  List<SubTasks> subTasks;
  List<File>? pocFiles;
  List<int> removedMediaPotision;
  bool isCompleted;
  bool proofOfCompletion;
  List<File>? documents;
  List<int> removedDocumentPosition;
  List<int> removedSubtaskMediaPositions;
  List<int> removedSubtaskDocumentPositions;
  UpdateTask(
      this.taskId,
      this.taskName,
      this.taskDescription,
      this.taskEndTime,
      this.projectId,
      this.taskOwnerId,
      this.subTasks,
      this.pocFiles,
      this.removedMediaPotision,
      this.isCompleted,
      this.proofOfCompletion,
      this.documents,
      this.removedDocumentPosition,this.removedSubtaskMediaPositions,this.removedSubtaskDocumentPositions);
}

class GetAllTasks extends TaskEvent {
  int limit;
  int page;
  GetAllTasks(this.limit, this.page);
}

class DeleteTask extends TaskEvent {
  String taskId;
  DeleteTask(this.taskId);
}

class GetCompletedTasks extends TaskEvent {
  String userId;
  int page;
  int limit;
  String searchTask;
  GetCompletedTasks(this.userId, this.page, this.limit, this.searchTask);
}

class GetOverdueTasks extends TaskEvent {
  String userId;
  int page;
  int limit;
  String searchTask;
  GetOverdueTasks(this.userId, this.page, this.limit, this.searchTask);
}

class GetCreatedByMeTasks extends TaskEvent {
  String userId;
  int page;
  int limit;
  String searchTask;
  GetCreatedByMeTasks(this.userId, this.page, this.limit, this.searchTask);
}

class GetAssignToMeTasks extends TaskEvent {
  String userId;
  int page;
  int limit;
  String searchTask;
  GetAssignToMeTasks(this.userId, this.page, this.limit, this.searchTask);
}

class GetAllTasksByUserId extends TaskEvent {
  String userId;
  int page;
  int limit;
  String searchTask;
  GetAllTasksByUserId(this.userId, this.page, this.limit, this.searchTask);
}

class GetTaskById extends TaskEvent {
  String taskId;
  GetTaskById(this.taskId);
}

class GetAllTasksByProject extends TaskEvent {
  String userId;
  int page;
  int limit;
  String searchTask;
  GetAllTasksByProject(this.userId, this.page, this.limit, this.searchTask);
}

class GetTasksByProjectAndUser extends TaskEvent {
  String userId;
  String projectId;
  int page;
  int limit;
  String searchTask;
  GetTasksByProjectAndUser(this.userId, this.projectId, this.page, this.limit, this.searchTask);
}

class GetTasksByProject extends TaskEvent {
  String projectId;
  int page;
  int limit;
  String searchTask;
  GetTasksByProject(this.projectId, this.page, this.limit, this.searchTask);
}
