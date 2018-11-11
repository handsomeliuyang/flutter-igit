import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/networking/igit_api.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:redux/redux.dart';

import 'package:flutter_igit/redux/common_actions.dart';
import 'package:flutter_igit/redux/permission/permission_action.dart';
import 'package:flutter_igit/networking/permission_api.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/tradeline.dart';

class PermissionMiddleware extends MiddlewareClass<AppState> {

    final PermissionApi permissionApi;
    final IgitApi igitApi;

    PermissionMiddleware(this.permissionApi, this.igitApi);

    @override
    void call(Store<AppState> store, action, NextDispatcher next) async {
        debugPrint('liuyang permission_middleware action=${action.toString()}');

        if (action is InitCompleteAction ||
            action is ChangeCurrentTradelineAction ||
            action is RefreshPermissionAction) {

            next(action);

            Tradeline tradeline;
            if(action is RefreshPermissionAction) {
                tradeline = store.state.tradelineState.current;
            } else {
                tradeline = action.selectedTradeline;
            }

            debugPrint('liuyang permission middleware ${action} ${tradeline}');

            if (tradeline != null) {
                await _fetchPermission(tradeline, next);
            }
        }
        else if(action is AddGitProject){
            Tradeline tradeline = store.state.tradelineState.current;
            await _savePermission(tradeline, action.project);
            await _fetchPermission(tradeline, next);
        }
        else if(action is DeleteGitProject){
            Tradeline tradeline = store.state.tradelineState.current;
            await _deletePermission(tradeline, action.project);
            await _fetchPermission(tradeline, next);
        }
        else if(action is ConvertOANameAction){
//            Tradeline tradeline = store.state.tradelineState.current;
            await _getUserIdByName(action.completer, action.oaName, next);
        }
        else if(action is AllocationPermissionAction){
            await _allocationPermission(action.completer, action.users, action.level, action.projects);
        }
        else {
            next(action);
        }
    }

    Future<Null> _fetchPermission(Tradeline tradeline, NextDispatcher next) async {
        next(RequestingPermissionAction());

        debugPrint('liuyang permission RequestingPermissionAction');

        try {
            // 从文件缓存中，读取Permission的缓存文件
            List<GitProject> projects = await permissionApi.getGroupsByTradeline(tradeline);

            next(ReceivedPermissionAction(projects: projects));

            debugPrint('liuyang permission ReceivedPermissionAction ${projects}');
        } catch (e) {
            debugPrint('liuyang error _fetchPermission ${e}');
            next(ErrorLoadingPermissionAction());
        }
    }

    Future<Null> _savePermission(Tradeline tradeline, GitProject project) async {
        try {
            // 从文件缓存中，读取Permission的缓存文件
            await permissionApi.saveGitProjectByTradeline(tradeline, project);
        } catch (e) {
            debugPrint('liuyang error _savePermission ${e}');
        }
    }

    Future<Null> _deletePermission(Tradeline tradeline, GitProject project) async {
        try {
            // 从文件缓存中，读取Permission的缓存文件
            await permissionApi.deleteGitProjectByTradeline(tradeline, project);
        } catch (e) {
            debugPrint('liuyang error _deletePermission ${e}');
        }
    }

    Future<Null> _getUserIdByName(Completer completer, String oaName, NextDispatcher next) async {
        try {
            // 从文件缓存中，读取Permission的缓存文件
            GitUser user = await igitApi.getUserIdByName(oaName);

            next(ReceivedUserAction(user: user));
            completer.complete(user);
        } catch (e) {
            debugPrint('liuyang error _getUserIdByName ${e}');
            completer.completeError('error ${e}');
        }

    }

    Future<Null> _allocationPermission(Completer completer, List<GitUser> users, String level, List<GitProject> projects) async {

        try {
            for(GitUser user in users){
                for(GitProject project in projects){
                    bool result = await igitApi.addMember(user, project, level);
                    if(!result) {
                        completer.completeError('error in ${project.name} add member ${user.username}');
                        return ;
                    }
                }
            }

            completer.complete(true);
        } catch (e) {
            debugPrint('liuyang error _allocationPermission ${e}');
            completer.completeError('error ${e}');
        }

    }
}

