import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_igit/models/git_project.dart';
import 'package:flutter_igit/models/git_user.dart';
import 'package:flutter_igit/models/tradeline.dart';
import 'package:flutter_igit/utils/file_utils.dart';

class PermissionApi {
    static const String PERMISSION_PATH = "permission";

    String getPathAndName(String tradelineId) {
        return '${PERMISSION_PATH}/${tradelineId}.json';
    }

    Future<List<GitProject>> getGroupsByTradeline(Tradeline tradeline) async {
        String content = await readFile(getPathAndName(tradeline.id));

        debugPrint('liuyang content=${content}');

        if (content == null) {
            return [];
        }

        List<GitProject> projects = <GitProject>[];

        List list = json.decode(content);
        for (dynamic item in list) {
            if(item is Map) {
                projects.add(GitProject.fromJson(item));
            }
        }

        debugPrint('liuyang getGroupsByTradeline projects=${projects}');

        return projects;
    }

    Future<Null> saveGitProjectByTradeline(Tradeline tradeline, GitProject project) async {
        List<GitProject> projects = await getGroupsByTradeline(tradeline);
        projects.add(project);

        String content = json.encode(projects);
        debugPrint('liuyang content=${content}');

        await writeFile(getPathAndName(tradeline.id), content);
    }

    Future<Null> deleteGitProjectByTradeline(Tradeline tradeline, GitProject project) async {
        List<GitProject> projects = await getGroupsByTradeline(tradeline);
        int deleteIndex = -1;
        for(int i=0; i<projects.length; i++){
            if(projects[i] == project) {
                deleteIndex = i;
                break;
            }
        }
        projects.removeAt(deleteIndex);

        await writeFile(getPathAndName(tradeline.id), json.encode(projects));
    }
}