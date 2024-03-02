import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hackiwha/features/auth/data/usersDb.dart';
import 'package:hackiwha/features/auth/domain/entities/User.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/colors.dart';

class PhoneScreen extends StatefulWidget {
  UserProfile user;
  PhoneScreen({super.key, required this.user});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'ALG';
  PhoneNumber number = PhoneNumber(isoCode: 'ALG');
  late PhoneNumber finalNumber;
  UsersDb usersDb = UserDb_impl();
  late UserProfile user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  void createAccount() async {
    // Check if finalNumber is not null
    // Use finalNumber.phoneNumber to create the User object
    UserProfile finalUser = UserProfile(
      full_name: user.full_name,
      phone_number: finalNumber.phoneNumber, // Use finalNumber.phoneNumber
      profile_pic: null,
      email: user.email,
      pwd: user.pwd,
    );

    // Perform user addition
    bool result = await usersDb.addUser(finalUser);

    // If user addition is successful, store the user ID in SharedPreferences
    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', finalUser.id);
    }

    // Show SnackBar based on the result
    if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create account. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter your',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColor.blackColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'phone number',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColor.greenColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(0, 162, 35, 35)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              finalNumber = number;
                              print(finalNumber.phoneNumber);
                            });
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            useBottomSheetSafeArea: true,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: controller,
                          formatInput: true,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        createAccount();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Create"),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
