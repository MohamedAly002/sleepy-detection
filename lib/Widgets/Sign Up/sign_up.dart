import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20in/sign_in.dart';
import 'package:driver_drowsiness_alert/custom%20widgets/custom_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  bool obsecure = true;
  bool obsecureConfirmation = true;
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  TextEditingController UserName_controller = TextEditingController();
  TextEditingController ConfirmPassword_controller = TextEditingController();
  RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final FirebaseAuth auth=FirebaseAuth.instance;
  Future<void> signup() async {
    try {
      if (isPasswordConfirmed() && formKey.currentState?.validate() == true) {
        QuickAlert.show(context: context, type: QuickAlertType.loading);

        // Create user with Firebase Authentication
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Email_controller.text.trim(),
          password: Password_controller.text.trim(),
        );

        // Save user information to Firestore
        await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).set({
          'id':auth.currentUser!.uid,
          'username': UserName_controller.text.trim(),
          'email': Email_controller.text.trim(),
        });

        Navigator.pop(context);
        Navigator.pushNamed(context, SignInScreen.routeName);
        QuickAlert.show(context: context, type: QuickAlertType.success, text: 'Signed Up Successfully');
      } else {
        QuickAlert.show(context: context, type: QuickAlertType.error, text: "Something Went Wrong \n Check Your Sign Up Information ");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Sign up Failed: ${e.code}',
      );
    }
  }


  bool isPasswordConfirmed() {
    if (Password_controller.text.trim() ==
        ConfirmPassword_controller.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/illustrations/Signup.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  customTextformField(
                    'Enter Your Username',
                    controller: UserName_controller,
                    keyboardtype: TextInputType.text,
                    prefixIcon: const Icon(Icons.person),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Your Username';
                      }
                      return null;
                    },
                  ),
                  customTextformField(
                    controller: Email_controller,
                    'Enter Your Email',
                    keyboardtype: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Your Email';
                      }
                      if (!EmailValidator.validate(text) ||
                          !emailRegex.hasMatch(text)) {
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
                  customTextformField(
                    controller: ConfirmPassword_controller,
                    'Confirm Your Password',
                    keyboardtype: TextInputType.text,
                    isObsecured: obsecureConfirmation,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecureConfirmation = !obsecureConfirmation;
                          });
                        },
                        icon: Icon(obsecureConfirmation
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill)),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      if (Password_controller.text != text) {
                        return "Password doesn't match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
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
                              signup();
                            },
                            child: const Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ],
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Have an account ?",
                            style: TextStyle(fontSize: 16)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SignInScreen.routeName);
                              },
                              child: const Text(
                                "Sign In Now",
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
