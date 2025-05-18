import 'package:bet_trial/resources/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/modals/modal_item.dart';
import 'package:bet_trial/widgets/models/match.dart';
import 'package:bet_trial/widgets/models/team.dart';
import 'package:bet_trial/widgets/models/odds.dart';
import 'package:bet_trial/widgets/Database/global.dart';

class MyBetsModal extends StatefulWidget {
  const MyBetsModal({super.key, required this.bets});
  final Map<int, String> bets;

  @override
  State<MyBetsModal> createState() => _MyBetsModalState();
}

class _MyBetsModalState extends State<MyBetsModal> {
  Map<int, Match> matchData = {};
  TextEditingController stakeController = TextEditingController();
  double multiplier = 1;
  double winAmount = 0;
  Map<int, double> oddsList = {};

  @override
  void initState() {
    super.initState();
    getMatches();

    // Recalculate win amount when stake changes
    stakeController.addListener(() {
      calculateWinAmount();
    });
  }

  Future<void> getMatches() async {
    try {
      for (final matchId in widget.bets.keys) {
        final response = await http.get(
          Uri.parse('${AppApiUrls.matchesUrl}$matchId'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          matchData[matchId] = Match(
            id: data['id'],
            team1: Team(
              id: data['club_1']['id'],
              name: data['club_1']['Name'],
              image: data['club_1']['logo'],
            ),
            team2: Team(
              id: data['club_2']['id'],
              name: data['club_2']['Name'],
              image: data['club_2']['logo'],
            ),
            odds: Odds.fromJson(data),
            team1Score: int.parse(data['score_1'].toString()),
            team2Score: int.parse(data['score_2'].toString()),
            startTime: DateTime.parse(data['start_time']),
            endTime:
                data['end_time'] != null
                    ? DateTime.parse(data['end_time'])
                    : null,
          );
        } else {
          throw Exception('Failed to load match $matchId');
        }
      }

      if (mounted) {
        calculateWinAmount();
        setState(() {});
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

  double? getSelectedOdd(Match match, String betType) {
    switch (betType) {
      case "1":
        return match.odds.oddsWin1;
      case "0":
        return match.odds.oddsDraw;
      case "2":
        return match.odds.oddsWin2;
      default:
        return null;
    }
  }

  void calculateWinAmount() {
    multiplier = 1;

    widget.bets.forEach((matchId, betType) {
      final match = matchData[matchId];
      if (match != null) {
        final odd = getSelectedOdd(match, betType);
        if (odd != null) {
          oddsList[matchId] = odd;
          multiplier *= odd;
        }
      }
    });

    final stake = double.tryParse(stakeController.text) ?? 0;
    setState(() {
      winAmount = stake * multiplier;
    });
  }

  Future<void> betStake(BuildContext context, double stake) async {
    final globalModel = Provider.of<GlobalModel>(context, listen: false);
    final url = Uri.parse(AppApiUrls.ticketsUrl);

    final body = {
      "account_id": globalModel.account!['id'],
      "bets":
          globalModel.bets.entries
              .map(
                (e) => {
                  "match_id": e.key,
                  "bet_type": e.value,
                  "odd": oddsList[e.key],
                },
              )
              .toList(),
      "bet_money": stake,
    };

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stake of bets was successful')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Staking failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ScreenUtilInit(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    color: const Color.fromARGB(255, 203, 203, 203),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 130, 130, 130),
                thickness: 1,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.bets.length,
                  itemBuilder: (context, index) {
                    final matchId = widget.bets.keys.elementAt(index);
                    final betType = widget.bets[matchId]!;
                    final match = matchData[matchId];

                    if (match == null) {
                      return SelectModalItem.sceleton(
                        sceleton: true,
                        reset: () {},
                        isSelected: false,
                      );
                    }

                    final odd = getSelectedOdd(match, betType);

                    return Dismissible(
                      key: ValueKey(matchId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        globalModel.removeBet(matchId);
                        setState(() {
                          widget.bets.remove(matchId);
                          calculateWinAmount();
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        color: AppColors.cardBackground,
                        child: ListTile(
                          title: Text(
                            "${match.team1.name} vs ${match.team2.name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Starts: ${match.getDateFormatted}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.activeColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Column(
                                    children: [
                                      Text(
                                        match.odds.oddsNames[betType]!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        odd.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Available money: ${globalModel.getMoney}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Multiplier: ${multiplier.toStringAsFixed(2)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Potential win: ${winAmount.toStringAsFixed(2)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: stakeController,
                onChanged: (value) {
                  calculateWinAmount(); // This will update winAmount based on new input
                },
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(color: Colors.white),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  floatingLabelStyle: const TextStyle(color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                  labelStyle: const TextStyle(color: AppColors.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  labelText: "Stake Amount",
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () async {
                  final stake = double.tryParse(stakeController.text);
                  if (globalModel.bets.isEmpty) {
                    ScaffoldMessenger.of(
                      Navigator.of(context).context,
                    ).showSnackBar(
                      const SnackBar(content: Text("No beats available")),
                    );
                    return;
                  }
                  if (stake == null ||
                      stake <= 0 ||
                      stake > globalModel.money ||
                      globalModel.money - stake < 0) {
                    ScaffoldMessenger.of(
                      Navigator.of(context).context,
                    ).showSnackBar(
                      const SnackBar(content: Text("Enter valid money")),
                    );
                    return;
                  }

                  await betStake(context, stake);

                  globalModel.clearBets();
                  globalModel.removeMoney(stake);
                  stakeController.clear();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  fixedSize: Size(150.w, 50.h),
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: const Text("Place Bets"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
