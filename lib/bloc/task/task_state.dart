part of 'task_bloc.dart';

class TaskState {}

final class TaskInitial extends TaskState {}

class CreateTaskLoading extends TaskState {
  CreateTaskLoading();
}

class CreateTaskSuccess extends TaskState {
  CreateTaskSuccess();
}

class CreateTaskFailed extends TaskState {
  String errorMessage;
  CreateTaskFailed(this.errorMessage);
}

class UpdateTaskLoading extends TaskState {
  UpdateTaskLoading();
}

class UpdateTaskSuccess extends TaskState {
  UpdateTaskSuccess();
}

class UpdateTaskFailed extends TaskState {
  String errorMessage;
  UpdateTaskFailed(this.errorMessage);
}

class GetAllTasksLoading extends TaskState {
  GetAllTasksLoading();
}

class GetAllTasksSuccess extends TaskState {
  final List<TaskDetails> taskDetails;
  GetAllTasksSuccess(this.taskDetails);
}

class GetAllTasksFailed extends TaskState {
  final String errorMessage;
  GetAllTasksFailed(this.errorMessage);
}

class DeleteTaskLoading extends TaskState {
  DeleteTaskLoading();
}

class DeleteTaskSuccess extends TaskState {
  DeleteTaskSuccess();
}

class DeleteTaskFailed extends TaskState {
  final String errorMessage;
  DeleteTaskFailed(this.errorMessage);
}

class GetCompletedTaskLoading extends TaskState {
  GetCompletedTaskLoading();
}

class GetCompletedTasksSuccess extends TaskState {
  final List<TaskDetails> getCompletedTaskDetails;
  GetCompletedTasksSuccess(this.getCompletedTaskDetails);
}

class GetCompletedTasksFailed extends TaskState {
  final String errorMessage;
  GetCompletedTasksFailed(this.errorMessage);
}

class GetOverdueTaskLoading extends TaskState {
  GetOverdueTaskLoading();
}

class GetOverdueTasksSuccess extends TaskState {
  final List<TaskDetails> getOverdueTaskDetails;
  GetOverdueTasksSuccess(this.getOverdueTaskDetails);
}

class GetOverdueTasksFailed extends TaskState {
  final String errorMessage;
  GetOverdueTasksFailed(this.errorMessage);
}

class GetCreatedByMeTaskLoading extends TaskState {
  GetCreatedByMeTaskLoading();
}

class GetCreatedByMeTasksSuccess extends TaskState {
  final List<TaskDetails> getCreatedByMeTaskDetails;
  GetCreatedByMeTasksSuccess(this.getCreatedByMeTaskDetails);
}

class GetCreatedByMeTasksFailed extends TaskState {
  final String errorMessage;
  GetCreatedByMeTasksFailed(this.errorMessage);
}

class GetAssignToMeTaskLoading extends TaskState {
  GetAssignToMeTaskLoading();
}

class GetAssignToMeTasksSuccess extends TaskState {
  final List<TaskDetails> getAssignToMeTaskDetails;
  GetAssignToMeTasksSuccess(this.getAssignToMeTaskDetails);
}

class GetAssignToMeTasksFailed extends TaskState {
  final String errorMessage;
  GetAssignToMeTasksFailed(this.errorMessage);
}

class GetAllTasksByUserIdLoading extends TaskState {
  GetAllTasksByUserIdLoading();
}

class GetAllTasksByUserIdSuccess extends TaskState {
  final List<TaskDetails> getAllTasksByUserIdDetails;
  GetAllTasksByUserIdSuccess(this.getAllTasksByUserIdDetails);
}

class GetAllTasksByUserIdFailed extends TaskState {
  final String errorMessage;
  GetAllTasksByUserIdFailed(this.errorMessage);
}

class GetTaskByIdLoading extends TaskState {
  GetTaskByIdLoading();
}

class GetTaskByIdSuccess extends TaskState {
  final TaskDetails taskById;
  GetTaskByIdSuccess(this.taskById);
}

class GetTaskByIdFailed extends TaskState {
  final String errorMessage;
  GetTaskByIdFailed(this.errorMessage);
}

class GetAllTasksByProjectLoading extends TaskState {
  GetAllTasksByProjectLoading();
}

class GetAllTasksByProjectSuccess extends TaskState {
  final List<ProjectDetails> getAllTaskByProject;
  GetAllTasksByProjectSuccess(this.getAllTaskByProject);
}

class GetAllTasksByProjectFailed extends TaskState {
  final String errorMessage;
  GetAllTasksByProjectFailed(this.errorMessage);
}

class GetTasksByProjectAndUserLoading extends TaskState {
  GetTasksByProjectAndUserLoading();
}

class GetTasksByProjectAndUserSuccess extends TaskState {
  final List<TaskDetails> getTasksByProjectAndUser;
  GetTasksByProjectAndUserSuccess(this.getTasksByProjectAndUser);
}

class GetTasksByProjectAndUserFailed extends TaskState {
  final String errorMessage;
  GetTasksByProjectAndUserFailed(this.errorMessage);
}

class GetTasksByProjectLoading extends TaskState {
  GetTasksByProjectLoading();
}

class GetTasksByProjectSuccess extends TaskState {
  final List<TaskDetails> getTasksByProject;
  GetTasksByProjectSuccess(this.getTasksByProject);
}

class GetTasksByProjectFailed extends TaskState {
  final String errorMessage;
  GetTasksByProjectFailed(this.errorMessage);
}
