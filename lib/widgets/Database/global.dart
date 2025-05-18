import 'dart:convert';

import 'package:bet_trial/resources/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GlobalModel extends ChangeNotifier {
  // ====== Secure storage ======
  final _storage = const FlutterSecureStorage();

  // ====== App state ======
  Map<int, String> bets = {};
  double money = 0.0;

  double get getMoney => money;
  int get getBetCount => bets.length;
  Map<int, String> get getBets => bets;

  void addMoney(double value) {
    money += value;
    notifyListeners();
  }

  void removeMoney(double value) {
    money -= value;
    notifyListeners();
  }

  void setMoney(double value) {
    money = value;
    notifyListeners();
  }

  bool isBet(int id, String bet) => bets[id] == bet;

  void addBet(int id, String bet) {
    if (isBet(id, bet)) {
      bets.remove(id);
    } else {
      bets[id] = bet;
    }
    notifyListeners();
  }

  void removeBet(int matchId) {
    bets.remove(matchId);
    notifyListeners();
  }

  void clearBets() {
    bets.clear();
    notifyListeners();
  }

  // ====== Auth and account ======
  String? _token;
  Map<String, dynamic>? _accountData;

  String? get token => _token;
  Map<String, dynamic>? get account => _accountData;
  bool get isAuthenticated => _token != null;

  Future<void> resetMoney() async {
    final url = Uri.parse('${AppApiUrls.resetMoneyUrl}${_accountData!['id']}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setMoney(1000.00);
      } else {
        print("Failed to fetch account: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> refreshAccountData() async {
    final url = Uri.parse(AppApiUrls.meUrl);

    if (_token == null) {
      print("No token found");
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Update account data in GlobalModel
        _accountData = data;
        setMoney(double.parse(_accountData!['money'].toString()));
      } else {
        print("Failed to fetch account: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> login(String token, Map<String, dynamic> accountFromApi) async {
    _token = token;
    _accountData = accountFromApi;

    final dynamic moneyValue = accountFromApi['money'];

    if (moneyValue is int) {
      money = moneyValue.toDouble();
    } else if (moneyValue is double) {
      money = moneyValue;
    } else if (moneyValue is String) {
      money = double.tryParse(moneyValue) ?? 0.0;
    } else {
      money = 0.0;
    }

    await _storage.write(key: 'token', value: token);

    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _accountData = null;
    money = 0.0;
    await _storage.delete(key: 'token');
    notifyListeners();
  }

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'token');
    notifyListeners();
  }
}
