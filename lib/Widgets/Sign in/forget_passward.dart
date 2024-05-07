import 'package:driver_drowsiness_alert/custom%20widgets/custom_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ForgetPassward extends StatefulWidget {
  static const String routeName = 'ForgetPassward';

  @override
  State<ForgetPassward> createState() => _ForgetPasswardState();
}

class _ForgetPasswardState extends State<ForgetPassward> {
  TextEditingController Email_controller = TextEditingController();
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: Email_controller.text.trim());
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Check your Email to reset passwaord");
    } catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Couldn't find your email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/illustrations/Reset_password.png',
                  fit: BoxFit.fill,
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
                    if (!EmailValidator.validate(text)) {
                      return 'Invalid Email Format';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
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
                            resetPassword();
                          },
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
