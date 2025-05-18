import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/resources/text.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool show;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    required this.show,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enableSuggestions: false,
      autocorrect: false,
      obscureText: !show,
      style: const TextStyle(color: Colors.white),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        filled: true,
        fillColor: AppColors.backgroundColor,
        labelStyle: const TextStyle(color: AppColors.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        labelText: labelText,
      ),
    );
  }
}
