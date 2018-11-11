import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
}

Future<File> getLocalFile(String pathAndName) async {
    final path = await getLocalPath();

    return File('$path/${pathAndName}');
}

Future<String> readFile(String pathAndName) async{
    final file = await getLocalFile(pathAndName);

    if(!file.existsSync()) {
        return null;
    }

    return await file.readAsString();
}

Future<Null> writeFile(String pathAndName, String content) async {
    final file = await getLocalFile(pathAndName);
    if(!file.existsSync()) {
        await file.create(recursive: true);
    }

    await file.writeAsString(content);
}