

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/Config.dart';

class IgitApi {

    static final String AUTHORITY = 'igit.58corp.com';
    static final String FIXED_PATH = "/api/v4";
    static final int PER_PAGE = 30;

    Future<List<GitProject>> getGroups(int page, String search) async {
        Uri uri = Uri.http(
            AUTHORITY,
            '${FIXED_PATH}/groups',
            <String, String>{
                'private_token': Config.LIUYANG_TOKEN,
                'per_page': PER_PAGE.toString(),
                'all_available': 'true',
                'page':'${page}',
                'search':'com.wuba'
            });

        final response = await http.get(uri.toString());
        final jsonResponse = json.decode(response.body);

        debugPrint('liuyang ${jsonResponse}');

        if(response.statusCode == 200){
            List<GitProject> groups = List<GitProject>();
            for(int i=0; i<jsonResponse.length; i++){
                groups.add(GitProject.fromJson(jsonResponse[i], ProjectType.group));
            }
            return groups;
        } else {
            throw Exception('Failed ${response.statusCode} ${response.body}');
        }
    }

    Future<List<GitProject>> getProjects(int page, String search) async {
        Uri uri = Uri.http(
            AUTHORITY,
            '${FIXED_PATH}/projects',
            <String, String>{
                'private_token': Config.LIUYANG_TOKEN,
                'per_page': PER_PAGE.toString(),
                'visibility':'private',
                'all_available': 'true',
                'page':'${page}',
                'search':search
            });

        final response = await http.get(uri.toString());
        final jsonResponse = json.decode(response.body);

        debugPrint('liuyang ${jsonResponse}');

        if(response.statusCode == 200){
            List<GitProject> groups = List<GitProject>();
            for(int i=0; i<jsonResponse.length; i++){
                groups.add(GitProject.fromJson(jsonResponse[i], ProjectType.project));
            }
            return groups;
        } else {
            throw Exception('Failed ${response.statusCode} ${response.body}');
        }
    }

    Future<GitUser> getUserIdByName(String oaName) async {
        Uri uri = Uri.http(
            AUTHORITY,
            '${FIXED_PATH}/users',
            <String, String>{
                'private_token': Config.LIUYANG_TOKEN,
                'per_page': PER_PAGE.toString(),
                'username': oaName
            });

        final response = await http.get(uri.toString());
        final jsonResponse = json.decode(response.body);

        debugPrint('liuyang getUserIdByName ${jsonResponse}');

        switch (response.statusCode) {
            case 200:
                if (jsonResponse is List && jsonResponse.length > 0) {
                    return GitUser.fromJson(jsonResponse[0]);
                }
                throw Exception('Failed getUserIdByName the User is null');
            default:
                throw Exception('Failed ${response.statusCode} ${response.body}');
        }
    }

    Future<bool> addMember(GitUser user, GitProject project, String level) async {
        if(project.projectType == null) {
            return false;
        }

        Uri uri;
        if(project.projectType == ProjectType.group) {
            uri = Uri.http(
                AUTHORITY,
                '${FIXED_PATH}/groups/${project.id}/members',
                <String, String>{
                    'private_token': Config.LIUYANG_TOKEN,
                });
        } else {
            uri = Uri.http(
                AUTHORITY,
                '${FIXED_PATH}/projects/${project.id}/members',
                <String, String>{
                    'private_token': Config.LIUYANG_TOKEN,
                });
        }


        final response = await http.post(uri.toString(), body: {
            'user_id': user.id.toString(),
            'access_level': level
        });

        debugPrint('liuyang addMember=${response.statusCode} ${response.body}');

        switch(response.statusCode){
            case 201:
                return true;
            case 409:
                // Member already exists
                return true;
            default:
                throw Exception('Failed addMember ${response.statusCode} ${response.body}');
        }
    }

}