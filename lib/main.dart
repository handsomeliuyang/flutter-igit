import 'package:flutter/material.dart';
import 'package:flutter_igit/App.dart';
import 'package:redux/redux.dart';

import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/store.dart';

void main() async {
    Store<AppState> store = await createStore();

    runApp(App(
        store: store
    ));
}

