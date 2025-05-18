import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/resources/text.dart';

class Odds {
  static const Color _nonActive = AppColors.nonActiveColor;
  static const Color _active = AppColors.activeColor;
  final double oddsWin1;
  final double oddsWin2;
  final double oddsDraw;
  final double oddsWin1Draw;
  final double oddsWin2Draw;
  final double oddsWin1Or2;
  final double oddsNextGoal1;
  final double oddsNextGoal2;
  final double oddsNextGoalNone;
  final oddsNames = {
    '1': "Win 1",
    '2': "Win 2",
    '0': "Draw",
    '10': "Win 1 or Draw",
    '20': "Win 2 or Draw",
    '12': "Win 1 or 2",
    '11': "Next Goal Team 1",
    '22': "Next Goal Team 2",
    '99': "Next Goal None",
  };

  final oddCategories = ["Match Odds", "Double Chance", "Next Goal"];

  Odds({
    required this.oddsWin1,
    required this.oddsWin2,
    required this.oddsDraw,
    required this.oddsWin1Draw,
    required this.oddsWin2Draw,
    required this.oddsWin1Or2,
    required this.oddsNextGoal1,
    required this.oddsNextGoal2,
    required this.oddsNextGoalNone,
  });

  factory Odds.fromJson(Map<String, dynamic> json) {
    return Odds(
      oddsWin1: double.parse(json['odds_win_1'].toString()),
      oddsWin2: double.parse(json['odds_win_2'].toString()),
      oddsDraw: double.parse(json['odds_draw'].toString()),
      oddsWin1Draw: double.parse(json['odds_win_1_draw'].toString()),
      oddsWin2Draw: double.parse(json['odds_win_2_draw'].toString()),
      oddsWin1Or2: double.parse(json['odds_win_1_or_2'].toString()),
      oddsNextGoal1: double.parse(json['odds_next_goal_1'].toString()),
      oddsNextGoal2: double.parse(json['odds_next_goal_2'].toString()),
      oddsNextGoalNone: double.parse(json['odds_next_goal_none'].toString()),
    );
  }

  List<List<MapEntry<String, double>>> _chunkOdds(
    List<MapEntry<String, double>> entries,
    int size,
  ) {
    List<List<MapEntry<String, double>>> chunks = [];
    for (var i = 0; i < entries.length; i += size) {
      chunks.add(
        entries.sublist(
          i,
          i + size > entries.length ? entries.length : i + size,
        ),
      );
    }
    return chunks;
  }

  Widget getOddsWidget(int matchId_, Function addBet) {
    final int matchId = matchId_;
    final oddsMap = {
      '1': oddsWin1,
      '0': oddsDraw,
      '2': oddsWin2,
      '10': oddsWin1Draw,
      '12': oddsWin1Or2,
      '20': oddsWin2Draw,
      '11': oddsNextGoal1,
      '99': oddsNextGoalNone,
      '22': oddsNextGoal2,
    };
    int count = 0;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        children:
            _chunkOdds(oddsMap.entries.toList(), 3).map((chunk) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _active,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                      ),
                    ),
                    padding: EdgeInsets.all(8.0.sp),
                    child: Text(
                      oddCategories[count++],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                        chunk.asMap().entries.map((entry) {
                          final index = entry.key;
                          final key = entry.value.key;
                          final value = entry.value.value;

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Consumer<GlobalModel>(
                                builder: (context, globalModel, _) {
                                  final isSelected = globalModel.isBet(
                                    matchId,
                                    key,
                                  );

                                  return TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                            Colors.white,
                                          ),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                            isSelected ? _active : _nonActive,
                                          ),
                                      padding:
                                          WidgetStateProperty.all<EdgeInsets>(
                                            EdgeInsets.symmetric(vertical: 5.w),
                                          ),
                                      shadowColor:
                                          WidgetStateProperty.all<Color>(
                                            isSelected ? _active : _nonActive,
                                          ),
                                      shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft:
                                                index == 0
                                                    ? Radius.circular(10.r)
                                                    : Radius.zero,
                                            bottomRight:
                                                index == chunk.length - 1
                                                    ? Radius.circular(10.r)
                                                    : Radius.zero,
                                          ),
                                          side: BorderSide(
                                            color:
                                                isSelected
                                                    ? _active
                                                    : _nonActive,
                                            width: 2.0.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      addBet(matchId, key);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          oddsNames[key] ?? 'Unknown',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                            color: Color.fromARGB(
                                              255,
                                              199,
                                              199,
                                              199,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          value.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget getOddsWidgetCompact(int matchId_, Function addBet) {
    final int matchId = matchId_;
    final oddsMap = {'1': oddsWin1, '0': oddsDraw, '2': oddsWin2};
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _active,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            padding: EdgeInsets.all(8.0.sp),
            child: Text(
              oddCategories[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                oddsMap.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final key = entry.value.key;
                  final value = entry.value.value;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Consumer<GlobalModel>(
                        builder: (context, globalModel, _) {
                          final isSelected = globalModel.isBet(matchId, key);

                          return TextButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                isSelected ? _active : _nonActive,
                              ),
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 5.w),
                              ),
                              shadowColor: WidgetStateProperty.all<Color>(
                                isSelected ? _active : _nonActive,
                              ),
                              shape: WidgetStateProperty.all<
                                RoundedRectangleBorder
                              >(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        (index == 0)
                                            ? Radius.circular(10.r)
                                            : Radius.zero,
                                    bottomRight:
                                        (index == oddsMap.length - 1)
                                            ? Radius.circular(10.r)
                                            : Radius.zero,
                                  ),
                                  side: BorderSide(
                                    color: isSelected ? _active : _nonActive,
                                    width: 2.0.w,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              addBet(matchId, key);
                            },
                            child: Column(
                              children: [
                                Text(
                                  oddsNames[key] ?? 'Unknown',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Color.fromARGB(255, 199, 199, 199),
                                  ),
                                ),
                                Text(
                                  value.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
