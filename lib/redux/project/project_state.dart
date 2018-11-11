import 'package:flutter_igit/models/git_project.dart';
import 'package:meta/meta.dart';
import 'package:flutter_igit/models/loading_status.dart';

class ProjectState {

    final String search;
    final LoadingStatus status;

    final List<GitProject> allGroups;
    final LoadingStatus nextStatusInAllGroups;
    final int currentPageInAllGroups;
    final bool hasNextInAllGroups;

    final List<GitProject> allProjects;
    final LoadingStatus nextStatusInAllProjects;
    final int currentPageInAllProjects;
    final bool hasNextInAllProjects;


    ProjectState({
        @required this.search,
        @required this.status,
        @required this.allGroups,
        @required this.nextStatusInAllGroups,
        @required this.currentPageInAllGroups,
        @required this.hasNextInAllGroups,
        @required this.allProjects,
        @required this.nextStatusInAllProjects,
        @required this.currentPageInAllProjects,
        @required this.hasNextInAllProjects,
    });

    factory ProjectState.initial() {
        return ProjectState(
            search: '',
            status: LoadingStatus.loading,

            allGroups: [],
            nextStatusInAllGroups: LoadingStatus.loading,
            currentPageInAllGroups: 1,
            hasNextInAllGroups: true,

            allProjects: [],
            nextStatusInAllProjects: LoadingStatus.loading,
            currentPageInAllProjects: 1,
            hasNextInAllProjects: true
        );
    }


    ProjectState copyWith({
        String search,
        LoadingStatus status,

        List<GitProject> allGroups,
        LoadingStatus nextStatusInAllGroups,
        int currentPageInAllGroups,
        bool hasNextInAllGroups,

        List<GitProject> allProjects,
        LoadingStatus nextStatusInAllProjects,
        int currentPageInAllProjects,
        bool hasNextInAllProjects
    }) {
        return ProjectState(
            search: search ?? this.search,

            status: status ?? this.status,

            allProjects: allProjects ?? this.allProjects,
            nextStatusInAllProjects: nextStatusInAllProjects ?? this.nextStatusInAllProjects,
            currentPageInAllProjects: currentPageInAllProjects ?? this.currentPageInAllProjects,
            hasNextInAllProjects: hasNextInAllProjects ?? this.hasNextInAllProjects,

            allGroups: allGroups ?? this.allGroups,
            nextStatusInAllGroups: nextStatusInAllGroups ?? this.nextStatusInAllGroups,
            currentPageInAllGroups: currentPageInAllGroups ?? this.currentPageInAllGroups,
            hasNextInAllGroups: hasNextInAllGroups ?? this.hasNextInAllGroups
        );
    }
}