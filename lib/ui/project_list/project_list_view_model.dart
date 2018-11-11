import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/project/project_action.dart';
import 'package:meta/meta.dart';
import 'package:redux/src/store.dart';
import 'package:flutter_igit/redux/project/project_selectors.dart';
import 'package:flutter_igit/models/loading_status.dart';

class ProjectListViewModel {
    final List<GitProject> projects;
    final LoadingStatus status;
    final LoadingStatus nextStatus;
    final int currentPage;
    final bool hasNext;
    final Function refreshProjects;
    final Function fetchNextProjects;

    ProjectListViewModel({
        @required this.projects,
        @required this.status,
        @required this.nextStatus,
        @required this.currentPage,
        @required this.hasNext,
        @required this.refreshProjects,
        @required this.fetchNextProjects
    });

    factory ProjectListViewModel.fromStore(Store<AppState> store, ProjectListType projectListType) {
        return ProjectListViewModel(
            status: statusSelector(store.state),
            projects: projectsSelector(store.state, projectListType),
            nextStatus: nextStatusSelector(store.state, projectListType),
            currentPage: currentPageSelector(store.state, projectListType),
            hasNext: hasNextSelector(store.state, projectListType),
            refreshProjects: (){
                store.dispatch(RefreshProjectsAction());
            },
            fetchNextProjects: (int nextPage){
                store.dispatch(FetchNextProjectsAction(projectListType: projectListType, nextPage: nextPage));
            }
        );
    }

    @override
    String toString() {
        return 'ProjectListViewModel{projects: $projects, status: $status}';
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is ProjectListViewModel &&
                runtimeType == other.runtimeType &&
                projects == other.projects &&
                status == other.status;

    @override
    int get hashCode =>
        projects.hashCode ^
        status.hashCode;
}