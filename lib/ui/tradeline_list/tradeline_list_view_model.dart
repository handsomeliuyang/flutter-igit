import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:flutter_igit/models/tradeline.dart';
import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/tradeline/tradeline_selectors.dart';
import 'package:flutter_igit/redux/common_actions.dart';

class DrawListViewModel {
    final Tradeline currentTradeline;
    final List<Tradeline> tradelines;
    final Function(Tradeline) changeCurrentTradeline;

    DrawListViewModel({
        @required this.currentTradeline,
        @required this.tradelines,
        @required this.changeCurrentTradeline
    });

    static DrawListViewModel fromStore(Store<AppState> store){
        return DrawListViewModel(
            currentTradeline: currentTradelineSelector(store.state),
            tradelines: tradelinesSelector(store.state),
            changeCurrentTradeline: (Tradeline tradeline){
                store.dispatch(ChangeCurrentTradelineAction(
                    selectedTradeline: tradeline
                ));
            }
        );
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is DrawListViewModel &&
                runtimeType == other.runtimeType &&
                currentTradeline == other.currentTradeline &&
                tradelines == other.tradelines;

    @override
    int get hashCode =>
        currentTradeline.hashCode ^
        tradelines.hashCode;
}