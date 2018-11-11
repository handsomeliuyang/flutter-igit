import 'dart:async';

import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/models/tradeline.dart';
import 'package:meta/meta.dart';

class RequestingPermissionAction {}

class ReceivedPermissionAction {
    final List<GitProject> projects;

    ReceivedPermissionAction({
        @required this.projects
    });

    @override
    String toString() {
        return 'ReceivedPermissionAction{projects: $projects}';
    }
}

class ErrorLoadingPermissionAction {
}

class RefreshPermissionAction {}

class AddGitProject {
    final GitProject project;

    AddGitProject(this.project);

    @override
    String toString() {
        return 'AddGitProject{project: $project}';
    }
}

class DeleteGitProject {
    final GitProject project;

    DeleteGitProject(this.project);

    @override
    String toString() {
        return 'DeleteGitProject{project: $project}';
    }
}

class ConvertOANameAction {
    final String oaName;
    final Completer completer;

    ConvertOANameAction(this.completer, this.oaName);

    @override
    String toString() {
        return 'ConvertOANameAction{oaName: $oaName, completer: $completer}';
    }
}
class ReceivedUserAction {
    final GitUser user;

    ReceivedUserAction({
        @required this.user
    });

    @override
    String toString() {
        return 'ReceivedUserAction{user: $user}';
    }

}

class DeleteGitUser{
    final GitUser user;

    DeleteGitUser(this.user);

    @override
    String toString() {
        return 'DeleteGitUser{user: $user}';
    }

}

class AllocationPermissionAction {
    final Completer completer;
    final List<GitUser> users;
    final String level;
    final List<GitProject> projects;

    AllocationPermissionAction(this.completer, this.users, this.level,
        this.projects);

    @override
    String toString() {
        return 'AllocationPermissionAction{completer: $completer, users: $users, level: $level, projects: $projects}';
    }
}