import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/auth_gate.dart';
import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/resources/text.dart';

class AccountModal extends StatefulWidget {
  const AccountModal({super.key});

  @override
  State<AccountModal> createState() => _AccountModalState();
}

class _AccountModalState extends State<AccountModal> {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.accountText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  color: const Color.fromARGB(255, 203, 203, 203),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 130, 130, 130),
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  globalModel.resetMoney();
                  ScaffoldMessenger.of(
                    Navigator.of(context).context,
                  ).showSnackBar(
                    const SnackBar(content: Text(AppStrings.resetMoneySucc)),
                  );

                  Navigator.pop(context);
                },
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
                child: const Text("Reset Money"),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  globalModel
                      .logout(); // Navigate back to AuthGate and clear navigation stack
                  ScaffoldMessenger.of(
                    Navigator.of(context).context,
                  ).showSnackBar(
                    const SnackBar(content: Text("Loggout succesfull")),
                  );

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AuthGate()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  fixedSize: Size(150.w, 50.h),
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: const Text(AppStrings.logoutButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
