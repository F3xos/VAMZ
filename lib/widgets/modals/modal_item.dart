import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/models/country.dart';
import 'package:bet_trial/widgets/models/league.dart';

class SelectModalItem extends StatefulWidget {
  final bool isSelected;
  final Function reset;
  final Function(Country)? selectCountry;
  final Function(League)? selectLeague;
  final Country? country;
  final bool sceleton;
  final League? league;

  const SelectModalItem.country({
    super.key,
    required this.country,
    required this.isSelected,
    required this.selectCountry,
    required this.reset,
    required this.sceleton,
  }) : league = null,
       selectLeague = null;

  const SelectModalItem.league({
    super.key,
    required this.league,
    required this.isSelected,
    required this.selectLeague,
    required this.reset,
    required this.sceleton,
  }) : country = null,
       selectCountry = null;

  const SelectModalItem.sceleton({
    super.key,
    required this.sceleton,
    required this.reset,
    required this.isSelected,
  }) : country = null,
       selectCountry = null,
       league = null,
       selectLeague = null;

  @override
  State<SelectModalItem> createState() {
    return _SelectModalItemState();
  }
}

class _SelectModalItemState extends State<SelectModalItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.sp),
      child:
          (widget.sceleton)
              ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color:
                      (widget.sceleton)
                          ? const Color.fromARGB(126, 51, 51, 51)
                          : const Color.fromARGB(255, 51, 51, 51),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: const Color.fromARGB(32, 121, 121, 121),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              width: 100.w,
                              height: 15.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: const Color.fromARGB(32, 121, 121, 121),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      (widget.isSelected)
                          ? const Color.fromARGB(255, 92, 180, 107)
                          : const Color.fromARGB(255, 51, 51, 51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    (widget.selectCountry != null)
                        ? widget.selectCountry!(widget.country!)
                        : widget.selectLeague!(widget.league!);
                    Navigator.pop(context);
                  });
                },
                child: SizedBox(
                  width:
                      double
                          .infinity, // 🔧 This ensures the Row inside has a bounded width
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    child:
                        (widget.selectCountry != null)
                            ? widget.country!.getCountryWidget
                            : widget.league!.getLeagueWidget,
                  ),
                ),
              ),
    );
  }
}
