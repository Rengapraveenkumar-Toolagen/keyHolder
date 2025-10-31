part of 'project_bloc.dart';

class ProjectEvent {}

class GetAllProjects extends ProjectEvent {
  int page;
  int limit;
  String searchProject;
  GetAllProjects(this.page, this.limit, this.searchProject);
}

class CreateProject extends ProjectEvent {
  String projectName;
  String userId;
  CreateProject(this.projectName, this.userId);
}

class UpdateProject extends ProjectEvent {
  String projectId;
  String projectName;
  String projectDescription;
  List<String> projectMembers;
  UpdateProject(this.projectId, this.projectName, this.projectDescription, this.projectMembers);
  }
class DeleteProject extends ProjectEvent {
  String projectId;
   DeleteProject(this.projectId);
}