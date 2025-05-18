import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/resources/text.dart';

class TicketItem {
  final String date;
  final String time;
  final int id;
  final String status;
  final double bettingAmount;
  final double multiplier;

  const TicketItem({
    required this.date,
    required this.time,
    required this.id,
    required this.status,
    required this.bettingAmount,
    required this.multiplier,
  });

  String get possbileWin {
    return (bettingAmount * multiplier).toStringAsFixed(2);
  }

  Widget get getStatusWidget {
    Color color;
    Icon icon;
    if (status == 'in_game') {
      color = AppColors.inGame;
      icon = const Icon(Icons.access_alarm, color: AppColors.inGame);
    } else if (status == 'win') {
      color = AppColors.winTicket;
      icon = const Icon(Icons.check_circle, color: AppColors.winTicket);
    } else {
      color = AppColors.loseTicket;
      icon = const Icon(Icons.cancel, color: AppColors.loseTicket);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$possbileWin\$',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(width: 5.w),
        icon,
      ],
    );
  }

  Widget getWidget(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Text(
                'id: $id',
                style: TextStyle(
                  color: AppColors.ticketTextColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0.h),
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 147, 147, 147),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      getStatusWidget,
                      Text(
                        '${bettingAmount.toStringAsFixed(2)}\$',
                        style: TextStyle(
                          color: Color.fromARGB(255, 142, 142, 142),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
