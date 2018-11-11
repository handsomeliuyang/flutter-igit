import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

enum ProjectListType {
    groups,
    projects
}

enum ProjectType {
    group,
    project
}

class GitProject {
    final int id;
    final String name;
    final ProjectType projectType;

    GitProject({
        @required this.name,
        @required this.id,
        @required this.projectType
    });

    static ProjectType getProjectTypeFromString(String typeAsString) {
        debugPrint('liuyang 111 ${typeAsString}');

        if(typeAsString == null) {
            return null;
        }
        for (ProjectType element in ProjectType.values) {
            if (element.toString() == typeAsString) {
                return element;
            }
        }
        return null;
    }

    factory GitProject.fromJson(Map<String, dynamic> json, [ProjectType type]) {
        ProjectType projectType = getProjectTypeFromString(json['projectType']);
        if(type != null) {
            projectType = type;
        }

        String name = '';
        if(projectType == ProjectType.group) {
            name = json['path'];
        } else {
            name = json['path_with_namespace'];
        }

        return GitProject(
            projectType: projectType,
            name: name,
            id: json['id']
        );
    }

    Map<String, dynamic> toJson() {
        String nameKey = '';
        if(this.projectType == ProjectType.group) {
            nameKey = 'path';
        } else {
            nameKey = 'path_with_namespace';
        }

        return {
            nameKey: name,
            'id': id,
            'projectType': projectType.toString()
        };
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is GitProject &&
                runtimeType == other.runtimeType &&
                id == other.id &&
                name == other.name &&
                projectType == other.projectType;

    @override
    int get hashCode =>
        id.hashCode ^
        name.hashCode ^
        projectType.hashCode;

    @override
    String toString() {
        return 'GitProject{id: $id, name: $name, projectType: $projectType}';
    }


}