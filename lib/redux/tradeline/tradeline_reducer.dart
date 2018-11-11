import 'package:redux/redux.dart';

import 'package:flutter_igit/redux/tradeline/tradeline_state.dart';
import 'package:flutter_igit/redux/common_actions.dart';

final tradelineReducer = combineReducers<TradelineState>([
    TypedReducer<TradelineState, InitCompleteAction>(_initComplete),
    TypedReducer<TradelineState, ChangeCurrentTradelineAction>(_changeCurrentTradeline)
]);

TradelineState _initComplete(TradelineState state, InitCompleteAction action){
    return state.copyWith(
        current: action.selectedTradeline,
        tradelines: action.tradelines
    );
}

TradelineState _changeCurrentTradeline(TradelineState state, ChangeCurrentTradelineAction action){
    return state.copyWith(
        current: action.selectedTradeline
    );
}





