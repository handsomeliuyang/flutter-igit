import 'package:flutter/material.dart';
import 'package:flutter_igit/App.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/store.dart';

void main() async {
    DevToolsStore<AppState> store = await createDevToolsStore();

    runApp(ReduxDevToolsContainer(
        store: store,
        child: App(
            store: store,
            devDrawerBuilder:(context) {
                return new Drawer(
                    child: new Padding(
                        padding: new EdgeInsets.only(top: 24.0),
                        child: new ReduxDevTools(store),
                    ),
                );
            },
        ),
    ));
}

