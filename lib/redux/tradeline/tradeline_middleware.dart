import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter/services.dart';

import 'package:flutter_igit/redux/app/app_state.dart';
import 'package:flutter_igit/redux/common_actions.dart';
import 'package:flutter_igit/models/tradeline.dart';
import 'package:flutter_igit/assets.dart';
import 'package:flutter_igit/networking/tradeline_parser.dart';

class TradelineMiddleware extends MiddlewareClass<AppState> {
    
    final AssetBundle bundle;
    
    TradelineMiddleware(this.bundle);

    @override
    Future<Null> call(Store<AppState> store, action,
        NextDispatcher next) async {
        if (action is InitAction) {
            await _init(action, next);
        } else {
            next(action);
        }
    }

    Future<Null> _init(InitAction action, NextDispatcher next) async {
        String tradelineJson = await bundle.loadString(OtherAssets.preloadedTradelines);

        List<Tradeline> tradelines = TradelineParser.parser(tradelineJson);
        Tradeline selectedTradeline = null;
        if(tradelines != null && tradelines.length > 0) {
            selectedTradeline = tradelines[0];
        }

        next(InitCompleteAction(
            selectedTradeline:selectedTradeline,
            tradelines: tradelines
        ));
    }

}