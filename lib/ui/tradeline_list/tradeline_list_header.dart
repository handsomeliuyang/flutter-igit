import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawListHeader extends StatefulWidget {

  @override
  _DrawListHeaderState createState() => _DrawListHeaderState();

}

class _DrawListHeaderState extends State<DrawListHeader> {
    static const String liuyangUrl = "https://handsomeliuyang.github.io/";
    static const TextStyle linkStyle = const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
    );

    TapGestureRecognizer _liuyangTapRecongnizer;

    @override
    void initState() {
        _liuyangTapRecongnizer = TapGestureRecognizer()
            ..onTap = () => _openUrl(liuyangUrl);
    }

    _openUrl(String url) async {
        Navigator.pop(context);

        if(await canLaunch(url)){
            await launch(url);
        }
    }

    @override
    void dispose() {
        _liuyangTapRecongnizer.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            color: Theme.of(context).primaryColor,
            constraints: BoxConstraints.expand(height: 175.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                    _buildAppNameAndVersion(context),
                    _buildAboutButton(context)
                ],
            ),
        );
    }

    Widget _buildAppNameAndVersion(BuildContext context) {
        var textTheme = Theme.of(context).textTheme;

        return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text(
                        'Igit',
                        style: textTheme.display1.copyWith(color: Colors.white70),
                    ),
                    Text(
                        'v1.0.0',
                        style: textTheme.body2.copyWith(color: Colors.white),
                    )
                ],
            ),
        );
    }

    Widget _buildAboutButton(BuildContext context) {
        var content = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Icon(
                    Icons.info_outline,
                    color: Colors.white70,
                    size: 18.0,
                ),
                SizedBox(width: 8.0),
                Text(
                    '关于',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.0
                    ),
                )
            ],
        );

        return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: (){
                    showDialog<Null>(
                        context: context,
                        builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('关于 Igit'),
                                content: RichText(
                                    text: TextSpan(
                                        text: 'Igit是一个用于分配权限的工具，用于分配业务线与无线的权限',
                                        style: const TextStyle(color: Colors.black87),
                                        children: <TextSpan>[
                                            TextSpan(
                                                text: 'Liuyang',
                                                recognizer: _liuyangTapRecongnizer,
                                                style: linkStyle
                                            )
                                        ]
                                    )
                                ),
                                actions: <Widget>[
                                    FlatButton(
                                        onPressed: (){
                                            Navigator.of(context).pop();
                                        },
                                        textColor: Theme.of(context).primaryColor,
                                        child: const Text("确认"),
                                    )
                                ],
                            );
                        }
                    );
                },
                child:  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: content,
                ),
            ),
        );
    }





}