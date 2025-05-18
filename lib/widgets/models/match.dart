import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'team.dart';
import 'odds.dart';
import 'package:bet_trial/resources/text.dart';

class Match {
  final int id;
  final Team team1;
  final Team team2;
  final int team1Score;
  final int team2Score;
  final Odds odds;
  final DateTime startTime;
  final DateTime? endTime;

  Match({
    required this.id,
    required this.team1,
    required this.team2,
    required this.team1Score,
    required this.team2Score,
    required this.odds,
    required this.startTime,
    this.endTime,
  });

  bool get isLive {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime == null;
  }

  String get getMinutesLeft {
    final now = DateTime.now();
    return startTime.isBefore(now)
        ? (startTime.difference(now).inMinutes * -1).toString()
        : '0';
  }

  String get getDateFormatted {
    return '${startTime.day.toString().padLeft(2, '0')}.${startTime.month.toString().padLeft(2, '0')}.${startTime.year} - ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }

  Widget get getScore {
    return Text(
      '$team1Score:$team2Score',
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 40.sp,
      ),
    );
  }
}
