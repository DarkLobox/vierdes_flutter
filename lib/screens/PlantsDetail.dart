import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../auth_service.dart';

class PlantsDetail extends StatelessWidget {
  final String plantSelect;

  const PlantsDetail(this.plantSelect);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vierdes Flutter',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Text(plantSelect),
      ),
    );
  }
}
