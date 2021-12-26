import 'dart:html';
import 'dart:io';
import 'dart:async';

import 'package:download_firebase/api/firebase_api.dart';
import 'package:download_firebase/model/firebase_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key key,
    this.file,
  }) : super(key: key);

  //   static void dFile(){
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   final StorageReference storageref = storage.getReferenceFromUrl("gs://digitaldukan2.appspot.com/jsonFiles/Riddhi_Gohil.json");
  //   final StorageReference islandref = storageref.child("AWS.txt");

  //   File rootPath = new File(Environment.getExternalStorageDirectory(),"AWS.txt");

  //   if(!rootPath.exists()){
  //     rootPath.mkdirs();
  //   }

  //   final File localFile = new File(rootPath, "AWS.txt");

  //   islandref.getFile(localFile).addOnSuccessListener(new OnSuccessListeneer<FileDownloadTask.TaskSnapshot>(){
  //     @Override
  //     public void onSuccess(FileDownloadTask.TaskSnapshot taskSnapshot){
  //       Log.e("firebase ",";local file created"+localFile.toString());
  //     }
  //   }).addOnFailureListener(new OnFailureListener() {
  //     @Override
  //     public void onFailure(@NonNull Exception exception)
  //     {
  //       Log.e("firebase ",";local file NOT created "+localFile.toString());

  //     }
  //   });

  // }

  @override
  Widget build(BuildContext context) {
    final isImage = ['.json', '.jpg', '.png'].any(file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              await FirebaseApi.downloadFile(file.ref);

              final snackBar = SnackBar(
                content: Text('Downloaded ${file.name}'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isImage
          ? Image.network(
              file.url,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : Center(
              child: Text(
                'Cannot be displayed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
