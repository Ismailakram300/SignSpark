import 'package:flutter/material.dart';
import 'package:sign_spark/view/signup_screen.dart';
import 'package:sign_spark/view/start_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image:  DecorationImage(image: AssetImage("assets/images/appBackgroung.jpg"),
          fit: BoxFit.cover

          )
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20,),
              // Logo Section
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 280,
                  ),
                ),
              ),

              // Form Section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Email Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            suffixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password Field
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("If Already have an Account "),
                          TextButton(onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (_)=>SignupScreen()));

                          }, child: Text("SignIn",style: TextStyle(color: Colors.black),))
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (_)=>StartPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(

                              "Login",
                              style: TextStyle(fontSize: 16,color: Colors.white ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Forgot Password
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),

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
