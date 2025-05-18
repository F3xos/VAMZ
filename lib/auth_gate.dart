import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:bet_trial/resources/text.dart';
import 'package:bet_trial/LoginPage/login_page.dart';
import 'package:bet_trial/main.dart'; // BetTrial
import 'package:bet_trial/widgets/Database/global.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  Widget? nextPage;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _storage.read(key: 'token');

    if (token == null) {
      setState(() {
        nextPage = const LoginPage();
        isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse(AppApiUrls.meUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final account = json.decode(response.body);
      Provider.of<GlobalModel>(context, listen: false).login(token, account);
      setState(() {
        nextPage = const BetTrial();
        isLoading = false;
      });
    } else {
      await _storage.delete(key: 'token');
      setState(() {
        nextPage = const LoginPage();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || nextPage == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Future.microtask(() {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => nextPage!));
    });

    return const SizedBox.shrink(); // renders nothing while navigating
  }
}
