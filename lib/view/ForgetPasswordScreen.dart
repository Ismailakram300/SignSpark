import 'package:flutter/material.dart';
import '../firebase_serivces/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  void resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    String? error = await FirebaseService().resetPassword(_email.text);
    setState(() => loading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent! Check your inbox.")),
      );
      Navigator.pop(context); // Go back to Login
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/appBackgroung.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Forget Password",style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),

                Text(
                  "Enter your email and we will send you a link to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: 30),

                TextFormField(
                  style: TextStyle(

                  ),
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Email is required";
                    if (!v.contains("@")) return "Enter valid email";
                    return null;
                  },
                ),

                SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: loading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Send Reset Link",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
