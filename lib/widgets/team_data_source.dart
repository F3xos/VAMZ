import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/models/table.dart';
import 'package:bet_trial/resources/text.dart';

class TeamDataSource extends DataGridSource {
  final LeagueTable table;
  TeamDataSource({required this.table}) {
    _teams =
        table.teams
            .map<DataGridRow>(
              (team) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'Team', value: team.id),
                  DataGridCell<String>(
                    columnName: 'M',
                    value: table.played(team.id).toString(),
                  ),
                  DataGridCell<String>(
                    columnName: 'W',
                    value: table.won(team.id).toString(),
                  ),
                  DataGridCell<String>(
                    columnName: 'D',
                    value: table.drawn(team.id).toString(),
                  ),
                  DataGridCell<String>(
                    columnName: 'L',
                    value: table.lost(team.id).toString(),
                  ),
                  DataGridCell<String>(
                    columnName: 'G',
                    value: table.getGoals(team.id),
                  ),
                  DataGridCell<String>(
                    columnName: 'Pts',
                    value: table.getPoints(team.id).toString(),
                  ),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _teams = [];

  @override
  List<DataGridRow> get rows => _teams;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final team = row.getCells()[0].value as int;
    final teamData = table.getTeamById(team);
    return DataGridRowAdapter(
      color: AppColors.backgroundColor,
      cells:
          row.getCells().asMap().entries.map((entry) {
            final index = entry.key;
            final cell = entry.value;

            if (index == 0) {
              // Club cell with image + text
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Image.network(
                      teamData.image,
                      width: 24.sp,
                      height: 24.sp,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      teamData.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Text(
                cell.value.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
    );
  }
}
