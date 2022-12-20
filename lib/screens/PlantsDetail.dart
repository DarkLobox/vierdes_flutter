import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../auth_service.dart';

class PlantsDetail extends StatelessWidget {
  final String plantType;
  final String plantDescription;
  final String plantDateCreation;
  final String plantImage;
  final String plantDocId;

  const PlantsDetail(this.plantType, this.plantDescription,
      this.plantDateCreation, this.plantImage, this.plantDocId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vierdes Flutter',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("plants")
                .doc(FirebaseAuth.instance.currentUser!.email!)
                .collection("plants")
                .doc(plantDocId)
                .collection("irrigations")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    plantType.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 110,
                    backgroundColor: Colors.green,
                    child: ClipOval(
                      child: Image.network(
                        plantImage,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    plantDescription,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          padding: const EdgeInsets.all(10),
                          color: Colors.cyanAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            'Regar',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () {
                            regarPlant(plantDocId);
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                            onPressed: () async {
                              ImagePicker imagenPicker = ImagePicker();
                              XFile? file = await imagenPicker.pickImage(
                                  source: ImageSource.camera);
                              print('${file?.path}');

                              if (file == null) return;
                              String uniqueFileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child('captures');

                              Reference referenceImageToUpload =
                                  referenceDirImages.child(uniqueFileName);
                              try {
                                await referenceImageToUpload
                                    .putFile(File(file!.path));
                                var imageUrl = await referenceImageToUpload
                                    .getDownloadURL();
                                fotoPlant(plantDocId, imageUrl);
                                Navigator.of(context).pop();
                              } catch (error) {}
                            },
                            icon: Icon(Icons.camera_alt)),
                        const SizedBox(
                          width: 15,
                        ),
                        MaterialButton(
                          padding: const EdgeInsets.all(10),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () {
                            deletePlant(plantDocId);
                            Navigator.of(context).pop();
                          },
                        ),
                      ]),
                  Expanded(
                      child: streamSnapshot.hasData
                          ? ListView.builder(
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Text(
                                  documentSnapshot["fecha"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                );
                              },
                            )
                          : const Text("")),
                ],
              );
            },
          ),
        ));
  }
}

Future<void> deletePlant(String id) {
  return FirebaseFirestore.instance
      .collection("plants")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("plants")
      .doc(id)
      .delete();
}

Future<void> regarPlant(String id) {
  var riego = {'fecha': DateTime.now().toString()};
  return FirebaseFirestore.instance
      .collection("plants")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("plants")
      .doc(id)
      .collection("irrigations")
      .add(riego);
}

Future<void> fotoPlant(String id, String image) {
  return FirebaseFirestore.instance
      .collection("plants")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("plants")
      .doc(id)
      .update({'image': image});
}
