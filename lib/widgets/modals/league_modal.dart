import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/models/country.dart';
import 'package:bet_trial/widgets/models/league.dart';
import 'package:bet_trial/widgets/modals/modal_item.dart';
import 'package:bet_trial/resources/text.dart';

class SelectLeagueModal extends StatefulWidget {
  //Variables
  final Function(League) selectLeague;
  final Country selectedCountry;
  final League? selectedLeague;
  final Function resetLeague;

  const SelectLeagueModal({
    super.key,
    required this.selectLeague,
    required this.selectedLeague,
    required this.selectedCountry,
    required this.resetLeague,
  });

  @override
  State<SelectLeagueModal> createState() {
    return _SelectLeagueModalState();
  }
}

class _SelectLeagueModalState extends State<SelectLeagueModal> {
  //Variables
  final _searchCountryController = TextEditingController();
  List<League>? leagues;

  @override
  void initState() {
    getLeagues();
    super.initState();
  }

  @override
  void dispose() {
    _searchCountryController.dispose();
    super.dispose();
  }

  Future<void> getLeagues() async {
    final countryId = widget.selectedCountry.id;
    try {
      final response = await http.get(
        Uri.parse('${AppApiUrls.leagueUrl}$countryId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<League> loadedLeagues =
            data.map((item) {
              return League(
                id: item['id'],
                name: item['name'],
                image: item['logo'],
              );
            }).toList();

        setState(() {
          leagues = loadedLeagues;
        });
      } else {
        throw Exception('Failed to load leagues');
      }
    } catch (e) {
      print('Error fetching leagues: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load leagues')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'Choose League from ${widget.selectedCountry.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
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
          ),
          const Divider(
            color: Color.fromARGB(255, 130, 130, 130),
            thickness: 1,
          ),
          SizedBox(height: 10.h),
          (() {
            if (leagues == null) {
              return Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SelectModalItem.sceleton(
                      sceleton: true,
                      reset: () {},
                      isSelected: false,
                    );
                  },
                ),
              );
            } else {
              return Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: leagues!.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        final league = leagues![index];
                        return SelectModalItem.league(
                          league: league,
                          isSelected:
                              (widget.selectedLeague != null)
                                  ? (widget.selectedLeague!.id == league.id)
                                  : false,
                          reset: widget.resetLeague,
                          selectLeague: widget.selectLeague,
                          sceleton: false,
                        );
                      },
                    ),
                    (widget.selectedLeague != null)
                        ? Positioned(
                          bottom: 40.h,
                          right: 0,
                          left: 0,
                          child: FloatingActionButton(
                            backgroundColor: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.resetLeague();
                                Navigator.pop(context);
                              });
                            },
                          ),
                        )
                        : const SizedBox(height: 0),
                  ],
                ),
              );
            }
          }()),
        ],
      ),
    );
  }
}
