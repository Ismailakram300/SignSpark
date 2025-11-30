import 'package:flutter/material.dart';
import 'package:sign_spark/view/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/appBackgroung.jpg"),
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
                            labelText: "Name",
                            suffixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

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

                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
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
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                            }, child: Text("LogIn",style: TextStyle(color: Colors.black),))
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(

                              "Signup",
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
