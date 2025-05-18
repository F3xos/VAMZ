import 'package:bet_trial/resources/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/models/match.dart';

class CustomCard extends StatefulWidget {
  final String type;
  final Match match;
  final bool compact;

  const CustomCard({
    super.key,
    required this.type,
    required this.match,
    this.compact = true,
  });

  @override
  State<CustomCard> createState() {
    return _CustomCardState();
  }
}

class _CustomCardState extends State<CustomCard> {
  void addBet(int id, String bet) {
    setState(() {
      var globalModel = Provider.of<GlobalModel>(context, listen: false);
      globalModel.addBet(id, bet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.sp, left: 15.sp, right: 15.sp),
      child: Card(
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        color: AppColors.cardBackground,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.sp, right: 10.sp, left: 10.sp),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: (() {
                      if (widget.match.isLive) {
                        return [
                          const Icon(Icons.sports_soccer, color: Colors.green),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fiber_smart_record,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'Live',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${widget.match.getMinutesLeft}\'',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ];
                      } else {
                        return [
                          const Icon(Icons.sports_soccer, color: Colors.green),
                          Text(
                            widget.match.getDateFormatted,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ];
                      }
                    }()),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 80.w,
                            child: widget.match.team1.getTeamWidget,
                          ),
                        ),
                        widget.match.getScore,
                        Flexible(
                          child: SizedBox(
                            width: 80.w,
                            child: widget.match.team2.getTeamWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.compact) ...[
                    widget.match.odds.getOddsWidgetCompact(
                      widget.match.id,
                      addBet,
                    ),
                  ] else ...[
                    widget.match.odds.getOddsWidget(widget.match.id, addBet),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
