import 'package:flutter/foundation.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/redux/common_actions.dart';
import 'package:flutter_igit/redux/project/project_action.dart';
import 'package:flutter_igit/redux/project/project_state.dart';
import 'package:redux/redux.dart';

final projectReducer = combineReducers<ProjectState>([
    TypedReducer<ProjectState, RequestingProjectsAction>(_requestingProjects),
    TypedReducer<ProjectState, ReceivedProjectsAction>(_receivedProjects),
    TypedReducer<ProjectState, ErrorLoadingProjectsAction>(_errorLoadingProjects),
    TypedReducer<ProjectState, RequestingNextAction>(_requestingNext),
    TypedReducer<ProjectState, ReceivedNextAction>(_receivedNext),
    TypedReducer<ProjectState, ErrorLoadingNextAction>(_errorLoadingNext),
    TypedReducer<ProjectState, SearchQueryAction>(_searchQuery)
]);

ProjectState _requestingProjects(ProjectState state, RequestingProjectsAction action) {
    return state.copyWith(
        status: LoadingStatus.loading
    );
}

ProjectState _receivedProjects(ProjectState state, ReceivedProjectsAction action) {

    return state.copyWith(
        allGroups: action.allGroups,
        nextStatusInAllGroups: action.nextStatusInAllGroups,
        currentPageInAllGroups: action.currentPageInAllGroups,
        hasNextInAllGroups: action.hasNextInAllGroups,

        allProjects: action.allProjects,
        nextStatusInAllProjects: action.nextStatusInAllProjects,
        currentPageInAllProjects: action.currentPageInAllProjects,
        hasNextInAllProjects: action.hasNextInAllProjects,

        status: LoadingStatus.success
    );
}

ProjectState _errorLoadingProjects(ProjectState state, ErrorLoadingProjectsAction action) {
    return state.copyWith(
        status: LoadingStatus.error
    );
}


ProjectState _requestingNext(ProjectState state, RequestingNextAction action) {
    if(action.projectListType == ProjectListType.projects) {
        return state.copyWith(
            nextStatusInAllProjects: LoadingStatus.loading
        );
    } else if(action.projectListType == ProjectListType.groups){
        return state.copyWith(
            nextStatusInAllGroups: LoadingStatus.loading
        );
    }

    return state;
}


ProjectState _receivedNext(ProjectState state, ReceivedNextAction action) {
    if(action.projectListType == ProjectListType.projects) {

        List<GitProject> newAllProjects = <GitProject>[];
        newAllProjects.addAll(state.allProjects);
        newAllProjects.addAll(action.gitProjects);

        return state.copyWith(
            allProjects: newAllProjects,
            currentPageInAllProjects: action.currentPage,
            hasNextInAllProjects: action.hasNext,
            nextStatusInAllProjects: LoadingStatus.success
        );
    } else if(action.projectListType == ProjectListType.groups){
        List<GitProject> newAllGroups = <GitProject>[];
        newAllGroups.addAll(state.allGroups);
        newAllGroups.addAll(action.gitProjects);

        return state.copyWith(
            allGroups: newAllGroups,
            currentPageInAllGroups: action.currentPage,
            hasNextInAllGroups: action.hasNext,
            nextStatusInAllGroups: LoadingStatus.success
        );
    }

    return state;
}

ProjectState _errorLoadingNext(ProjectState state, ErrorLoadingNextAction action) {
    if(action.projectListType == ProjectListType.projects) {
        return state.copyWith(
            nextStatusInAllProjects: LoadingStatus.error
        );
    } else if(action.projectListType == ProjectListType.groups){
        return state.copyWith(
            nextStatusInAllGroups: LoadingStatus.error
        );
    }

    return state;
}

ProjectState _searchQuery(ProjectState state, SearchQueryAction action) {
    return state.copyWith(
        search: action.search
    );
}
