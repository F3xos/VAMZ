import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/resources/text.dart';

class CustomPasswordField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomPasswordField({
    required this.labelText,
    required this.controller,
    super.key,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPasswordField> {
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneBigLitter = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final bigLitterRegex = RegExp(r'[A-Z]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 6) {
        _isPasswordEightCharacters = true;
      }
      _hasPasswordOneBigLitter = false;
      if (bigLitterRegex.hasMatch(password)) {
        _hasPasswordOneBigLitter = true;
      }
      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          onChanged: (password) => onPasswordChanged(password),
          enableSuggestions: false,
          autocorrect: false,
          obscureText: !_isVisible,
          style: const TextStyle(color: Colors.white),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              icon:
                  _isVisible
                      ? const Icon(Icons.visibility, color: AppColors.primary)
                      : const Icon(
                        Icons.visibility_off,
                        color: AppColors.primary,
                      ),
            ),
            filled: true,
            fillColor: AppColors.backgroundColor,
            floatingLabelStyle: const TextStyle(color: AppColors.primary),
            labelStyle: const TextStyle(color: AppColors.primary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            labelText: widget.labelText,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color:
                    _isPasswordEightCharacters ? AppColors.primary : Colors.red,
                border:
                    _isPasswordEightCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Icon(Icons.check, color: Colors.white, size: 15.sp),
              ),
            ),
            SizedBox(width: 10.w),
            const Text(
              AppStrings.passwordCheckChar,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color:
                    _hasPasswordOneBigLitter ? AppColors.primary : Colors.red,
                border:
                    _hasPasswordOneBigLitter
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Icon(Icons.check, color: Colors.white, size: 15.sp),
              ),
            ),
            SizedBox(width: 10.w),
            const Text(
              AppStrings.passwordLetterCheck,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: _hasPasswordOneNumber ? AppColors.primary : Colors.red,
                border:
                    _hasPasswordOneNumber
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Icon(Icons.check, color: Colors.white, size: 15.sp),
              ),
            ),
            SizedBox(width: 10.w),
            const Text(
              AppStrings.passwordNumberCheck,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
