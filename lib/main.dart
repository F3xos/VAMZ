import 'package:bet_trial/resources/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bet_trial/Screens/Home/home_screen.dart';
import 'package:bet_trial/Screens/Sports/sports_screen.dart';
import 'package:bet_trial/Screens/Tickets/tickets_screen.dart';
import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/Screens/Stats/charts_screen.dart';
import 'package:bet_trial/auth_gate.dart';
import 'package:bet_trial/widgets/modals/bets_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const bool clearTokenOnStart = true; // 👈 change to true when testing
  if (clearTokenOnStart) {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  final globalModel = GlobalModel();
  await globalModel.loadToken();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider.value(
      value: globalModel,
      child: ScreenUtilInit(
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthGate(), // handles login/BetTrial logic
        ),
      ),
    ),
  );
}

class BetTrial extends StatefulWidget {
  const BetTrial({super.key});

  @override
  State<BetTrial> createState() {
    return _BetTrialState();
  }
}

class _BetTrialState extends State<BetTrial> {
  int _selectedIndex = 0;

  void openBetsModal() {}

  final List<Widget> _screens = [
    const HomeScreen(),
    const SportsScreen(),
    const TicketsScreen(),
    const ChartsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 75.h,
        width: 75.w,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: AppColors.backgroundColor,
                isScrollControlled: true,
                context: context,
                builder:
                    (_) => MyBetsModal(
                      bets: Provider.of<GlobalModel>(context).bets,
                    ),
              ).then((_) {
                setState(() {}); // called after modal closes
              });
            },
            backgroundColor: AppColors.activeColor,
            child: Consumer<GlobalModel>(
              builder: (context, globalModel, _) {
                return Text(
                  globalModel.getBetCount.toString(),
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //shape: const CircularNotchedRectangle(),
        color: AppColors.backgroundColor,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  color:
                      (_selectedIndex == 0)
                          ? AppColors.primary
                          : AppColors.nonActiveColor,
                  tooltip: 'Home',
                  icon: const Icon(Icons.home),
                  iconSize: 35.sp,
                  onPressed: () {
                    _onItemTapped(0);
                  },
                ),
                IconButton(
                  color:
                      (_selectedIndex == 1)
                          ? AppColors.primary
                          : AppColors.nonActiveColor,
                  tooltip: 'Sports',
                  icon: const Icon(Icons.sports_soccer),
                  iconSize: 35.sp,
                  onPressed: () {
                    _onItemTapped(1);
                  },
                ),
                SizedBox(width: 50.w),
                IconButton(
                  color:
                      (_selectedIndex == 2)
                          ? AppColors.primary
                          : AppColors.nonActiveColor,
                  tooltip: 'Tickets',
                  icon: const Icon(Icons.attach_money),
                  iconSize: 35.sp,
                  onPressed: () {
                    _onItemTapped(2);
                  },
                ),
                IconButton(
                  color:
                      (_selectedIndex == 3)
                          ? AppColors.primary
                          : AppColors.nonActiveColor,
                  tooltip: 'Stats',
                  icon: const Icon(Icons.pie_chart_rounded),
                  iconSize: 35.sp,
                  onPressed: () {
                    _onItemTapped(3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
    );
  }
}
