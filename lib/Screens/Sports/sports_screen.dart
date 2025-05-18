import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/team_data_source.dart';
import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/modals/account_model.dart';
import 'package:bet_trial/widgets/models/table.dart';
import 'package:bet_trial/widgets/models/league.dart';
import 'package:bet_trial/widgets/models/country.dart';
import 'package:bet_trial/widgets/modals/country_modal.dart';
import 'package:bet_trial/widgets/modals/league_modal.dart';
import 'package:bet_trial/resources/text.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() {
    return _SportsScreenState();
  }
}

class _SportsScreenState extends State<SportsScreen> {
  Country? _selectedCountry;
  League? _selectedLeague;
  LeagueTable? leagueTable;

  void _openCategorySelect(String type) {
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        switch (type) {
          case 'country':
            return SelectCountryModal(
              selectCountry: _selectCountry,
              selectedCountry: _selectedCountry,
              resetCountry: _resetCountry,
            );
          case 'league':
            return SelectLeagueModal(
              selectLeague: _selectLeague,
              resetLeague: _resetLeague,
              selectedLeague: _selectedLeague,
              selectedCountry: _selectedCountry!,
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  void _selectCountry(Country selectedCountry) {
    setState(() {
      _selectedCountry = selectedCountry;
      _resetLeague();
    });
  }

  void _selectLeague(League selectedLeague) {
    setState(() {
      _selectedLeague = selectedLeague;
      getTable();
    });
  }

  void _resetCountry() {
    setState(() {
      _selectedCountry = null;
      _resetLeague();
    });
  }

  void _resetLeague() {
    setState(() {
      _selectedLeague = null;
      leagueTable = null;
    });
  }

  Future<void> getTable() async {
    try {
      final response = await http.get(
        Uri.parse('${AppApiUrls.tablesUrl}${_selectedLeague?.id}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        leagueTable = LeagueTable.parseTableFromJson(response.body);
        setState(() {
          leagueTable = leagueTable;
        });
      } else {
        throw Exception('Failed to load matches');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 100.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.sportsScreenTitle,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<GlobalModel>(
                      builder: (context, globalModel, _) {
                        return Text(
                          '${globalModel.getMoney.toStringAsFixed(2)}\$',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.backgroundColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => AccountModal(),
                        );
                      },
                      tooltip: 'Profile',
                      icon: const Icon(
                        Icons.account_circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      (_selectedCountry == null)
                          ? const Color.fromARGB(255, 102, 102, 102)
                          : AppColors.primary,
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color:
                              (_selectedCountry == null)
                                  ? const Color.fromARGB(255, 102, 102, 102)
                                  : AppColors.primary,
                          width: 2.0.w,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () => _openCategorySelect('country'),
                  child:
                      (_selectedCountry == null)
                          ? Text(
                            'Choose country',
                            style: TextStyle(fontSize: 15.sp),
                          )
                          : _selectedCountry!.getCountryWidgetCompact,
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      (_selectedLeague == null)
                          ? const Color.fromARGB(255, 102, 102, 102)
                          : AppColors.primary,
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color:
                              (_selectedLeague == null)
                                  ? const Color.fromARGB(255, 102, 102, 102)
                                  : AppColors.primary,
                          width: 2.0.w,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_selectedCountry != null) {
                      _openCategorySelect('league');
                    }
                  },
                  child:
                      (_selectedLeague == null)
                          ? Text(
                            'Choose league',
                            style: TextStyle(fontSize: 15.sp),
                          )
                          : _selectedLeague!.getLeagueWidgetCompact,
                ),
              ],
            ),
          ],
        ),
      ),
      body:
          (leagueTable == null)
              ? Center(
                child: Text(
                  'Please select a league to view the table',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(headerColor: AppColors.activeColor),
                  child: SfDataGrid(
                    source: TeamDataSource(table: leagueTable!),
                    columnWidthMode: ColumnWidthMode.fill,
                    frozenColumnsCount: 1,
                    headerRowHeight: 30.h,
                    rowHeight: 50.h,
                    headerGridLinesVisibility: GridLinesVisibility.none,
                    gridLinesVisibility: GridLinesVisibility.none,
                    columns: [
                      GridColumn(
                        width: 150.w,
                        columnName: 'Team',
                        label: Center(
                          child: Text(
                            'Team',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'M',
                        label: Center(
                          child: Text(
                            'M',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'W',
                        label: Center(
                          child: Text(
                            'W',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'D',
                        label: Center(
                          child: Text(
                            'D',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'L',
                        label: Center(
                          child: Text(
                            'L',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'G',
                        label: Center(
                          child: Text(
                            'G',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Pts',
                        label: Center(
                          child: Text(
                            'Pts',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
