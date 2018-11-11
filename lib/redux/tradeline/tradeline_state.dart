import 'package:flutter_igit/models/tradeline.dart';
import 'package:meta/meta.dart';


class TradelineState {

    final Tradeline current;
    final List<Tradeline> tradelines;

    TradelineState({
        @required this.current,
        @required this.tradelines
    });

    static initial() {
        return TradelineState(
            current: null,
            tradelines: <Tradeline>[]
        );
    }

    TradelineState copyWith({
        Tradeline current,
        List<Tradeline> tradelines
    }) {
        return TradelineState(
            current: current ?? this.current,
            tradelines: tradelines ?? this.tradelines
        );
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is TradelineState &&
                runtimeType == other.runtimeType &&
                current == other.current &&
                tradelines == other.tradelines;

    @override
    int get hashCode =>
        current.hashCode ^
        tradelines.hashCode;

    @override
    String toString() {
        return 'TradelineState{current: $current, tradelines: $tradelines}';
    }


}