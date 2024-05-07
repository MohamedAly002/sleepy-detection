import 'package:driver_drowsiness_alert/Widgets/Home/home_screen.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20Up/sign_up.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20in/forget_passward.dart';
import 'package:driver_drowsiness_alert/custom%20widgets/custom_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/quickalert.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = 'SignIn Screen';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var formKey = GlobalKey<FormState>();
  bool obsecure = true;
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  Future login() async {
    try {
      if (Email_controller.text.trim().isEmpty ||
          Password_controller.text.trim().isEmpty) {
        // If email or password is empty, show an alert
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please enter correct email and password');
        return;
      }

      QuickAlert.show(context: context, type: QuickAlertType.loading);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: Email_controller.text.trim(),
          password: Password_controller.text.trim());
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.routeName);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Welcome Again');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Sign in Failed: ${e.code}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                'assets/illustrations/signin.png',
                fit: BoxFit.fill,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    customTextformField(
                      controller: Email_controller,
                      'Enter Your Email',
                      keyboardtype: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Your Email';
                        }
                        if (!EmailValidator.validate(text)||!emailRegex.hasMatch(text)) {
                          return 'Invalid Email Format';
                        }
                        return null;
                      },
                    ),
                    customTextformField(
                      controller: Password_controller,
                      'Enter Your Password',
                      keyboardtype: TextInputType.text,
                      isObsecured: obsecure,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obsecure = !obsecure;
                            });
                          },
                          icon: Icon(obsecure
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill)),
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Color(0xFF0583F2)),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, ForgetPassward.routeName);
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: const Color(0xFF0583F2),
                        ),
                        onPressed: () {
                          textformValidation();
                          login();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?",
                        style: TextStyle(fontSize: 16)),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Color(0xFF0583F2), fontSize: 16),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void textformValidation() {
    if (formKey.currentState?.validate() == false) {
      return;
    }
  }
}
