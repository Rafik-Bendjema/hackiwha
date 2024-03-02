import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackiwha/core/init.dart';
import 'package:hackiwha/features/auth/domain/entities/User.dart';
import 'package:hackiwha/features/auth/presentation/signup.dart';
import 'package:hackiwha/features/profile/presentation/pages/profile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}
