import 'team.dart';
import 'dart:convert';

class LeagueTable {
  final List<Team> teams;
  final Map<int, int> playedMatches;
  final Map<int, int> wins;
  final Map<int, int> draws;
  final Map<int, int> losses;
  final Map<int, int> goalsFor;
  final Map<int, int> goalsAgainst;
  final Map<int, int> points;

  LeagueTable({
    required this.teams,
    required this.playedMatches,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  bool isTeamInTable(int teamId) {
    return teams.any((team) => team.id == teamId);
  }

  factory LeagueTable.parseTableFromJson(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);

    final List<Team> teams = [];
    final Map<int, int> playedMatches = {};
    final Map<int, int> wins = {};
    final Map<int, int> draws = {};
    final Map<int, int> losses = {};
    final Map<int, int> goalsFor = {};
    final Map<int, int> goalsAgainst = {};
    final Map<int, int> points = {};

    for (var item in data) {
      final clubId = item['club_id'];
      final team = Team.fromJson(item['club']);
      teams.add(team);

      playedMatches[clubId] = item['played'];
      wins[clubId] = item['won'];
      draws[clubId] = item['drawn'];
      losses[clubId] = item['lost'];
      goalsFor[clubId] = item['goals_for'];
      goalsAgainst[clubId] = item['goals_against'];
      points[clubId] = item['points'];
    }

    return LeagueTable(
      teams: teams,
      playedMatches: playedMatches,
      wins: wins,
      draws: draws,
      losses: losses,
      goalsFor: goalsFor,
      goalsAgainst: goalsAgainst,
      points: points,
    );
  }

  Team getTeamById(int teamId) {
    return teams.firstWhere(
      (team) => team.id == teamId,
      orElse: () => throw Exception('Team not found'),
    );
  }

  int played(int teamId) {
    return playedMatches[teamId] ?? 0;
  }

  int won(int teamId) {
    return wins[teamId] ?? 0;
  }

  int drawn(int teamId) {
    return draws[teamId] ?? 0;
  }

  int lost(int teamId) {
    return losses[teamId] ?? 0;
  }

  String getGoals(int teamId) {
    return '${goalsFor[teamId]?.toString() ?? '0'}:${goalsAgainst[teamId]?.toString() ?? '0'}';
  }

  int getPoints(int teamId) {
    return points[teamId] ?? 0;
  }
}
