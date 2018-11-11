import 'dart:async';
import 'package:flutter_igit/networking/igit_api.dart';
import 'package:redux/redux.dart';
import 'package:flutter/services.dart';

import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/app/app_reducer.dart';
import 'package:flutter_igit/redux/tradeline/tradeline_middleware.dart';
import 'package:flutter_igit/redux/permission/permission_middleware.dart';
import 'package:flutter_igit/networking/permission_api.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_igit/redux/project/project_middleware.dart';

Future<Store<AppState>> createStore() async {

    PermissionApi permissionApi = PermissionApi();
    IgitApi igitApi = IgitApi();

    return Store<AppState>(
        appReducer,
        initialState: AppState.initial(),
        distinct: true,
        middleware: [
            TradelineMiddleware(rootBundle),
            PermissionMiddleware(permissionApi, igitApi),
            ProjectMiddleware(igitApi),
        ]
    );
}

Future<Store<AppState>> createDevToolsStore() async {

    PermissionApi permissionApi = PermissionApi();
    IgitApi igitApi = IgitApi();

    return DevToolsStore<AppState>(
        appReducer,
        initialState: AppState.initial(),
        distinct: true,
        middleware: [
            TradelineMiddleware(rootBundle),
            PermissionMiddleware(permissionApi, igitApi),
            ProjectMiddleware(igitApi),
        ]
    );
}
