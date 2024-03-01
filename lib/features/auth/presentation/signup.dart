import 'package:flutter/material.dart';
import 'package:hackiwha/features/auth/data/usersDb.dart';
import 'package:hackiwha/features/auth/domain/entities/User.dart';
import 'package:hackiwha/features/home/presentation/pages/homePage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  UsersDb usersDb = UserDb_impl();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _rePasswordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) => const Dialog(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ));
      User user = User(
          full_name: _fullNameController.text,
          phone_number: "",
          profile_pic: "",
          type: "",
          pwd: _passwordController.text,
          email: _emailController.text);
      bool result = await usersDb.addUser(user);
      Navigator.pop(context);
      if (result != true) {
        showDialog(
            context: context,
            builder: (context) => const Dialog(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Text("error occured"),
                    ),
                  ),
                ));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // You can add more complex email validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  // You can add more complex password validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _rePasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Re-Password',
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submit();
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
