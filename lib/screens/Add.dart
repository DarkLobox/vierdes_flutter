import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../auth_service.dart';

class Add extends StatelessWidget {
  String plantSelect = "";
  TextEditingController plantTypeText = TextEditingController();
  TextEditingController plantDescriptionText = TextEditingController();

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
