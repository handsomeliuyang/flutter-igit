import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/tradeline/tradeline_reducer.dart';
import 'package:flutter_igit/redux/permission/permission_reducer.dart';
import 'package:flutter_igit/redux/project/project_reducer.dart';

AppState appReducer(AppState state, dynamic action){
    return new AppState(
        tradelineState: tradelineReducer(state.tradelineState, action),
        permissionState: permissionReducer(state.permissionState, action),
        projectState: projectReducer(state.projectState, action)
    );
}