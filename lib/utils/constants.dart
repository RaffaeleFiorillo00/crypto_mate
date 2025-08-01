import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF1976D2);
  static const Color accent = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color profit = Color(0xFF4CAF50);
  static const Color loss = Color(0xFFF44336);
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
}

class AppSizes {
  static const double padding = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingLarge = 24.0;
  static const double radius = 8.0;
  static const double radiusLarge = 12.0;
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;
}

class AppStrings {
  static const String appName = 'CryptoMate';
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String or = 'OR';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String dashboard = 'Dashboard';
  static const String portfolio = 'Portfolio';
  static const String addTransaction = 'Add Transaction';
  static const String profile = 'Profile';
  static const String logout = 'Logout';
  static const String symbol = 'Symbol';
  static const String amount = 'Amount';
  static const String price = 'Price';
  static const String date = 'Date';
  static const String type = 'Type';
  static const String buy = 'Buy';
  static const String sell = 'Sell';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String currentValue = 'Current Value';
  static const String totalValue = 'Total Value';
  static const String profitLoss = 'Profit/Loss';
  static const String portfolioValue = 'Portfolio Value';
  static const String noTransactions = 'No transactions yet';
  static const String addYourFirstTransaction = 'Add your first transaction to get started';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String ok = 'OK';
}

class CryptoConstants {
  static const List<String> supportedCryptos = [
    'BTC',
    'ETH',
    'USDT',
    'BNB',
    'SOL',
    'ADA',
    'XRP',
    'DOT',
    'DOGE',
    'AVAX',
    'MATIC',
    'LINK',
    'UNI',
    'LTC',
    'BCH',
    'XLM',
    'ATOM',
    'FTM',
    'ALGO',
    'VET',
  ];
  
  static const Map<String, String> cryptoNames = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'USDT': 'Tether',
    'BNB': 'Binance Coin',
    'SOL': 'Solana',
    'ADA': 'Cardano',
    'XRP': 'Ripple',
    'DOT': 'Polkadot',
    'DOGE': 'Dogecoin',
    'AVAX': 'Avalanche',
    'MATIC': 'Polygon',
    'LINK': 'Chainlink',
    'UNI': 'Uniswap',
    'LTC': 'Litecoin',
    'BCH': 'Bitcoin Cash',
    'XLM': 'Stellar',
    'ATOM': 'Cosmos',
    'FTM': 'Fantom',
    'ALGO': 'Algorand',
    'VET': 'VeChain',
  };
} 