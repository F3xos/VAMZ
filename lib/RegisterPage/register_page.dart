import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/form_field.dart';
import 'package:bet_trial/widgets/password_field.dart';
import 'package:bet_trial/main.dart';
import 'package:bet_trial/resources/text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  ///Register user API call
  Future<void> registerUser() async {
    setState(() => isLoading = true);
    final response = await http.post(
      Uri.parse(AppApiUrls.registerUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": _username.text,
        "email": _email.text,
        "password": _password.text,
      }),
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      await Provider.of<GlobalModel>(
        context,
        listen: false,
      ).login(data['token'], data['account']);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BetTrial()),
        (route) => false,
      );
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['message'] ?? AppStrings.registerFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.arrow_back),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
            repeat: ImageRepeat.noRepeat,
            alignment: Alignment.center,
            image: AssetImage("assets/LoginBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                CustomTextField(
                  labelText: AppStrings.usernameFieldText,
                  controller: _username,
                  show: true,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  labelText: AppStrings.emailFieldText,
                  controller: _email,
                  show: true,
                ),
                SizedBox(height: 20.h),
                CustomPasswordField(
                  labelText: AppStrings.passwordFieldText,
                  controller: _password,
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: isLoading ? null : registerUser,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    fixedSize: Size(150.w, 50.h),
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.app_registration_outlined),
                              SizedBox(width: 10),
                              Text(AppStrings.registerButtonText),
                            ],
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
