import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_igit/ui/tradeline_list/tradeline_list.dart';
import 'package:flutter_igit/ui/tradeline_list/tradeline_list_header.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/models/tradeline.dart';
import 'package:flutter_igit/ui/permission/permission_page.dart';

class MainPage extends StatefulWidget {
    final WidgetBuilder devDrawerBuilder;

    MainPage({
        this.devDrawerBuilder
    });

    @override
    _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MainPage> {

    Widget _buildTitle(BuildContext context) {
        return StoreConnector<AppState, Tradeline>(
            distinct: true,
            converter: (store) => store.state.tradelineState.current,
            builder: (BuildContext context, Tradeline currentTradeline) {
                return Text(
                    '分配 ${currentTradeline?.name ?? ''} 的igit权限'
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(title: _buildTitle(context)),
            drawer: Drawer(
                child: DrawList(
                    header: DrawListHeader()
                ),
            ),
            endDrawer: widget.devDrawerBuilder != null ? widget.devDrawerBuilder(context) : null,
            body: PermissionPage(),
        );
    }

}