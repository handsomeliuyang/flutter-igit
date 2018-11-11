import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:meta/meta.dart';

class RequestingProjectsAction {}

class ReceivedProjectsAction {
    final List<GitProject> allGroups;
    final LoadingStatus nextStatusInAllGroups;
    final int currentPageInAllGroups;
    final bool hasNextInAllGroups;

    final List<GitProject> allProjects;
    final LoadingStatus nextStatusInAllProjects;
    final int currentPageInAllProjects;
    final bool hasNextInAllProjects;

    ReceivedProjectsAction({
        @required this.allGroups,
        @required this.nextStatusInAllGroups,
        @required this.currentPageInAllGroups,
        @required this.hasNextInAllGroups,

        @required this.allProjects,
        @required this.nextStatusInAllProjects,
        @required this.currentPageInAllProjects,
        @required this.hasNextInAllProjects
    });

}

class ErrorLoadingProjectsAction {
}

class RefreshProjectsAction {}

class FetchNextProjectsAction {
    final ProjectListType projectListType;
    final int nextPage;

    FetchNextProjectsAction({
        @required this.projectListType,
        @required this.nextPage
    });
}

class RefreshNextAction {
    final ProjectListType projectListType;
    final int nextPage;

    RefreshNextAction({
        @required this.projectListType,
        @required this.nextPage
    });
}

class RequestingNextAction {
    final ProjectListType projectListType;

    RequestingNextAction({
        this.projectListType
    });
}

class ReceivedNextAction {
    final ProjectListType projectListType;
    final List<GitProject> gitProjects;
    final int currentPage;
    final bool hasNext;

    ReceivedNextAction({
        this.projectListType,
        this.gitProjects,
        this.currentPage,
        this.hasNext
    });
}

class ErrorLoadingNextAction {
    final ProjectListType projectListType;

    ErrorLoadingNextAction({
        this.projectListType
    });
}

class SearchQueryAction {
    final String search;

    SearchQueryAction(this.search);

    @override
    String toString() {
        return 'SearchQueryAction{search: $search}';
    }
}

