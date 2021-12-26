import 'dart:io';
import 'package:download_firebase/model/firebase_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ext_storage/ext_storage.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(StorageReference ref) async {
    // // final Directory systemTempDir = Directory.systemTemp;
    // Future<String> systemTempDir = ExtStorage.getExternalStoragePublicDirectory(
    //     ExtStorage.DIRECTORY_DOWNLOADS);

    // print(systemTempDir);

    // // final File tempFile = File('${systemTempDir}/${ref.name}');
    // // print(tempFile.path);

    // // if (tempFile.existsSync()) await tempFile.delete();

    // // await ref.writeToFile(tempFile);

    // // final snackBar = SnackBar(
    // //   content: Text('Downloaded ${ref.name} at ${ref.fullPath}'),
    // // );

    // // Directory docDir = await getApplicationDocumentsDirectory();
    // File dfile = File('${systemTempDir}/${ref.name}');
    // print(dfile.path);

    // try {
    //   await FirebaseStorage.instance
    //       .ref('jsonFiles/${ref.name}')
    //       .writeToFile(dfile);
    // } on FirebaseException catch (e) {}
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/${ref.name}}');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
      '\npath: $path \nBytes Count :: $byteCount',
    );
  }
}
