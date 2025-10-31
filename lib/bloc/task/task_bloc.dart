import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/project_details.dart';
import '../../data/model/subtask.dart';
import '../../data/model/task_details.dart';
import '../../data/repo/task_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepo taskRepo = TaskRepo();
  TaskBloc() : super(TaskInitial()) {
    on<TaskEvent>((event, emit) async {
      if (event is CreateTask) {
        try {
          emit(CreateTaskLoading());
          await taskRepo.createTask(event.taskName, event.taskCreaterId);
          emit(CreateTaskSuccess());
        } catch (error) {
          emit(CreateTaskFailed(error.toString()));
        }
      } else if (event is UpdateTask) {
        try {
          emit(UpdateTaskLoading());
          await taskRepo.updateTask(
              event.taskId,
              event.taskName,
              event.taskDescription,
              event.taskEndTime,
              event.projectId,
              event.taskOwnerId,
              event.subTasks,
              event.pocFiles,
              event.removedMediaPotision,
              event.isCompleted,
              event.proofOfCompletion,
              event.documents,
              event.removedDocumentPosition,
              event.removedSubtaskMediaPositions,
              event.removedSubtaskDocumentPositions);
          emit(UpdateTaskSuccess());
        } catch (error) {
          emit(UpdateTaskFailed(error.toString()));
        }
      } else if (event is GetAllTasks) {
        if (event.page == 1) {
          emit(GetAllTasksLoading());
        }
        try {
          List<TaskDetails> response =
              await taskRepo.getAllTasks(event.limit, event.page);
          emit(GetAllTasksSuccess(response));
        } catch (error) {
          emit(GetAllTasksFailed(error.toString()));
        }
      } else if (event is DeleteTask) {
        emit(DeleteTaskLoading());
        try {
          await taskRepo.deleteTask(event.taskId);
          emit(DeleteTaskSuccess());
        } catch (error) {
          emit(DeleteTaskFailed(error.toString()));
        }
      } else if (event is GetCompletedTasks) {
        if (event.page == 1) {
          emit(GetCompletedTaskLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getCompletedTasks(
              event.userId, event.page, event.limit, event.searchTask);
          emit(GetCompletedTasksSuccess(response));
        } catch (error) {
          emit(GetCompletedTasksFailed(error.toString()));
        }
      } else if (event is GetOverdueTasks) {
        if (event.page == 1) {
          emit(GetOverdueTaskLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getOverdueTasks(
              event.userId, event.page, event.limit, event.searchTask);
          emit(GetOverdueTasksSuccess(response));
        } catch (error) {
          emit(GetOverdueTasksFailed(error.toString()));
        }
      } else if (event is GetCreatedByMeTasks) {
        if (event.page == 1) {
          emit(GetCreatedByMeTaskLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getCreatedByMeTasks(
              event.userId, event.page, event.limit, event.searchTask);
          emit(GetCreatedByMeTasksSuccess(response));
        } catch (error) {
          emit(GetCreatedByMeTasksFailed(error.toString()));
        }
      } else if (event is GetAssignToMeTasks) {
        if (event.page == 1) {
          emit(GetAssignToMeTaskLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getAssignToMeTasks(
              event.userId, event.page, event.limit, event.searchTask);
          emit(GetAssignToMeTasksSuccess(response));
        } catch (error) {
          emit(GetAssignToMeTasksFailed(error.toString()));
        }
      } else if (event is GetAllTasksByUserId) {
        if (event.page == 1) {
          emit(GetAllTasksByUserIdLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getAllTasksByUserId(
              event.userId, event.page, event.limit, event.searchTask);
          emit(GetAllTasksByUserIdSuccess(response));
        } catch (error) {
          emit(GetAllTasksByUserIdFailed(error.toString()));
        }
      } else if (event is GetTaskById) {
        try {
          emit(GetTaskByIdLoading());
          TaskDetails taskById = await taskRepo.getTaskById(event.taskId);
          emit(GetTaskByIdSuccess(taskById));
        } catch (error) {
          emit(GetTaskByIdFailed(error.toString()));
        }
      } else if (event is GetAllTasksByProject) {
        if (event.page == 1) {
          emit(GetAllTasksByProjectLoading());
        }
        try {
          List<ProjectDetails> response = await taskRepo.getAllTasksByProject(
              event.userId, event.page, event.limit, event.searchTask);
          emit(GetAllTasksByProjectSuccess(response));
        } catch (error) {
          emit(GetAllTasksByProjectFailed(error.toString()));
        }
      } else if (event is GetTasksByProjectAndUser) {
        if (event.page == 1) {
          emit(GetTasksByProjectAndUserLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getTasksByProjectAndUser(
              event.userId,
              event.projectId,
              event.page,
              event.limit,
              event.searchTask);
          emit(GetTasksByProjectAndUserSuccess(response));
        } catch (error) {
          emit(GetTasksByProjectAndUserFailed(error.toString()));
        }
      } else if (event is GetTasksByProject) {
        if (event.page == 1) {
          emit(GetTasksByProjectLoading());
        }
        try {
          List<TaskDetails> response = await taskRepo.getTasksByProject(
              event.projectId, event.page, event.limit, event.searchTask);
          emit(GetTasksByProjectSuccess(response));
        } catch (error) {
          emit(GetTasksByProjectFailed(error.toString()));
        }
      }
    });
  }
}
