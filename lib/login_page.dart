import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Vierdes Flutter"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.network(
              "https://firebasestorage.googleapis.com/v0/b/riego-plantas.appspot.com/o/assets%2Flogo.png?alt=media&token=c298f50f-6041-4d1c-aaf1-757a56cc38cc",
              fit: BoxFit.cover,
              width: 250,
              height: 250,
            ),
            const SizedBox(
              height: 60,
            ),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: const Image(width: 100, image: AssetImage('assets/google.png')),
              onPressed: () {
                AuthService().signInWithGoogle();
              },
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}