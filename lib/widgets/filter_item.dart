import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/resources/text.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.text,
    required this.icon,
    required this.active,
    required this.onTap,
    Color? customColor,
  }) : customColor = customColor ?? AppColors.primary;

  final String text;
  final IconData icon;
  final bool active;
  final Color customColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? customColor : AppColors.nonActiveColor;
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(color),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
        ),
        shadowColor: WidgetStateProperty.all<Color>(color),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0.r),
            side: BorderSide(color: color, width: 2.0.w),
          ),
        ),
      ),
      onPressed: () {
        onTap();
      },
      child: Row(
        children: [Icon(icon, color: color), SizedBox(width: 5.w), Text(text)],
      ),
    );
  }
}
