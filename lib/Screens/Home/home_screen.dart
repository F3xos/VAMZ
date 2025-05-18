import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/modals/account_model.dart';
import 'package:bet_trial/widgets/filter_item.dart';
import 'package:bet_trial/widgets/custom_card.dart';
import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/models/match.dart';
import 'package:bet_trial/widgets/models/team.dart';
import 'package:bet_trial/widgets/models/odds.dart';
import 'package:bet_trial/resources/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedAppBarIndex = 0;
  List<Match> matches = [];
  List<Match> filteredMatches = [];

  @override
  void initState() {
    super.initState();

    // Fetch initial matches
    getMatches();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeAppBar(int index) {
    setState(() {
      _selectedAppBarIndex = index;
      if (index == 1) {
        filteredMatches =
            matches.where((match) {
              return match.isLive;
            }).toList();
      } else {
        filteredMatches = matches;
      }
    });
  }

  Future<void> getMatches() async {
    try {
      final response = await http.get(
        Uri.parse(AppApiUrls.matchesUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Match> loadedMatches =
            data.map((item) {
              return Match(
                id: item['id'],
                team1: Team(
                  id: item['club_1']['id'],
                  name: item['club_1']['Name'],
                  image: item['club_1']['logo'],
                ),
                team2: Team(
                  id: item['club_2']['id'],
                  name: item['club_2']['Name'],
                  image: item['club_2']['logo'],
                ),
                odds: Odds.fromJson(item),
                team1Score: int.parse(item['score_1'].toString()),
                team2Score: int.parse(item['score_2'].toString()),
                startTime: DateTime.parse(item['start_time']),
                endTime:
                    item['end_time'] != null
                        ? DateTime.parse(item['end_time'])
                        : null,
              );
            }).toList();

        setState(() {
          matches = loadedMatches;
          filteredMatches = loadedMatches;
        });
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (error) {
      print("Error fetching matches: $error");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load matches')));
      }
    }
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
                  AppStrings.homeScreenTitle,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterItem(
                  text: 'All',
                  icon: Icons.list,
                  active: (_selectedAppBarIndex == 0),
                  onTap: () => changeAppBar(0),
                ),
                FilterItem(
                  text: 'Live',
                  icon: Icons.fiber_smart_record,
                  customColor: Colors.red,
                  active: (_selectedAppBarIndex == 1),
                  onTap: () => changeAppBar(1),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: (() {
                  if (_selectedAppBarIndex == 0) {
                    return RefreshIndicator(
                      onRefresh: getMatches,
                      child: ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          if (index == matches.length - 1) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 40.h),
                              child: CustomCard(
                                type: 'soccer',
                                match: matches[index],
                              ),
                            );
                          } else {
                            return CustomCard(
                              type: 'soccer',
                              match: matches[index],
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: filteredMatches.length,
                      itemBuilder: (context, index) {
                        if (index == filteredMatches.length - 1) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 40.h),
                            child: CustomCard(
                              type: 'soccer',
                              match: filteredMatches[index],
                            ),
                          );
                        } else {
                          return CustomCard(
                            type: 'soccer',
                            match: filteredMatches[index],
                          );
                        }
                      },
                    );
                  }
                }()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
