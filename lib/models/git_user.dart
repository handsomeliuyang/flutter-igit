import 'dart:async';

import 'package:meta/meta.dart';

class GitUser {
    final int id;
    final String username;

    GitUser({
        @required this.id,
        @required this.username
    });

    factory GitUser.fromJson(Map<String, dynamic> json){
        return GitUser(
            id: json['id'],
            username: json['username']
        );
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is GitUser &&
                runtimeType == other.runtimeType &&
                id == other.id &&
                username == other.username;

    @override
    int get hashCode =>
        id.hashCode ^
        username.hashCode;

    @override
    String toString() {
        return 'GitUser{id: $id, username: $username}';
    }


}