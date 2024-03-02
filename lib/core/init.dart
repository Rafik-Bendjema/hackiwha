import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackiwha/core/wrapper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    fading();
  }

  void fading() async {
    bool result = await InternetConnectionChecker().hasConnection;

    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        _opacity = 1;
      });
      Future.delayed(const Duration(seconds: 4)).then((value) {
        if (result) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationWrapper()));
        } else {
          // Show dialog when there's no internet connection
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("No Internet Connection"),
                content: const Text(
                    "Please check your internet connection and try again."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      fading(); // Try again
                    },
                    child: const Text("Try Again"),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFE3FFFA)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(builder: (context, ref, widget) {
                if (_opacity == 1) {}
                return const SizedBox(
                  height: 0,
                );
              }),
              AnimatedOpacity(
                duration: const Duration(seconds: 3),
                opacity: _opacity,
                child: SvgPicture.asset(
                  "assets/images/Logo.svg",
                  width: 300,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              /*   DefaultTextStyle(
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 55, 55, 55)),
                child: AnimatedTextKit(
                  repeatForever: false,
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      "Ayadi",
                      speed: const Duration(milliseconds: 200),
                    )
                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
