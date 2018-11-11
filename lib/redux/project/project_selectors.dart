import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/redux/app/app_state.dart';

List<GitProject> projectsSelector(AppState state, ProjectListType projectListType){
    return projectListType == ProjectListType.groups ? state.projectState.allGroups : state.projectState.allProjects;
}

LoadingStatus statusSelector(AppState state){
    return state.projectState.status;
}

LoadingStatus nextStatusSelector(AppState state, ProjectListType projectListType){
    return projectListType == ProjectListType.groups ? state.projectState.nextStatusInAllGroups : state.projectState.nextStatusInAllProjects;
}

int currentPageSelector(AppState state, ProjectListType projectListType){
    return projectListType == ProjectListType.groups ? state.projectState.currentPageInAllGroups : state.projectState.currentPageInAllProjects;
}

bool hasNextSelector(AppState state, ProjectListType projectListType){
    return projectListType == ProjectListType.groups ? state.projectState.hasNextInAllGroups : state.projectState.hasNextInAllProjects;
}