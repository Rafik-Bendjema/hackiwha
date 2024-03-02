import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackiwha/core/App.dart';
import 'package:hackiwha/features/auth/presentation/login.dart';
import 'package:hackiwha/features/home/presentation/pages/homePage.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting for the connection status
        } else {
          if (snapshot.hasData) {
            print("i am ahere");
            return App();
          } else {
            print("no here");
            // User is not signed in
            return const LoginPage();
          }
        }
      },
    );
  }
}
