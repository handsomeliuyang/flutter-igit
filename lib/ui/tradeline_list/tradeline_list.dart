import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_igit/models/tradeline.dart';
import 'package:flutter_igit/ui/tradeline_list/tradeline_list_view_model.dart';
import 'package:flutter_igit/redux/app/app_state.dart';


class DrawList extends StatelessWidget {
    final Widget header;

    DrawList({
        @required this.header
    });

    @override
    Widget build(BuildContext context) {
        return StoreConnector<AppState, DrawListViewModel> (
            distinct: true,
            converter: (store) => DrawListViewModel.fromStore(store),
            builder: (context, viewModel){
                return DrawListContent(
                    header: this.header,
                    viewModel: viewModel,
                );
            },
        );
    }

}

class DrawListContent extends StatelessWidget {

    final Widget header;
    final DrawListViewModel viewModel;

    DrawListContent({
        @required this.header,
        @required this.viewModel
    });

    @override
    Widget build(BuildContext context) {
        return ListView.builder(
            itemCount: this.viewModel.tradelines.length + 1,
            itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                    return this.header;
                }

                Tradeline tradeline = this.viewModel.tradelines[index - 1];
                bool isSelected = this.viewModel.currentTradeline.name ==
                    tradeline.name;
                var backgroundColor = isSelected
                    ? const Color(0xFFEEEEEE)
                    : Theme
                    .of(context)
                    .canvasColor;

                return Material(
                    color: backgroundColor,
                    child: ListTile(
                        onTap: () {
                            viewModel.changeCurrentTradeline(tradeline);
                            Navigator.pop(context);
                        },
                        selected: isSelected,
                        title: Text(tradeline.name),
                    ),
                );
            }
        );
    }

}