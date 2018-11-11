import 'package:flutter_igit/redux/app/app_state.dart';

import 'package:flutter_igit/models/tradeline.dart';

Tradeline currentTradelineSelector(AppState state){
    return state.tradelineState.current;
}

List<Tradeline> tradelinesSelector(AppState state){
    return state.tradelineState.tradelines;
}