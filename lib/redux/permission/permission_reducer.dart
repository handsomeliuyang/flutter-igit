import 'package:flutter/foundation.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/redux/permission/permission_action.dart';
import 'package:redux/redux.dart';

import 'package:flutter_igit/redux/permission/permission_state.dart';
import 'package:flutter_igit/models/loading_status.dart';

final permissionReducer = combineReducers<PermissionState>([
    TypedReducer<PermissionState, RequestingPermissionAction>(_requestingPermission),
    TypedReducer<PermissionState, ReceivedPermissionAction>(_receivedPermission),
    TypedReducer<PermissionState, ErrorLoadingPermissionAction>(_errorLoadingPermission),
    TypedReducer<PermissionState, ReceivedUserAction>(_receivedUser),
    TypedReducer<PermissionState, DeleteGitUser>(_deleteGitUser)
]);

PermissionState _requestingPermission(PermissionState state, RequestingPermissionAction action) {
    return state.copyWith(
        status: LoadingStatus.loading
    );
}

PermissionState _receivedPermission(PermissionState state, ReceivedPermissionAction action){
    debugPrint('liuyang reducer _receivedPermission');
    return state.copyWith(
        status: LoadingStatus.success,
        projects: action.projects
    );
}

PermissionState _errorLoadingPermission(PermissionState state, ErrorLoadingPermissionAction action){
    return state.copyWith(
        status: LoadingStatus.error
    );
}

PermissionState _receivedUser(PermissionState state, ReceivedUserAction action) {
    List<GitUser> newUsers = <GitUser>[];
    newUsers.addAll(state.users);
    newUsers.add(action.user);
    return state.copyWith(
        users: newUsers
    );
}

PermissionState _deleteGitUser(PermissionState state, DeleteGitUser action) {
    List<GitUser> newUsers = <GitUser>[];
    newUsers.addAll(state.users);

    GitUser deleteUser;
    for(GitUser user in newUsers){
        if(user == action.user) {
            deleteUser = user;
            break;
        }
    }
    newUsers.remove(deleteUser);

    return state.copyWith(
        users: newUsers
    );
}
