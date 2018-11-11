import 'package:flutter/material.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/common_actions.dart';
import 'package:flutter_igit/redux/project/project_action.dart';
import 'package:flutter_igit/ui/project_list/project_list_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ProjectPage extends StatefulWidget {

    @override
    _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {

    TabController _tabController;
    TextEditingController _searchQuery;
    bool _isSearching = false;

    @override
    void initState() {
        super.initState();

        _tabController = TabController(length: 2, vsync: this);
        _searchQuery = TextEditingController();
    }

    _startSearch(){
        var store = StoreProvider.of<AppState>(context);
        store.dispatch(SearchQueryAction(_searchQuery.text));
    }


    Widget _buildBackButton(){
        return IconButton(
            icon: const BackButtonIcon(),
            color: Colors.white,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
                if(_isSearching) {
                    _searchQuery.text = '';
                    _startSearch();
                    setState(() {
                      _isSearching = false;
                    });
                    return ;
                }
                Navigator.maybePop(context);
            }
        );
    }

    Widget _buildSearchField() {
        return TextField(
            controller: _searchQuery,
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Search movies & showtimes...',
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.white30),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
//            onChanged: _updateSearchQuery,
        );
    }

    List<Widget> _buildActions() {
        if (_isSearching) {
            return <Widget>[
                IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                        if (_searchQuery == null || _searchQuery.text.isEmpty) {
                            // Stop searching.
                            Navigator.pop(context);
                            return;
                        }
                        _startSearch();
                    },
                ),
            ];
        }

        return <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: (){
                    setState(() {
                        _isSearching = true;
                    });
                },
            ),
        ];
    }

    @override
    Widget build(BuildContext context) {
        Store<AppState> store = StoreProvider.of<AppState>(context);
        _searchQuery.text = store.state.projectState.search;
        if(_searchQuery.text.isNotEmpty) {
            _isSearching = true;
        }

        debugPrint('liuyang _isSearching=${_isSearching}');

        return Scaffold(
            appBar: AppBar(
                leading: _buildBackButton(),
                title: _isSearching ? _buildSearchField() : Text('项目列表'),
                actions: _buildActions(),
                bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: const <Tab>[
                        const Tab(text: 'Groups'),
                        const Tab(text: 'Projects')
                    ]
                ),

            ),
            body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                    ProjectListPage(
                        projectListType: ProjectListType.groups,
                    ),
                    ProjectListPage(
                        projectListType: ProjectListType.projects,
                    )
                ]
            )
        );
    }

}