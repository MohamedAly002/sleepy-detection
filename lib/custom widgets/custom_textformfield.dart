import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class customTextformField extends StatelessWidget {
  customTextformField(this.hint,
      {this.validator,
      this.controller,
      this.keyboardtype = TextInputType.text,
      this.isObsecured = false,
      this.prefixIcon,
      this.suffixIcon});
  String? hint;
  Validator? validator;
  TextEditingController? controller;
  TextInputType keyboardtype;
  bool isObsecured;
  Icon? prefixIcon;
  IconButton? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardtype,
          obscureText: isObsecured,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 15),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)))),
    );
  }
}
