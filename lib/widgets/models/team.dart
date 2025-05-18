import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'country.dart';
import 'league.dart';

class Team {
  final int id;
  final String name;
  final String image;
  final Country? nationality;
  final League? league;

  Team({
    required this.id,
    required this.name,
    required this.image,
    this.nationality,
    this.league,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(id: json['id'], name: json['Name'], image: json['logo']);
  }

  Widget get getTeamWidget {
    return Column(
      children: [
        Image.network(
          image,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        ),
        SizedBox(height: 5.h),
        Text(
          name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
