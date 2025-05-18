import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Country {
  final int id;
  final String name;
  final String image;

  Country({required this.id, required this.name, required this.image});

  Widget get getCountryWidget {
    return Row(
      children: [
        Image.network(
          image,
          width: 32.w,
          height: 32.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.flag),
        ),
        SizedBox(width: 5.w),
        Text(name, style: TextStyle(color: Colors.white, fontSize: 15.sp)),
      ],
    );
  }

  Widget get getCountryWidgetCompact {
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
