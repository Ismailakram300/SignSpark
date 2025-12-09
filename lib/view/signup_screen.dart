import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sign_spark/firebase_serivces/firebase_auth.dart';
import 'package:sign_spark/view/login.dart';
import 'package:sign_spark/view/start_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final auth = FirebaseService();

  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool loading = false;

  // ---------------------------
  // SIGNUP FUNCTION
  // ---------------------------
  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    String? error = await auth.signUp(
      _name.text.trim(),
      _email.text.trim(),
      _password.text.trim(),
    );

    setState(() => loading = false);

    if (error == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const StartPage()));
    } else {
      Get.snackbar(
        "Error",
        "Data may not be correct!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 2),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/appBackgroung.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ---------------------------
              // LOGO
              // ---------------------------
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 280,
                  ),
                ),
              ),

              // ---------------------------
              // FORM SECTION
              // ---------------------------
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // ---------------------------
                          // NAME FIELD
                          // ---------------------------
                          TextFormField(
                            controller: _name,
                            decoration: InputDecoration(
                              focusColor: Colors.red,
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white, width: 2),
                              ),
                              labelText: "Name",
                              suffixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) =>
                            value!.isEmpty ? "Name is required" : null,
                          ),

                          const SizedBox(height: 15),

                          // ---------------------------
                          // EMAIL FIELD
                          // ---------------------------
                          TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              focusColor: Colors.red,
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white, width: 2),
                              ),
                              labelText: "Email",
                              suffixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return "Email is required";
                              if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          // ---------------------------
                          // PASSWORD FIELD
                          // ---------------------------
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              focusColor: Colors.red,
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white, width: 2),
                              ),
                              labelText: "Password",
                              suffixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          // ---------------------------
                          // CONFIRM PASSWORD
                          // ---------------------------
                          TextFormField(
                            controller: _confirmPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              focusColor: Colors.red,
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white, width: 2),
                              ),
                              labelText: "Confirm Password",
                              suffixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Confirm Password is required";
                              }
                              if (value != _password.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Already have an Account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ---------------------------
                          // SIGNUP BUTTON
                          // ---------------------------
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: loading ? null : signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const Text(
                                "Signup",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
