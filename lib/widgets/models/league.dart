import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class League {
  final String name;
  final String image;
  final int id;

  League({required this.id, required this.name, required this.image});

  Widget get getLeagueWidget {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Image.network(
            image,
            width: 32.w,
            height: 32.h,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Icon(Icons.error, size: 32.sp),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
        ),
      ],
    );
  }

  Widget get getLeagueWidgetCompact {
    return SizedBox(
      width: 100.w,
      child: Center(
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        ),
      ),
    );
  }
}
