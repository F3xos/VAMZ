import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/filter_item.dart';
import 'package:bet_trial/widgets/modals/account_model.dart';
import 'package:bet_trial/resources/text.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() {
    return _ChartsScreenState();
  }
}

class _ChartsScreenState extends State<ChartsScreen> {
  int _selectedAppBarIndex = 0;
  Map<String, Map<String, double>> stats = {};
  List<String> categories = ['Day', 'Week', 'Month'];
  List<String> types = ['won', 'lost'];
  int selectedStats = 0;
  List<String> titles = ['Tickets won', 'Tickets lost'];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getStats();
    _scrollController.addListener(_onScrollControllerChange);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollControllerChange);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getStats() async {
    final globalModel = Provider.of<GlobalModel>(context, listen: false);
    final url = Uri.parse(
      '${AppApiUrls.statsUrl}${globalModel.account!['id']}',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Convert to desired type
      final Map<String, Map<String, double>> loadedStats = {};

      data.forEach((key, value) {
        loadedStats[key] = {
          'won': double.parse(value['won']),
          'lost': double.parse(value['lost']),
        };
      });

      if (mounted) {
        setState(() {
          stats = loadedStats;
        });
      }
    } else {
      throw Exception('Failed to fetch stats');
    }
  }

  void _onScrollControllerChange() {
    final itemCount = stats[categories[_selectedAppBarIndex]]!.length;
    double itemWidth = 300.0.sp; // Width of each item in the list
    final center =
        (_scrollController.position.extentInside / 2) +
        _scrollController.position.pixels;
    final newIndex = (center / itemWidth).round().clamp(0, itemCount - 1);
    if (selectedStats != newIndex) {
      setState(() {
        selectedStats = newIndex;
      });
    }
  }

  void changeAppBar(int index) {
    setState(() {
      _selectedAppBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 100.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.statsScreenTitle,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<GlobalModel>(
                      builder: (context, globalModel, _) {
                        return Text(
                          '${globalModel.getMoney.toStringAsFixed(2)}\$',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.backgroundColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => AccountModal(),
                        );
                      },
                      tooltip: 'Profile',
                      icon: const Icon(
                        Icons.account_circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterItem(
                  text: 'Day',
                  icon: Icons.calendar_today_rounded,
                  active: (_selectedAppBarIndex == 0 ? true : false),
                  onTap: () {
                    changeAppBar(0);
                  },
                ),
                FilterItem(
                  text: 'Week',
                  icon: Icons.calendar_month_outlined,
                  active: (_selectedAppBarIndex == 1 ? true : false),
                  onTap: () {
                    changeAppBar(1);
                  },
                ),
                FilterItem(
                  text: 'Month',
                  icon: Icons.calendar_month_rounded,
                  active: (_selectedAppBarIndex == 2 ? true : false),
                  onTap: () {
                    changeAppBar(2);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  color: AppColors.primary,
                  onPressed: getStats,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: ScrollSnapList(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final categoryKey = categories[_selectedAppBarIndex].toLowerCase();
            final data = stats[categoryKey] ?? {};
            final value = data[types[index]] ?? 0.0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titles[index],
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 10.h),
                CircularPercentIndicator(
                  percent: value.clamp(0.0, 1.0),
                  radius: 100.r,
                  lineWidth: 30.w,
                  center: Text(
                    '${(value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.cardBackground,
                  progressColor: AppColors.primary,
                ),
              ],
            );
          },
          itemCount:
              stats[categories[_selectedAppBarIndex].toLowerCase()]?.length ??
              0,
          itemSize: 200.sp,
          initialIndex: 0,
          dynamicItemSize: true,
          dynamicItemOpacity: 0.6,
          onItemFocus: (int) {},
        ),
      ),
    );
  }
}
