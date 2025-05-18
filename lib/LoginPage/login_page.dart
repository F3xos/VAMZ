import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:bet_trial/RegisterPage/register_page.dart';
import 'package:bet_trial/main.dart';
import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/form_field.dart';
import "package:bet_trial/resources/text.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  /// login user with API
  Future<void> loginUser() async {
    setState(() => isLoading = true);

    final url = Uri.parse(AppApiUrls.loginUrl);
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['token'] != null && data['account'] != null) {
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
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.loginFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
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
                SizedBox(height: 40.h),
                CustomTextField(
                  labelText: AppStrings.usernameFieldText,
                  controller: _usernameController,
                  show: true,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  labelText: AppStrings.passwordFieldText,
                  controller: _passwordController,
                  show: false,
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: isLoading ? null : loginUser,
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
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 10.w),
                              Text(AppStrings.loginButtonText),
                            ],
                          ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.dontHaveAcc,
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(AppStrings.registerButtonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
