import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/permission/permission_action.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_igit/redux/permission/permission_selectors.dart';

class PermissionPageViewModel {
    final LoadingStatus status;
    final List<GitProject> projects;
    final List<GitUser> users;
    final Function refreshPermission;
    final Function addGitProject;
    final Function deleteGitProject;
    final Function getUserIdByName;
    final Function deleteGitUser;
    final Function allocationPermission;

    PermissionPageViewModel({
        @required this.status,
        @required this.projects,
        @required this.users,
        @required this.refreshPermission,
        @required this.addGitProject,
        @required this.deleteGitProject,
        @required this.getUserIdByName,
        @required this.deleteGitUser,
        @required this.allocationPermission
    });

    static PermissionPageViewModel fromStore(Store<AppState> store){
        return PermissionPageViewModel(
            status: statusSelector(store.state),
            projects: projectsSelector(store.state),
            users: usersSelector(store.state),
            refreshPermission: (){
                store.dispatch(RefreshPermissionAction());
            },
            addGitProject: (GitProject project){
                store.dispatch(AddGitProject(project));
            },
            deleteGitProject: (GitProject project){
                store.dispatch(DeleteGitProject(project));
            },
            getUserIdByName: (Completer completer, String oaName){
                store.dispatch(ConvertOANameAction(completer, oaName));
            },
            deleteGitUser: (GitUser user){
                store.dispatch(DeleteGitUser(user));
            },
            allocationPermission: (Completer completer, List<GitUser> users, String level, List<GitProject> projects){
                store.dispatch(AllocationPermissionAction(completer, users, level, projects));
            }
        );
    }

    @override
    String toString() {
        return 'PermissionPageViewModel{status: $status, projects: $projects, users: $users}';
    }
}