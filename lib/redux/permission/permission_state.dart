import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:meta/meta.dart';


class PermissionState {
    final LoadingStatus status;
    final List<GitProject> projects;
    final List<GitUser> users;

    PermissionState({
        @required this.status,
        @required this.projects,
        @required this.users
    });

    factory PermissionState.initial() {
        return PermissionState(
            status: LoadingStatus.loading,
            projects: <GitProject>[],
            users: <GitUser>[]
        );
    }

    PermissionState copyWith({
        LoadingStatus status,
        List<GitProject> projects,
        List<GitUser> users
    }) {
        return PermissionState(
            status: status ?? this.status,
            projects: projects ?? this.projects,
            users: users ?? this.users
        );
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is PermissionState &&
                runtimeType == other.runtimeType &&
                status == other.status &&
                projects == other.projects &&
                users == other.users;

    @override
    int get hashCode =>
        status.hashCode ^
        projects.hashCode ^
        users.hashCode;

    @override
    String toString() {
        return 'PermissionState{status: $status, projects: $projects, users: $users}';
    }
}