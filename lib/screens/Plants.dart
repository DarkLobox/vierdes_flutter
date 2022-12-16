import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vierdes_flutter/screens/PlantsDetail.dart';

import '../auth_service.dart';

class Plants extends StatelessWidget {
  const Plants();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("plants")
          .doc(FirebaseAuth.instance.currentUser!.email!)
          .collection("plants")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantsDetail(documentSnapshot['type'])),
                  );
                },
                child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['type']),
                      subtitle:
                          Text(documentSnapshot['description'].toString()),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: ClipOval(
                          child: Image.network(
                            documentSnapshot['image'].toString(),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    )),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
