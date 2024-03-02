import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/colors.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final currencyFormatter =
      NumberFormat.currency(locale: 'ar_DZ', symbol: 'DA');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/profilePic.png',
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Hello, User!',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: AppColor.whiteColor,
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search...',
                            hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 16,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.purpulColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Special needs interface',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: AppColor.whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.greyColor,
                              border: Border.all(
                                color: AppColor.purpulColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Volunteers INTERFACE',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: AppColor.purpulColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.greyColor,
                                border: Border.all(
                                  color: AppColor.purpulColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        hintText: 'Description',
                                      ),
                                    ),
                                    TextField(
                                      controller: _priceController,
                                      decoration: const InputDecoration(
                                        hintText: 'Price',
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _addOffer();
                                      },
                                      child: const Text('Add Offer'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('offers')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const LinearProgressIndicator();
                                }
                                final offers = snapshot.data!.docs;
                                return Column(
                                  children: offers.map<Widget>((offer) {
                                    final offerData =
                                        offer.data() as Map<String, dynamic>;
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(offerData['user_id'])
                                          .get(),
                                      builder: (context, userSnapshot) {
                                        if (userSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const LinearProgressIndicator();
                                        }
                                        final userData = userSnapshot.data!;
                                        final user = userData.data()
                                            as Map<String, dynamic>;
                                        return OfferCard(
                                          profileImagePath:
                                              user['profileImagePath'],
                                          userName: user['name'],
                                          date: offerData['date'],
                                          description: offerData['description'],
                                          price: offerData['price'].toString(),
                                        );
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addOffer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('offers').add({
        'description': _descriptionController.text,
        'price': _priceController.text,
        'user_id': prefs
            .get('userId'), // Replace 'current_user_id' with the actual user ID
        'date': FieldValue.serverTimestamp(),
      });
      _descriptionController.clear();
      _priceController.clear();
    }
  }
}

class OfferCard extends StatelessWidget {
  final String profileImagePath;
  final String userName;
  final String date;
  final String description;
  final String price;

  const OfferCard({
    Key? key,
    required this.profileImagePath,
    required this.userName,
    required this.date,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.greyColor,
          border: Border.all(
            color: AppColor.purpulColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image(
                      image: AssetImage(profileImagePath),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Text(
                        description,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 170),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.greyColor,
                            border: Border.all(
                              color: AppColor.purpulColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              " $price DA",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColor.purpulColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.message,
                          color: AppColor.purpulColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
