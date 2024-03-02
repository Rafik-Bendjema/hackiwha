import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hackiwha/features/auth/domain/entities/User.dart';

class ProfilePage extends StatefulWidget {
  UserProfile u;
  ProfilePage({super.key, required this.u});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfile user;
  @override
  void initState() {
    user = widget.u;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFF8F8F8),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: const Color(0xFF6E66DB),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -75,
                  left: 200 - 75,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/profilePic.png")),
                            shape: BoxShape.circle,
                            color: Colors.black),
                        width: 139,
                        height: 139,
                        child: Stack(
                          children: [
                            Positioned(
                                right: 15,
                                bottom: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 135, 130, 206),
                                    shape: BoxShape.circle,
                                  ),
                                  width: 28,
                                  height: 28,
                                  child: Center(
                                      child: TextButton(
                                          child: const Text(
                                            "+",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {})),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}

class ProfileBar extends StatefulWidget {
  IconData icon;
  String text;
  ProfileBar({super.key, required this.icon, required this.text});

  @override
  State<ProfileBar> createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  late IconData icon;
  late String text;
  @override
  void initState() {
    icon = widget.icon;
    text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 199, 199, 199)),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(text),
        const Expanded(child: Icon(Icons.arrow_forward))
      ]),
    );
  }
}
