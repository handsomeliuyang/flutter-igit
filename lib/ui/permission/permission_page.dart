import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/ui/permission/permission_page_view_model.dart';
import 'package:flutter_igit/ui/common/loading_view.dart';
import 'package:flutter_igit/ui/common/platform_adaptive_progress_indicator.dart';
import 'package:flutter_igit/ui/common/info_message_view.dart';
import 'package:flutter_igit/ui/permission/permission_content.dart';

class PermissionPage extends StatelessWidget {

    const PermissionPage();

    @override
    Widget build(BuildContext context) {
        return StoreConnector<AppState, PermissionPageViewModel>(
            distinct: true,
            converter: (store) => PermissionPageViewModel.fromStore(store),
            builder: (BuildContext context, PermissionPageViewModel viewModel) {
                return PermissionPageContent(
                    viewModel: viewModel,
                );
            },
        );
    }

}

class PermissionPageContent extends StatelessWidget {

    final PermissionPageViewModel viewModel;

    PermissionPageContent({
        @required this.viewModel
    });

    @override
    Widget build(BuildContext context) {
        debugPrint('liuyang PermissionPageContent build');
        return LoadingView(
            status: viewModel.status,
            loadingContent: PlatformAdaptiveProgressIndicator(),
            errorContent: ErrorView(
                description: '加载出错',
                onRetry: viewModel.refreshPermission,
            ),
            successContent: PermissionContent(
                projects: viewModel.projects,
                users: viewModel.users,
                addGitProject: viewModel.addGitProject,
                deleteGitProject: viewModel.deleteGitProject,
                getUserIdByName: viewModel.getUserIdByName,
                deleteGitUser: viewModel.deleteGitUser,
                allocationPermission: viewModel.allocationPermission
            )
        );
    }
}