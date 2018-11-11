import 'package:flutter/material.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/common_actions.dart';
import 'package:flutter_igit/ui/main_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class App extends StatefulWidget {
    final Store<AppState> store;
    final WidgetBuilder devDrawerBuilder;

    App({
        @required this.store,
        this.devDrawerBuilder
    });

    @override
    _AppState createState() => _AppState();
}

class _AppState extends State<App> {

    @override
    void initState() {
        super.initState();
        widget.store.dispatch(InitAction());
    }

    @override
    Widget build(BuildContext context) {
        return StoreProvider(
            store: widget.store,
            child: new MaterialApp(
                title: 'Flutter igit',
                theme: new ThemeData(
                    primaryColor: const Color(0xFF1C306D),
                    accentColor: const Color(0xFFFFAD32),
                ),
                home: MainPage(
                    devDrawerBuilder: widget.devDrawerBuilder
                ),
            ),
        );
    }
}
