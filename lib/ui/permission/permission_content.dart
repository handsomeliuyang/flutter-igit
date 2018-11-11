import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/models/loading_status.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/common_actions.dart';
import 'package:flutter_igit/ui/project_list/project_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

typedef String ValueToString<T>(T value);
typedef Widget ItemBodyBuilder<T>(BuildContext context, PanelItem<T> item);

class DualHeaderWithHint extends StatelessWidget {
    const DualHeaderWithHint({
        this.name,
        this.value,
        this.hint,
        this.showHint
    });

    final String name;
    final String value;
    final String hint;
    final bool showHint;

    Widget _crossFade(Widget first, Widget second, bool isExpanded) {
        return new AnimatedCrossFade(
            firstChild: first,
            secondChild: second,
            firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
            secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
            sizeCurve: Curves.fastOutSlowIn,
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
        );
    }

    @override
    Widget build(BuildContext context) {
        final ThemeData theme = Theme.of(context);
        final TextTheme textTheme = theme.textTheme;

        return new Row(
            children: <Widget>[
                new Expanded(
                    flex: 2,
                    child: new Container(
                        margin: const EdgeInsets.only(left: 24.0),
                        child: new FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: new Text(
                                name,
                                style: textTheme.body1.copyWith(fontSize: 15.0),
                            ),
                        ),
                    ),
                ),
                new Expanded(
                    flex: 3,
                    child: new Container(
                        margin: const EdgeInsets.only(left: 24.0),
                        child: _crossFade(
                            new Text(value, style: textTheme.caption.copyWith(
                                fontSize: 15.0)),
                            new Text(hint, style: textTheme.caption.copyWith(
                                fontSize: 15.0)),
                            showHint
                        )
                    )
                )
            ]
        );
    }
}

class CollapsibleBody extends StatelessWidget {
    const CollapsibleBody({
        this.margin = EdgeInsets.zero,
        this.child,
        this.saveBtnName,
        this.onSave,
        this.cancelBtnName,
        this.onCancel
    });

    final EdgeInsets margin;
    final Widget child;
    final String saveBtnName;
    final VoidCallback onSave;
    final String cancelBtnName;
    final VoidCallback onCancel;

    @override
    Widget build(BuildContext context) {
        final ThemeData theme = Theme.of(context);
        final TextTheme textTheme = theme.textTheme;

        return new Column(
            children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: 24.0
                    ) - margin,
                    child: new Center(
                        child: new DefaultTextStyle(
                            style: textTheme.caption.copyWith(fontSize: 15.0),
                            child: child
                        )
                    )
                ),
                const Divider(height: 1.0),
                new Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                            new Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                child: new FlatButton(
                                    onPressed: onCancel,
                                    child: Text(cancelBtnName != null ? cancelBtnName : '取消', style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500
                                    ))
                                )
                            ),
                            new Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                child: new FlatButton(
                                    onPressed: onSave,
                                    textTheme: ButtonTextTheme.accent,
                                    child: Text(saveBtnName != null ? saveBtnName : '保存')
                                )
                            )
                        ]
                    )
                )
            ]
        );
    }
}

class PanelItem<T> {
    final String name;
    final String hint;
    final TextEditingController textController;
    final ValueToString<T> valueToString;
    final ItemBodyBuilder<T> bodyBuilder;
    T value;
    bool isExpanded = false;

    PanelItem({
        this.name,
        this.value,
        this.hint,
        this.valueToString,
        this.bodyBuilder
    }) : textController = new TextEditingController(text: valueToString(value));

    ExpansionPanelHeaderBuilder get headerBuilder {
        debugPrint('liuyang headerBuilder ${value}');

        return (BuildContext context, bool isExpanded) {
            return new DualHeaderWithHint(
                name: name,
                value: valueToString(value),
                hint: hint,
                showHint: isExpanded
            );
        };
    }

    Widget build(BuildContext context) => bodyBuilder(context, this);
}

class PermissionContent extends StatefulWidget {
    final List<GitProject> projects;
    final List<GitUser> users;
    final Function addGitProject;
    final Function deleteGitProject;
    final Function getUserIdByName;
    final Function deleteGitUser;
    final Function allocationPermission;

    const PermissionContent({
        @required this.projects,
        @required this.users,
        @required this.addGitProject,
        @required this.deleteGitProject,
        @required this.getUserIdByName,
        @required this.deleteGitUser,
        @required this.allocationPermission
    });

    @override
    _PermissionContentState createState() => _PermissionContentState();
}

