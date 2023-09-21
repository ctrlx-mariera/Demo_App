import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _redirectToAPI() async {
    final url = Uri.parse('https://expressway.cargen.com/v1/login');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successfully fetched the API, you can handle the response here.
        print('API Response: ${response.body}');
        // You can navigate to a new screen or perform other actions based on the response.
      } else {
        // Handle HTTP errors here, e.g., response.statusCode != 200
        print('API Request Failed: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors here.
      print('API Request Error: $e');
    }
  }

  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // User successfully signed in, you can navigate to the API or perform other actions.
      _redirectToAPI(); // Add this line to trigger the API call.
    } catch (e) {
      // Handle authentication errors here.
      print("Sign in failed: $e");

      // show error dialog with error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              // ...
              );
        },
      );
    }
  }

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // Password reset email sent successfully, inform the user.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset email sent. Check your inbox."),
        ),
      );
    } catch (e) {
      // Handle password reset errors here.
      print("Password reset failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon(),
          const SizedBox(height: 50),
          _inputField("Email", emailController),
          const SizedBox(height: 20),
          _inputField("Password", passwordController, isPassword: true),
          const SizedBox(height: 50),
          _LoginBtn(),
          const SizedBox(height: 50),
          _resetPasswordButton(), // Added the "Can't access your account?" button
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _LoginBtn() {
    return ElevatedButton(
      onPressed: _signIn,
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16)),
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  Widget _resetPasswordButton() {
    return TextButton(
      onPressed: _resetPassword,
      child: const Text(
        "Reset Password",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
