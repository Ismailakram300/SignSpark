import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_spark/firebase_serivces/firebase_auth.dart';
import 'package:sign_spark/view/ForgetPasswordScreen.dart';
import 'package:sign_spark/view/signup_screen.dart';
import 'package:sign_spark/view/start_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  // ------------------------
  // LOGIN FUNCTION
  // ------------------------
  login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    String? error = await FirebaseService().login(
      email.text.trim(),
      password.text.trim(),
    );

    setState(() => loading = false);

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StartPage()),
      );
    } else {
      Get.snackbar(
        "Error ! Login failed",
        "Incorrect Email or Password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade300,
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
      resizeToAvoidBottomInset: true,
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

              // ------------------------
              // LOGO
              // ------------------------
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset("assets/images/logo.png", width: 200),
                ),
              ),

              // ------------------------
              // FORM
              // ------------------------
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ------------------------
                        // EMAIL FIELD
                        // ------------------------
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusColor: Colors.red,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            labelText: "Email",
                            suffixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!value.contains("@") || !value.contains(".")) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        // ------------------------
                        // PASSWORD FIELD
                        // ------------------------
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            focusColor: Colors.red,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            labelText: "Password",
                            suffixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          SizedBox(height: 10,),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForgetPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ------------------------
                        // LOGIN BUTTON
                        // ------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: loading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Signup",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                        // ------------------------
                        // FORGOT PASSWORD
                        // ------------------------
                      ],
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
