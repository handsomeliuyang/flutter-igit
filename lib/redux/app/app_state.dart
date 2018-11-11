import 'package:flutter_igit/redux/project/project_state.dart';
import 'package:flutter_igit/redux/tradeline/tradeline_state.dart';
import 'package:meta/meta.dart';
import 'package:flutter_igit/redux/permission/permission_state.dart';

class AppState {

    final TradelineState tradelineState;
    final PermissionState permissionState;
    final ProjectState projectState;

    AppState({
        @required this.tradelineState,
        @required this.permissionState,
        @required this.projectState
    });

    static initial() {
        return AppState(
            tradelineState: TradelineState.initial(),
            permissionState: PermissionState.initial(),
            projectState: ProjectState.initial()
        );
    }

    @override
    String toString() {
        return 'AppState{tradelineState: $tradelineState, permissionState: $permissionState, projectState: $projectState}';
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is AppState &&
                runtimeType == other.runtimeType &&
                tradelineState == other.tradelineState &&
                permissionState == other.permissionState &&
                projectState == other.projectState;

    @override
    int get hashCode =>
        tradelineState.hashCode ^
        permissionState.hashCode ^
        projectState.hashCode;





}