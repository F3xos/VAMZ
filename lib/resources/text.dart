import 'package:flutter/material.dart';

class AppStrings {
  static const loginButtonText = "Sing In";
  static const loginFailed = "Login failed";
  static const dontHaveAcc = "Don\'t have an account?";
  static const registerFailed = "Registration failed";
  static const usernameFieldText = "Username";
  static const passwordFieldText = "Password";
  static const emailFieldText = "E-mail";
  static const logoutButtonText = "Logout";
  static const registerButtonText = "Sign Up";
  static const passwordCheckChar = "Contains at least 6 characters";
  static const passwordLetterCheck = "Contains at least 1 big letter";
  static const passwordNumberCheck = "Contains at least 1 number";
  static const accountText = "Account";
  static const resetMoneySucc = "Reset money succesfull";
  static const noTickets = "You don\'t have any tickets";
  static const homeScreenTitle = "Matchboard";
  static const sportsScreenTitle = "Tables";
  static const ticketsScreenTitle = "Tickets";
  static const statsScreenTitle = "Statistics";
}

class AppColors {
  static const Color backgroundColor = Color.fromARGB(255, 40, 40, 40);
  static const Color cardBackground = Color.fromARGB(255, 59, 59, 59);
  static const Color activeColor = Color.fromARGB(255, 81, 165, 93);
  static const Color nonActiveColor = Color.fromARGB(255, 100, 100, 100);
  static const Color primary = Color.fromARGB(255, 96, 198, 115);
  static const Color inGame = Color.fromARGB(100, 255, 255, 255);
  static const Color winTicket = Colors.green;
  static const Color loseTicket = Colors.red;
  static const Color ticketTextColor = Color.fromARGB(186, 147, 147, 147);
}

class AppApiUrls {
  static const loginUrl = "https://api.smartbois.eu/api/login";
  static const meUrl = "https://api.smartbois.eu/api/me";
  static const registerUrl = "https://api.smartbois.eu/api/register";
  static const matchesUrl = "https://api.smartbois.eu/api/matches/";
  static const ticketsUrl = "https://api.smartbois.eu/api/tickets";
  static const nationalityUrl = "https://api.smartbois.eu/api/nationality";
  static const leagueUrl = "https://api.smartbois.eu/api/leagues/country/";
  static const resetMoneyUrl = "https://api.smartbois.eu/api/acc/reset-money/";
  static const accUrl = "https://api.smartbois.eu/api/tickets/acc/";
  static const tablesUrl = "https://api.smartbois.eu/api/tables/";
  static const statsUrl = "https://api.smartbois.eu/api/tickets/stats/";
}