class _PermissionContentState extends State<PermissionContent> {
    static const Map<String, String> ACCESS_LEVEL = {
        '30': 'Developer',
        '10': 'Guest',
        '20': 'Reporter',
        '40': 'Master'
    };

    List<PanelItem> _panelItems;
    PanelItem _userPanelItem;
    PanelItem _rolePanelItem;
    PanelItem _projectPanelItem;

    @override
    void initState() {
        super.initState();
        _userPanelItem = _initUserPanelItem();
        _rolePanelItem = _initRolePanelItem();
        _projectPanelItem = _initProjectPanelItem();
        _panelItems = <PanelItem>[
            _userPanelItem,
            _rolePanelItem,
            _projectPanelItem
        ];
    }

    @override
    void didUpdateWidget(PermissionContent oldWidget) {
        super.didUpdateWidget(oldWidget);
        // 更新数据
        _projectPanelItem.value = widget.projects;
        _userPanelItem.value = widget.users;
    }

    void _navigatorProjectPage(BuildContext context) async {
        Store<AppState> store = StoreProvider.of<AppState>(context);
        store.dispatch(InitProjectsAction());

        final GitProject selectProject = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProjectPage())
        );

        if(selectProject != null) {
            widget.addGitProject(selectProject);
        }
    }

    PanelItem _initUserPanelItem() {
        return PanelItem<List<GitUser>>(
            name: 'OA账号',
            value: widget.users,
            hint: '填写OA账号',
            valueToString: (List<GitUser> list){
                return list.map((user)=>user.username).join(',');
            },
            bodyBuilder: (BuildContext context, PanelItem<List<GitUser>> item) {
                void close() {
                    setState(() {
                        item.isExpanded = false;
                    });
                }

                List<GitUser> users = widget.users;
                debugPrint('liuyang users=${users}');

                List<Widget> listTiles = <Widget>[];
                for (int i = 0; i < users.length; i++) {
                    final GitUser user = users[i];

                    listTiles.add(ListTile(
                        leading: ExcludeSemantics(child: new CircleAvatar(
                            child: new Text((i + 1).toString()))),
                        title: Text(user.username),
                        trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: (){
                                widget.deleteGitUser(user);
                            },
                        ),
                        dense: false
                    ));
                }
                listTiles = ListTile.divideTiles(
                    context: context, tiles: listTiles.map((widget) => widget))
                    .toList();

                return Form(
                    child: Builder(
                        builder: (BuildContext context) {
                            return CollapsibleBody(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                onSave: () {
                                    Form.of(context).save();
                                    close();
                                },
                                onCancel: () {
                                    Form.of(context).reset();
                                    close();
                                },
                                child: Column(
                                    children: <Widget>[
                                        const SizedBox(height: 10.0),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                                Container(
                                                    width: 200.0,
                                                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                    child: TextField(
                                                        controller: item.textController,
                                                        decoration: new InputDecoration(
                                                            hintText: item.hint,
                                                        ),
                                                    ),
                                                ),
                                                IconButton(
                                                    icon: Icon(Icons.add, color: Colors.red),
                                                    onPressed: (){
                                                        if(item.textController.text.isEmpty){
                                                            return ;
                                                        }

                                                        Completer<GitUser> completer = Completer<GitUser>();
                                                        widget.getUserIdByName(completer, item.textController.text);

                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (BuildContext context){
                                                                return Dialog(
                                                                    child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                            CircularProgressIndicator(),
                                                                            Text("Loading"),
                                                                        ],
                                                                    ),
                                                                );
                                                            }
                                                        );
                                                        completer.future.then((user){
                                                            Navigator.pop(context);
                                                            item.textController.text = '';
                                                        }, onError: (e){
                                                            Navigator.pop(context);
                                                        });
                                                    }
                                                )
                                            ],
                                        ),
                                        const SizedBox(height: 20.0),
                                        Column(
                                            children: listTiles,
                                        )
                                    ],
                                ),
//                                child: Padding(
//                                    padding: const EdgeInsets.symmetric(
//                                        horizontal: 16.0),
//                                    child: TextFormField(
//                                        controller: item.textController,
//                                        decoration: new InputDecoration(
//                                            hintText: item.hint,
//                                            labelText: item.name,
//                                        ),
//                                        onSaved: (String value) {
//                                            item.value = value;
//                                        },
//                                    )
//                                ),
                            );
                        }
                    ),
                );
            }
        );
    }

    PanelItem _initRolePanelItem() {
        return PanelItem<String>(
            name: '权限',
            value: ACCESS_LEVEL.keys.toList()[0],
            hint: '请选择权限',
            valueToString: (String key) => ACCESS_LEVEL[key],
            bodyBuilder: (BuildContext context, PanelItem<String> item) {
                void close() {
                    setState(() {
                        item.isExpanded = false;
                    });
                }

                return Builder(
                    builder: (BuildContext context) {
                        return CollapsibleBody(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            onSave: () {
                                close();
                            },
                            onCancel: () {
                                close();
                            },
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: DropdownButton<String>(
                                    value: item.value,
                                    items: ACCESS_LEVEL.keys.map((String key) {
                                        return DropdownMenuItem(
                                            value: key,
                                            child: Text(ACCESS_LEVEL[key])
                                        );
                                    }).toList(),
                                    onChanged: (String newValue) {
                                        setState(() {
                                            item.value = newValue;
                                        });
                                    },
                                ),
                            ),
                        );
                    }
                );
            }
        );
    }

    PanelItem _initProjectPanelItem() {
        debugPrint('liuyang init...');
        return PanelItem<List<GitProject>>(
            name: 'Library列表',
            value: widget.projects,
            hint: '请选择权限',
            valueToString: (List<GitProject> list){
                debugPrint('liuyang length: ${list.length}');
                return list.length.toString();
            },
            bodyBuilder: (BuildContext context, PanelItem<List<GitProject>> item) {
                debugPrint('liuyang item bodyBuilder ${widget.projects}');

                void close() {
                    setState(() {
                        item.isExpanded = false;
                    });
                }

                List<GitProject> projects = widget.projects;

                List<Widget> listTiles = <Widget>[];
                for (int i = 0; i < projects.length; i++) {
                    final GitProject gitProject = projects[i];

                    listTiles.add(ListTile(
                        leading: ExcludeSemantics(child: new CircleAvatar(
                            child: new Text((i + 1).toString()))),
                        title: Text(gitProject.name),
                        trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: (){
                                widget.deleteGitProject(gitProject);
                            },
                        ),
                        dense: false
                    ));
                }
                listTiles = ListTile.divideTiles(
                    context: context, tiles: listTiles.map((widget) => widget))
                    .toList();

                return Builder(
                    builder: (BuildContext context) {
                        return CollapsibleBody(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            saveBtnName: '添加',
                            onSave: () {
                                _navigatorProjectPage(context);

                            },
                            onCancel: () {
                                close();
                            },
                            child: Column(
                                children: listTiles
                            ),
                        );
                    }
                );
            }
        );
    }

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                    children: <Widget>[
                        Container(
                            margin: const EdgeInsets.all(24.0),
                            child: ExpansionPanelList(
                                expansionCallback: (int index,
                                    bool isExpanded) {
                                    setState(() {
                                        _panelItems[index].isExpanded =
                                        !isExpanded;
                                    });
                                },
                                children: _panelItems.map((PanelItem item) {
                                    debugPrint('liuyang children ExpansionPanel');
                                    return ExpansionPanel(
                                        isExpanded: item.isExpanded,
                                        headerBuilder: item.headerBuilder,
                                        body: item.build(context)
                                    );
                                }).toList(),
                            ),
                        ),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 24.0, right: 24.0, bottom: 24.0),
                            child: RaisedButton(
                                onPressed: () {
                                    List<GitUser> users = widget.users;
                                    String level = _rolePanelItem.value;
                                    List<GitProject> projects = widget.projects;

                                    if(users.isEmpty || projects.isEmpty) {
                                        return ;
                                    }

                                    Completer<bool> completer = Completer<bool>();
                                    widget.allocationPermission(completer, users, level, projects);

                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context){
                                            return Dialog(
                                                child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                        CircularProgressIndicator(),
                                                        Text("Loading"),
                                                    ],
                                                ),
                                            );
                                        }
                                    );
                                    completer.future.then((user){
                                        Navigator.pop(context);

                                        Scaffold.of(context).showSnackBar(new SnackBar(
                                            content: new Text("权限分配成功"),
                                        ));

                                    }, onError: (e){
                                        Navigator.pop(context);

                                        Scaffold.of(context).showSnackBar(new SnackBar(
                                            content: new Text("权限分配失败 ${e}"),
                                        ));
                                    });
                                },
                                child: const Text('分配权限'),
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                textColor: Colors.white,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

}

