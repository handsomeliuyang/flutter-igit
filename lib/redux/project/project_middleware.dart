import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/networking/igit_api.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/common_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_igit/redux/project/project_action.dart';

class ProjectMiddleware extends MiddlewareClass<AppState> {

    final IgitApi igitApi;

    ProjectMiddleware(this.igitApi);

    @override
    void call(Store<AppState> store, action, NextDispatcher next) async {
        debugPrint('liuyang project_middleware action=${action.toString()}');

        // 页面初始加载与重试
        if (action is InitProjectsAction ||
            action is RefreshProjectsAction) {

            await _fetchInitProjects(next, store.state.projectState.search);
        } else if(action is SearchQueryAction){
            next(action);

            await _fetchInitProjects(next, action.search);
        } else if (action is FetchNextProjectsAction ||
            action is RefreshNextAction) {
            await _fetchNextProjects(next, action.projectListType, action.nextPage, store.state.projectState.search);
        } else {
            next(action);
        }
    }

    Future<Null> _fetchInitProjects(NextDispatcher next, String search) async {
        next(RequestingProjectsAction());

        try {
            List<GitProject> groups = await igitApi.getGroups(1, search);
            bool hasNextInAllGroups = true;
            if(groups.length < IgitApi.PER_PAGE) {
                hasNextInAllGroups = false;
            }

            List<GitProject> projects = await igitApi.getProjects(1, search);
            bool hasNextInAllProjects = true;
            if(projects.length < IgitApi.PER_PAGE) {
                hasNextInAllProjects = false;
            }

            next(ReceivedProjectsAction(
                allGroups: groups,
                nextStatusInAllGroups: LoadingStatus.success,
                currentPageInAllGroups: 1,
                hasNextInAllGroups: hasNextInAllGroups,

                allProjects: projects,
                nextStatusInAllProjects: LoadingStatus.success,
                currentPageInAllProjects: 1,
                hasNextInAllProjects: hasNextInAllProjects
            ));
        } catch (e) {
            debugPrint('liuyang error _fetchInitProjects ${e}');
            next(ErrorLoadingProjectsAction());
        }
    }

    Future<Null> _fetchNextProjects(NextDispatcher next, ProjectListType projectListType, int nextPage, String search) async {
        next(RequestingNextAction(
            projectListType: projectListType
        ));

        try {

            List<GitProject> gitProjects = <GitProject>[];
            if(projectListType == ProjectListType.groups){
                gitProjects = await igitApi.getGroups(nextPage, search);
            } else if(projectListType == ProjectListType.projects){
                gitProjects = await igitApi.getProjects(nextPage, search);
            }

            bool hasNext = true;
            if(gitProjects.length < IgitApi.PER_PAGE) {
                hasNext = false;
            }

            next(ReceivedNextAction(
                projectListType: projectListType,
                gitProjects: gitProjects,
                currentPage: nextPage,
                hasNext: hasNext
            ));
        } catch(e){
            debugPrint('liuyang error _fetchNextProjects ${e}');
            next(ErrorLoadingNextAction(
                projectListType: projectListType
            ));
        }
    }

}