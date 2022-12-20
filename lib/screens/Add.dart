import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../auth_service.dart';


class Add extends StatelessWidget {
  String plantSelect = "";
  TextEditingController plantTypeText = TextEditingController();
  TextEditingController plantDescriptionText = TextEditingController();
  String imageUrl = "";

  Add();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: plantTypeText,
                decoration: const InputDecoration(
                  hintText: 'Enter plant type',
                ),
                onChanged: (text) {
                  print(plantTypeText.text);
                },
              ),
              TextField(
                controller: plantDescriptionText,
                decoration: const InputDecoration(
                  hintText: 'Enter plant description',
                ),
                onChanged: (text) {
                  print(plantDescriptionText.text);
                },
              ),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagenPicker = ImagePicker();
                    XFile? file = await imagenPicker.pickImage(
                        source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('captures');

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);
                    try {
                      await referenceImageToUpload.putFile(File(file!.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                      print(imageUrl);

                      var collection = FirebaseFirestore.instance
                          .collection("plants")
                          .doc(FirebaseAuth.instance.currentUser!.email!)
                          .collection("plants");
                      /*var querySnapshots = await collection.get();
                      for (var snapshot in querySnapshots.docs){
                        collection.doc(snapshot.id).update({'image': imageUrl});
                        var documentID = snapshot.id;
                      }*/

                      var newPlant = {
                        'type': plantTypeText.text,
                        'description': plantDescriptionText.text,
                        'dateCreation': DateTime.now().toString(),
                        'image': imageUrl
                      };

                      var plantaCreada = FirebaseFirestore.instance
                          .collection("plants")
                          .doc(FirebaseAuth.instance.currentUser!.email!)
                          .collection("plants")
                          .add(newPlant) // <-- Your data
                          .then((_) => print('Added'))
                          .catchError((error) => print('Add failed: $error'));


                    } catch (error) {}

                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () {
                    print(plantSelect);
                  },
                  child: const Text("Add Plant"))
            ],
          )),
    );
  }
}
