import 'dart:convert';

import 'package:flutter_igit/models/tradeline.dart';

class TradelineParser {
    static List<Tradeline> parser(String jsonStr){
        List<Tradeline> tradelines = List<Tradeline>();

        List list = json.decode(jsonStr);
        list.forEach((item){
            Tradeline tradeline = Tradeline.fromJson(item);
            tradelines.add(tradeline);
        });

        return tradelines;
    }
}