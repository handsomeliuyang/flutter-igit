import 'package:flutter_igit/models/tradeline.dart';
import 'package:meta/meta.dart';


class InitAction {}

class InitCompleteAction {
    final Tradeline selectedTradeline;
    final List<Tradeline> tradelines;

    InitCompleteAction({
        @required this.selectedTradeline,
        @required this.tradelines
    });

    @override
    String toString() {
        return 'InitCompleteAction{selectedTradeline: $selectedTradeline, tradelines: $tradelines}';
    }
}

class ChangeCurrentTradelineAction {
    final Tradeline selectedTradeline;

    ChangeCurrentTradelineAction({
        @required this.selectedTradeline
    });

    @override
    String toString() {
        return 'ChangeCurrentTradelineAction{selectedTradeline: $selectedTradeline}';
    }
}

class InitProjectsAction {}