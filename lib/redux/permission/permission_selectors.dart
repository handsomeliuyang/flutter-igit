import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/redux/permission/permission_state.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/redux/app/app_state.dart';

LoadingStatus statusSelector(AppState state){
    return state.permissionState.status;
}

List<GitProject> projectsSelector(AppState state){
    return state.permissionState.projects;
}

List<GitUser> usersSelector(AppState state){
    return state.permissionState.users;
}