import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/ui/common/info_message_view.dart';
import 'package:flutter_igit/ui/common/loading_view.dart';
import 'package:flutter_igit/ui/common/platform_adaptive_progress_indicator.dart';
import 'package:flutter_igit/ui/project_list/project_list_view_model.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProjectListPage extends StatelessWidget {

    final ProjectListType projectListType;

    ProjectListPage({
        @required this.projectListType,
    });

    @override
    Widget build(BuildContext context) {
        return StoreConnector<AppState, ProjectListViewModel>(
            converter: (store) => ProjectListViewModel.fromStore(store, this.projectListType),
            builder: (BuildContext context, ProjectListViewModel viewModel) {
                return ProjectListWrap(projectListViewModel: viewModel);
            }
        );
    }
}

class ProjectListWrap extends StatelessWidget {

    final ProjectListViewModel projectListViewModel;

    ProjectListWrap({
        this.projectListViewModel
    });

    @override
    Widget build(BuildContext context) {
        return LoadingView(
            status: projectListViewModel.status,
            loadingContent: PlatformAdaptiveProgressIndicator(),
            errorContent: ErrorView(
                description: '加载出错',
                onRetry: projectListViewModel.refreshProjects,
            ),
            successContent: ProjectListContent(
                projects: projectListViewModel.projects,
                nextState: projectListViewModel.nextStatus,
                currentPage: projectListViewModel.currentPage,
                hasNext: projectListViewModel.hasNext,
                refreshProjects: projectListViewModel.refreshProjects,
                fetchNextProjects: projectListViewModel.fetchNextProjects,
            ),
        );
    }

}

class ProjectListContent extends StatefulWidget {

    final List<GitProject> projects;
    final LoadingStatus nextState;
    final int currentPage;
    final bool hasNext;
    final Function refreshProjects;
    final Function fetchNextProjects;

    ProjectListContent({
        @required this.projects,
        @required this.nextState,
        @required this.currentPage,
        @required this.hasNext,
        @required this.refreshProjects,
        @required this.fetchNextProjects
    });

    @override
    State<StatefulWidget> createState() => _ProjectListContentState();
}

class _ProjectListContentState extends State<ProjectListContent> {

    final ScrollController scrollController = ScrollController();

    @override
    void initState() {
        super.initState();

        scrollController.addListener(_scrollListener);
    }

    @override
    void dispose() {
        scrollController.removeListener(_scrollListener);

        scrollController.dispose();
        super.dispose();
    }

    void _scrollListener() {
        if (scrollController.position.extentAfter < 64 * 3) {
            debugPrint('liuyang load next page。。。');
            if(widget.nextState == LoadingStatus.success && widget.hasNext){
                widget.fetchNextProjects(widget.currentPage + 1);
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scrollbar(
            child: ListView.builder(
                controller: scrollController,
                padding: new EdgeInsets.all(8.0),
                itemCount: widget.projects.length + 1,
                itemBuilder: (BuildContext context, int index) {
                    // 加载中... // 完成... // 出错
                    if (index == widget.projects.length) {
                        return Container(
                            color: Colors.black26,
                            height: 60.0,
                            child: Center(
                                child: _nextStateToText(),
                            )
                        );
                    }

                    GitProject project = widget.projects[index];
                    if (project == null) {
                        project = GitProject(projectType: null, name: '', id: -1);
                    }
                    return ListTile(
                        leading: ExcludeSemantics(child: new CircleAvatar(
                            child: new Text((index+1).toString()))),
                        title: Text('${project.name}'),
                        trailing: Icon(Icons.info, color: Theme
                            .of(context)
                            .disabledColor),
                        dense: false,
                        onTap: () {
                            Navigator.pop(context, project);
                        }
                    );
                },
            )
        );
    }

    Widget _nextStateToText() {
        if(!widget.hasNext) {
            return Text('加载成功，已无下一页');
        }

        if(widget.nextState == LoadingStatus.error){
            return Text('加载失败，滑动重新加载');
        }

        return Text('加载中...');
    }

}